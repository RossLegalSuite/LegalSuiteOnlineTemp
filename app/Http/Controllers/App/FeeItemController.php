<?php

namespace App\Http\Controllers\App;

use App\Models\FeeItem;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use App\Rules\ValidNumber;
use Illuminate\Support\Facades\Validator;

class FeeItemController extends Controller {


    private function addColumns(&$query, $request)
    {

        $query->addSelect('fee_items.id');
        $query->addSelect('fee_items.description');

        $query->addSelect('fee_items.taxRateId');

        if ($request->dataFormat === "dataTables") {
            $query->addSelect(DB::raw( "FORMAT(amount, 2, 'en_" . session('countryCode')  . "') as amount") );
            $query->addSelect(DB::raw( "FORMAT(taxAmount, 2, 'en_" . session('countryCode')  . "') as taxAmount") );
            $query->addSelect(DB::raw( "FORMAT(totalAmount, 2, 'en_" . session('countryCode')  . "') as totalAmount") );
            $query->addSelect(DB::raw( "FORMAT(maximumAmount, 2, 'en_" . session('countryCode')  . "') as maximumAmount") );
        } else {
            $query->addSelect('amount');
            $query->addSelect('taxAmount');
            $query->addSelect('totalAmount');
            $query->addSelect('maximumAmount');
        }


        $query->addSelect('fee_items.sorter');
        $query->addSelect('fee_items.type');
        $query->addSelect('fee_items.feeCodeId');
        $query->addSelect('fee_items.fromDate');
        $query->addSelect('fee_items.toDate');
        $query->addSelect('fee_items.fromAmount');
        $query->addSelect('fee_items.toAmount');
        $query->addSelect('fee_items.unitsFlag');
        $query->addSelect('fee_items.unitsId');
        $query->addSelect('fee_items.unitsFactor');

        $query->addSelect('fee_codes.code as feeCodeCode');
        $query->addSelect('fee_codes.description as feeCodeDescription');
        $query->addSelect('fee_units.description as unitsDescription');
        

    }

    private function addTableJoins(&$query)
    {
        $query
        ->join('fee_codes', 'fee_codes.id', '=', 'fee_items.feeCodeId')
        ->leftJoin('fee_units', 'fee_units.id', '=', 'fee_items.unitsId');
    }


    public function get(Request $request)
    {

        $query = DB::table('fee_items');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->parentId) $query->where('fee_items.feeCodeId',$request->parentId);

        if ($request->id) $query->where('fee_items.id',$request->id);

        if ($request->code) $query->where('fee_items.code',$request->code);

        if ($request->description) $query->where('fee_items.description',$request->description);


