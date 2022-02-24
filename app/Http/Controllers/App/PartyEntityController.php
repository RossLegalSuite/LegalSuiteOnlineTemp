<?php

namespace App\Http\Controllers\App;

use App\Models\PartyEntity;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class PartyEntityController extends Controller {


    public function get(Request $request)
    {

        $query = DB::table('party_entities');

        $query->addSelect('party_entities.*');

        if ($request->id) $query->where('party_entities.id',$request->id);

        if ($request->code) $query->where('party_entities.code',$request->code);

        if ($request->description) $query->where('party_entities.description',$request->description);

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
            'code.required' => 'Please specify a code to uniquely identify this Entity',
            'code.unique' => 'This Code is being used by another Entity',
        ];

        if ( isset($request->id) )$rules['code'] = ['required',Rule::unique('party_entities')->ignore($request->id)];


        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = isset($request->id) ? PartyEntity::findOrFail($request->id) : new PartyEntity;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('party_entities',$request->description);            

            $record->description = $request->description;

            $record->type = $request->type;

            $record->textColor = $request->textColor;
            $record->backgroundColor = $request->backgroundColor;

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

        return PartyEntity::where('code','<',$request->code)
        ->orderBy('code')
        ->count();

    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, PartyEntity::class);
    }
    
}
