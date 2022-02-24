<?php

namespace App\Http\Controllers\App;

use App\Models\PartyType;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class PartyTypeController extends Controller {

    public function get(Request $request)
    {

        $query = DB::table('party_types');

        $query->addSelect('party_types.*');

        if ($request->id) $query->where('party_types.id',$request->id);

        if ($request->code) $query->where('party_types.code',$request->code);

        if ($request->description) $query->where('party_types.description',$request->description);

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
            'description.required' => 'Please provide a description',
            'code.required' => 'Please specify a code to uniquely identify this Party Type',
            'code.unique' => 'This Code is being used by another Party Type',
        ];

        if ( isset($request->id) )$rules['code'] = ['required',Rule::unique('party_types')->ignore($request->id)];

        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = isset($request->id) ? PartyType::findOrFail($request->id) : new PartyType;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('party_types',$request->description);            

            $record->description = $request->description;
            
            $record->type = $request->type;

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

        return PartyType::where('code','<',$request->code)
        ->orderBy('code')
        ->count();

    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, PartyType::class);
    }


}