        if ($request->dataFormat === "dataTables") {

            $query->orderBy('fee_items.sorter');

        }


        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }


    // public function getFeeSheets(Request $request)
    // {

    //     $returnData = new \stdClass();

    //     $query = DB::table('feeitem_feesheet')
    //     ->join('fee_sheets', 'fee_sheets.id', '=', 'feeitem_feesheet.feeSheetId')
    //     ->addSelect('fee_sheets.id')
    //     ->addSelect('fee_sheets.description')
    //     ->orderBy('fee_sheets.description')
    //     ->where('feeitem_feesheet.feeItemId',$request->id);

    //     $returnData->feesheets = $query->get()->toArray();

    //     return json_encode($returnData);


    // }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'feeCodeId' => 'required',
            'taxRateId' => 'required',
            'description' => 'required',
            'amount' => new ValidNumber,
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Fee Item',
            //'unitsId.required' => 'Please specify the type of units',
            //'unitsFactor.required' => 'Please specify the unit factor',
        ];


        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }

        // In case the user ticks the unitsFlag but doesn't select a unit
        // Easier than trying to display errors on another tab

        if ( isset($request->unitsFlag) && $request->unitsFlag == 1 ) {

            if ( !isset($request->unitsId) ) {
                $request->unitsFlag = 0;
            } else {
                if ( !isset($request->unitsFactor) ) {
                    $request->unitsFactor = 1;
                }
            }
            //$rules['unitsId'] = 'required';
            //$rules['unitsFactor'] = 'required';
        }
        
        // Set the Sorter
        if ( isset($request->id)) {

            $sorter = $request->sorter;

        } else {

            $counter = FeeItem::where('feeCodeId',$request->feeCodeId)->count();
            
            $counter++;

            while($counter <= 5000) {

                $existingRecord = FeeItem::where('feeCodeId',$request->feeCodeId)
                ->where('sorter',$counter)
                ->first();

                if (!$existingRecord) break;

                $counter++;
                
            }

            $sorter = $counter;

        }        

        try {

            $record = isset($request->id) ? FeeItem::findOrFail($request->id) : new FeeItem;

            //Keep this in sync in FeeCodeController when copying a FeeCode
            $record->id = $request->id;
            $record->feeCodeId = $request->feeCodeId;
            $record->description = $request->description;
            $record->taxRateId = $request->taxRateId;
            $record->amount = $request->amount;
            $record->taxAmount = $request->taxAmount;
            $record->type = $request->type;
            $record->sorter = $sorter;
            $record->fromDate = isset($request->fromDate) ? Utils::convertDate($request->fromDate) : null;
            $record->toDate = isset($request->toDate) ? Utils::convertDate($request->toDate) : null;
            $record->fromAmount = $request->fromAmount;
            $record->toAmount = $request->toAmount;
            $record->maximumAmount = $request->maximumAmount;
            $record->unitsFlag = $request->unitsFlag;
            $record->unitsId = $request->unitsId;
            $record->unitsFactor = $request->unitsFactor;

            $record->save();

            //Check the sort order (in case a FeeItem is deleted and the sort order doesn't start at 1)
            $this->checkSortOrder($request);

            return json_encode($record);            
    
        } catch (\Illuminate\Database\QueryException $e) {

            $validator->errors()->add('general', Utils::MySqlError($e));

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        } catch(\Exception $e)  {

            $validator->errors()->add('general', $e->getMessage());

            $returnData->errors = $validator->errors();
            return json_encode($returnData);

        }

    }

    private function checkSortOrder($request)

    {

        $feeItems = FeeItem::where('feeCodeId',$request->feeCodeId)
        ->orderBy('sorter')
        ->get();

        $correctSorter = 0;

        foreach ($feeItems as $feeItem) {

            $correctSorter++;

            if ( (int) $feeItem->sorter !== $correctSorter) {

                $feeItem->sorter = $correctSorter;
                $feeItem->save();

            }
            
        }        
    }        




    public function moveUp(Request $request)
    {

        $returnData = new \stdClass();
        $returnData->error = null;

        try {

            return DB::transaction( function() use ($returnData, $request)
            {

                $feeItem1 = FeeItem::find($request->id);
        
                $feeItem2 = FeeItem::where('feeCodeId',$feeItem1->feeCodeId)
                ->where('sorter',$feeItem1->sorter - 1)
                ->first();

                if ( !$feeItem1 ) {

                    $returnData->error = 'First Fee Item not found';

                } else if ( !$feeItem2 ) {

                    $returnData->error = 'Second Fee Item not found';

                } else {
        
                    $sorter1 = $feeItem1->sorter;
                    $sorter2 = $feeItem2->sorter;
            
                    $feeItem1->sorter = $sorter2;
                    $feeItem1->save();
            
                    $feeItem2->sorter = $sorter1;
                    $feeItem2->save();

                }

                return json_encode($returnData);

            });
    
        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = Utils::MySqlError($e);
            return json_encode($returnData);            

        }

    }

    public function getTablePosition(Request $request)
    {

        return FeeItem::where('sorter','<',$request->sorter)
        ->orderBy('sorter')
        ->count();

    }


    public function destroy(Request $request)
    {

        $returnData = new \stdClass();
        $returnData->error = null;

        try {

            $feeItem = FeeItem::findOrFail($request->id);
            $feeItem->delete();

            //Check the sort order (in case the sort order doesn't start at 1)
            $this->checkSortOrder($feeItem);

            return json_encode($returnData);

            
        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = Utils::MySqlError($e);
            return json_encode($returnData);            
            
        } catch(\Exception $e)  {

            $returnData->error = $e->getMessage();
            return json_encode($returnData);

        }

    }


}
