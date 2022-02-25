<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\EmployeeGroup;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class EmployeeGroupController extends Controller
{
    public function get(Request $request)
    {
        $query = DB::table('employee_groups')->selectRaw('employee_groups.*');

        if ($request->id) {
            $query->where('employee_groups.id', $request->id);
        }

        if ($request->description) {
            $query->where('employee_groups.description', $request->description);
        }

        if ($request->code) {
            $query->where('employee_groups.code', $request->code);
        }

        if ($request->code) {
            $query->where('employee_groups.code', $request->code);
        }

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
            'description.required' => 'Please specify a description for this Employee Group',
            'code.required' => 'Please specify a code to uniquely identify this type of Employee Group',
            'code.unique' => 'This Code is being used by another Group',
        ];

        if (isset($request->id)) {
            $rules['code'] = ['required', Rule::unique('employee_groups')->ignore($request->id)];
        }

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = isset($request->id) ? EmployeeGroup::findOrFail($request->id) : new EmployeeGroup;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('employee_groups', $request->description);

            $record->description = $request->description;

            $record->save();

            if (! isset($request->id)) {
                $childQuery = DB::table('resources');

                foreach ($childQuery->cursor() as $resource) {
                    DB::table('permissions')->insert([
                        'employeeGroupId' => $record->id,
                        'resourceId' => $resource->id,
                    ]);
                }
            }

            return json_encode($record);
        } catch (\Illuminate\Database\QueryException $e) {
            $validator->errors()->add('general', Utils::MySqlError($e));
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        } catch (\Exception $e) {
            $validator->errors()->add('general', $e->getMessage());
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('employee_groups')
        ->where('code', '<', $request->code)
        ->orderBy('code')
        ->count();
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, EmployeeGroup::class);
    }
}
