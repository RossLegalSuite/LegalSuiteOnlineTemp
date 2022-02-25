<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Models\Permission;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PermissionController extends Controller
{
    public function get(Request $request)
    {
        $query = DB::table('permissions')->selectRaw('permissions.*');

        $query->leftJoin('resources', 'resources.id', '=', 'permissions.resourceId');

        $query->addSelect('resources.description as resourceDescription');

        if ($request->parentId) {
            $query->where('permissions.employeeGroupId', $request->parentId);
        }

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $record = Permission::find($request->id);

            $record[$request->column] = $record[$request->column] === 1 ? 0 : 1;

            $record->save();

            return json_encode($record);
        } catch (\Illuminate\Database\QueryException $e) {
            $validator->errors()->add('general', Utils::MySqlError($e));

            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }
    }
}
