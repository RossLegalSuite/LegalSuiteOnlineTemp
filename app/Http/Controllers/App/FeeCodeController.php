<?php

namespace App\Http\Controllers\App;

use App\Models\FeeCode;
use App\Models\FeeNote;
use App\Models\FeeItem;
use App\Models\Disbursement;
use App\Models\Payment;
use App\Models\Company;
use App\Models\Batch;
use App\Models\AccountTransaction;

use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Carbon\Carbon;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class FeeCodeController extends Controller {

    public function get(Request $request)
    {

        $query = DB::table('fee_codes');

        $query->addSelect('fee_codes.*')
        ->addSelect('fee_sheets.id as feeSheetId')
        ->addSelect('fee_sheets.code as feeSheetCode')
        ->addSelect('fee_sheets.description as feeSheetDescription')
        ->join('fee_sheets', 'fee_sheets.id', '=', 'fee_codes.feeSheetId');


        if ($request->id) $query->where('fee_codes.id',$request->id);

        if ($request->parentId) $query->where('fee_codes.feeSheetId',$request->parentId);

        if ($request->code) $query->where('fee_codes.code',$request->code);

        if ($request->description) $query->where('fee_codes.description',$request->description);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }
    
    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'feeSheetId' => 'required',
            'description' => 'required|min:3',
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Fee Code',
            'feeSheetId.required' => 'Please select the Fee Sheet this Fee Code belongs to',
            'code.required' => 'Please specify a code to uniquely identify this Fee Code',
        ];

        if ( isset($request->id) ) $rules['code'] = 'required';

        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            if ( isset($request->copyFlag) && isset($request->copyId) ){

                foreach($request->feeSheets as $feeSheet) {

                    $request->feeSheetId = $feeSheet['id'];

                    $this->storeFeeCode($request);

                }

                $record = new \stdClass();


            } else {

                $record = $this->storeFeeCode($request);

            }


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

    private function storeFeeCode($request) {

        try {

            $record = isset($request->id) ? FeeCode::findOrFail($request->id) : new FeeCode;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('fee_codes',$request->description);

            $record->code = $this->checkDuplicateCode(isset($request->id) ? $request->id : null, $record->code, $request->feeSheetId);
            
            $record->description = $request->description;
            $record->feeSheetId = $request->feeSheetId;

            $record->save();

            if ( isset($request->copyFlag) && isset($request->copyId) ){
                $this->copyFeeItems($record->id, $request->copyId);
            }

            return $record;


        } catch (\Illuminate\Database\QueryException $e) {

            throw new \Exception(Utils::MySqlError($e));

        } catch(\Exception $e)  {

            throw new \Exception($e->getMessage());
            
        }


    }
    public function copyFeeItems($feeCodeId, $copyFromId) {

        $feeItems = DB::table('fee_items')
        ->where('fee_items.feeCodeId',$copyFromId)
        ->get()->toArray();

        foreach($feeItems as $feeItem) {

            //Keep this in sync with FeeItem store() method
            FeeItem::create([
                'feeCodeId' => $feeCodeId,
                'description' => $feeItem->description,
                'taxRateId' => $feeItem->taxRateId,
                'amount' => $feeItem->amount,
                'taxAmount' => $feeItem->taxAmount,
                'type' => $feeItem->type,
                'sorter' => $feeItem->sorter,
                'fromDate' => isset($feeItem->fromDate) ? Utils::convertDate($feeItem->fromDate) : null,
                'toDate' => isset($feeItem->toDate) ? Utils::convertDate($feeItem->toDate) : null,
                'fromAmount' => $feeItem->fromAmount,
                'toAmount' => $feeItem->toAmount,
                'maximumAmount' => $feeItem->maximumAmount,
                'unitsFlag' => $feeItem->unitsFlag,
                'unitsId' => $feeItem->unitsId,
                'unitsFactor' => $feeItem->unitsFactor,
            ]);

        }

    }

    private function checkDuplicateCode($id, $code, $feeSheetId) {

        $query = FeeCode::where('code', $code)
        ->where('feeSheetId', $feeSheetId);

        if ( isset($id) ) {
            $query->where('id', '!=' ,$id);
        }

        $counter = $query->count();

        if ($counter) {

            while($counter <= 5000) {

                $existingQuery = FeeCode::where('code',$code . $counter)
                ->where('feeSheetId', $feeSheetId);

                if ( isset($id) ) {
                    $existingQuery->where('id', '!=' ,$id);
                }

                $existingRecord = $existingQuery->first();

                if (!$existingRecord) break;

                $counter++;
                
            }

            return $code . $counter;

        } else {

            return $code;

        }

    }

    public function getFeeItems(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $query = DB::table('fee_items')
            ->leftJoin('fee_units', 'fee_units.id', '=', 'fee_items.unitsId')
            ->leftJoin('tax_rates', 'tax_rates.id', '=', 'fee_items.taxRateId')
            ->addSelect('fee_items.*')
            ->selectRaw("'1' as unitsAmount")
            ->addSelect('fee_units.description as unitsDescription')
            ->addSelect('tax_rates.rate as taxRatePercentage')
            ->addSelect('fee_units.singular as unitsSingular')
            ->addSelect('fee_units.plural as unitsPlural')
            ->orderBy('fee_items.sorter');
            
            // The selected array is empty if ALL Fee Codes are selected
            // This is because of paging - the user cannot physically tag ALL rows
            // In this case, the FeeSheetId is sent to select all Fee Codes for this Fee Sheet

            if ( count($request->feeCodes) ) {
                $query->whereIn('fee_items.feeCodeId',$request->feeCodes);
            } else {
                $query->join('fee_codes', 'fee_codes.id', '=', 'fee_items.feeCodeId')
                ->where('fee_codes.feeSheetId',$request->feeSheetId);
            }

            $returnData->feeItems = $query->get()->toArray();

        } catch(\Exception $e)  {
            
            $returnData->error = "<p>An error was encountered trying to add Fee Notes from Fee Codes.</p><p>" . $e->getMessage() . "</p>";

            return json_encode($returnData);
            
        }

        return json_encode($returnData);

    }

    public function addFeeNotes(Request $request)
    {

        $returnData = new \stdClass();
        $addedFeeNote = new \stdClass();
        $returnData->feeNoteCounter = 0;
        $returnData->disbursementCounter = 0;

        $returnData->addedFeeNote = $addedFeeNote;

        try {

            if ( isset($request->feeItems) ) {

                foreach($request->feeItems as $feeItem) {

                    $feeItem['description'] = $this->createFeeNoteDescription($feeItem);

                    if ( $feeItem['type'] === 'Fee') {

                        $returnData->feeNoteCounter++;
                                
                        // Get first Fee Note added to display in table
                        $feeNote = $this->addFeeNote($request->matterId, $feeItem);

                        if ( !isset($returnData->addedFeeNote->id) ) {

                            $returnData->addedFeeNote->id = $feeNote->id;
                            $returnData->addedFeeNote->date = $feeNote->date;
                        }

                    } elseif ( $feeItem['type'] === 'Disbursement' ) {

                        $returnData->disbursementCounter++;

                        $this->addDisbursement($request->matterId, $feeItem);

                    } else {
            
                        throw new \Exception('Unknown FeeItem type: ' . $feeItem['type']);
                    }

                }

            }

        } catch(\Exception $e)  {
            
            $returnData->error = "<p>An error was encountered trying to add Fee Notes from Fee Codes.</p><p>" . $e->getMessage() . "</p>";

            return json_encode($returnData);
            
        }

        return json_encode($returnData);

    }


    private function createFeeNoteDescription($feeItem)
    {
        $returnValue = $feeItem['description'];

        if ( $feeItem['unitsFlag'] == 1 ) {

            if ( isset($feeItem['customUnitsAmount']) ) {

                $feeItem['unitsAmount'] = $feeItem['customUnitsAmount'];
                
            }

            $unitsAmount = (int)$feeItem['unitsAmount'];

            if ( $unitsAmount === 1 ) {

                $returnValue .= ' (1 ' . $feeItem['unitsSingular'] . ')';

            } else {
                
                $returnValue .= ' (' . $feeItem['unitsAmount'] . ' ' . $feeItem['unitsPlural'] . ')';

            }

        }

        return $returnValue;

    }

    private function addFeeNote($matterId, $feeItem)
    {

        try {

            $record = new FeeNote;
        
            $record->date = Utils::convertDateTime($feeItem['dateTime']);
            $record->matterId = $matterId;
            $record->createdById = session('employeeId');
            $record->allocatedToId = $feeItem['allocatedToId'];
            $record->taxRateId = $feeItem['taxRateId'];
            $record->description = $feeItem['description'];
            $record->amount = $feeItem['amount'];
            $record->taxAmount = $feeItem['taxAmount'];

            $record->save();

            return $record;

        } catch (\Illuminate\Database\QueryException $e) {

            throw new \Exception(Utils::MySqlError($e));

        } catch(\Exception $e)  {

            throw new \Exception($e->getMessage());
            
        }

    }

    private function addDisbursement($matterId, $feeItem)
    {

        try {
            
            // Note: This code is taken from DisbursementController
            return DB::transaction( function() use ($matterId, $feeItem)
            {

                $company = Company::first();
                $date = date("Y-m-d H:i:s");

                $batch = Batch::create([
                    'date' => $date,
                    'employeeId' => session('employeeId'),
                    'type' => 'Payment',
                    'reference' => $feeItem['description'],
                ]);

                $payment = Payment::create([                
                    'createdById' => session('employeeId'),
                    'date' => $date,
                    'method' => 'EFT',
                    'type' => 'Disbursement',
                    'posted' => 1,
                    'bankAccountId' => $company->businessBankAccountId,
                    'matterId' => $matterId,
                    'description' => $feeItem['description'],
                    'taxRateId' => $feeItem['taxRateId'],
                    'amount' => $feeItem['amount'],
                    'taxAmount' => $feeItem['taxAmount'],
                ]);


                $disbursement = Disbursement::create([
                    'date' => Utils::convertDateTime($feeItem['dateTime']),
                    'matterId' => $matterId,
                    'createdById' => session('employeeId'),
                    'bankAccountId' => $company->businessBankAccountId,
                    'batchId' => $batch->id,
                    'taxRateId' => $feeItem['taxRateId'],
                    'description' => $feeItem['description'],
                    'amount' => $feeItem['amount'],
                    'taxAmount' => $feeItem['taxAmount'],
                ]);

                // **********************************************
                // Credit (Decrease) Bank Account (Type = Asset)
                // **********************************************
                AccountTransaction::create([
                    'batchId' => $batch->id,
                    'type' => 'Credit',
                    'accountId' => $company->businessBankAccountId,
                    'paymentId' => $payment->id,
                    'amount' => $feeItem['amount'] + $feeItem['taxAmount']
                ]);

                // *********************************************
                // Debit (Increase) Disbursement Recovery Control Account (Type = Asset)
                // *********************************************

                $disbursementChildAccount = Utils::getDisbursementsControlAccount($company->disbursementsControlAccountId, $disbursement->id, $disbursement->description);

                AccountTransaction::create([
                    'batchId' => $batch->id,
                    'type' => 'Debit',
                    'accountId' => $disbursementChildAccount->id,
                    'paymentId' => $payment->id,
                    'amount' => $feeItem['amount'] + $feeItem['taxAmount']
                ]);

            });


        } catch (\Illuminate\Database\QueryException $e) {

            throw new \Exception(Utils::MySqlError($e));

        } catch(\Exception $e)  {

            throw new \Exception($e->getMessage());
            
        }

    }

    public function getTablePosition(Request $request)
    {

        return FeeCode::where('code','<',$request->code)
        ->orderBy('code')
        ->count();

    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, FeeCode::class);
    }

}
