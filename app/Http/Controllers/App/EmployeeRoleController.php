<?php

namespace App\Http\Controllers\App;

use App\Models\EmployeeRole;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;


class EmployeeRoleController extends Controller {



    public function get(Request $request)
    {

        $query = DB::table('employee_roles')->selectRaw("employee_roles.*");

        if ($request->id) $query->where('employee_roles.id',$request->id);

        if ($request->description) $query->where('employee_roles.description',$request->description);

        if ($request->code) $query->where('employee_roles.code',$request->code);        

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
            'description.required' => 'Please specify a description for this Role',
            'code.required' => 'Please specify a code to uniquely identify this Role',
            'code.unique' => 'This Code is being used by another Role',
        ];

        if ( isset($request->id) )$rules['code'] = ['required',Rule::unique('employee_roles')->ignore($request->id)];

        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = isset($request->id) ? EmployeeRole::findOrFail($request->id) : new EmployeeRole;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('employee_roles',$request->description);            

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

        return DB::table('employee_roles')
        ->where('code','<',$request->code)
        ->orderBy('code')
        ->count();

    }


    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, EmployeeRole::class);
    }


}
