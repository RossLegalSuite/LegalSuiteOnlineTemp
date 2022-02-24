<?php

namespace App\Http\Controllers\App;

use App\Models\MarriageType;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class MarriageTypeController extends Controller {

    public function get(Request $request)
    {

        $columns = "marriage_types.id";
        $columns .= ", marriage_types.code";
        $columns .= ", marriage_types.description";

        $query = MarriageType::selectRaw($columns);

        if ($request->id) $query->where('marriage_types.id',$request->id);

        if ($request->description) $query->where('marriage_types.description',$request->description);

        if ($request->code) $query->where('marriage_types.code',$request->code);        

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required|min:4',
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Marriage Type',
            'code.required' => 'Please specify a code to uniquely identify this type of Marriage',
        ];

        if ( isset($request->id) )$rules['code'] = ['required',Rule::unique('marriage_types')->ignore($request->id)];


        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = isset($request->id) ? MarriageType::findOrFail($request->id) : new MarriageType;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('marriage_types',$request->description);            

            $record->description = $request->description;

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

        return MarriageType::where('code','<',$request->code)
        ->orderBy('code')
        ->count();

    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, MarriageType::class);
    }

}
