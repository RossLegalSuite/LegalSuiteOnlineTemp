<?php

namespace App\Http\Controllers\App;

use App\Models\FeeUnit;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class FeeUnitController extends Controller {

    public function get(Request $request)
    {

        $query = DB::table('fee_units');

        $query->addSelect('fee_units.*');

        if ($request->id) $query->where('fee_units.id',$request->id);

        if ($request->code) $query->where('fee_units.code',$request->code);

        if ($request->description) $query->where('fee_units.description',$request->description);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required|min:4',
            'singular' => 'required',
            'plural' => 'required',
        ];

        $messages = [
            'description.required' => 'Please provide a description of this Unit',
            'singular.required' => 'Please provide a description of one of these Units',
            'plural.required' => 'Please provide a description of more than one of these Units',
            'code.required' => 'Please specify a code to uniquely identify this Unit',
            'code.unique' => 'This Code is being used by another Unit',
        ];

        if ( isset($request->id) )$rules['code'] = ['required',Rule::unique('fee_units')->ignore($request->id)];

        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = isset($request->id) ? FeeUnit::findOrFail($request->id) : new FeeUnit;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('fee_units',$request->description);

            $record->description = $request->description;
            $record->singular = $request->singular;
            $record->plural = $request->plural;
            $record->timeBasedFlag = $request->timeBasedFlag;
            $record->minutesPerUnit = $request->minutesPerUnit;

            $record->save();

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

    public function getTablePosition(Request $request)
    {

        return FeeUnit::where('code','<',$request->code)
        ->orderBy('code')
        ->count();

    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, FeeUnit::class);
    }

}
