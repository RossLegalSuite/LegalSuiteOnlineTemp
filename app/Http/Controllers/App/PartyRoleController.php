<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\PartyRole;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class PartyRoleController extends Controller
{
    public function get(Request $request)
    {
        $query = DB::table('party_roles');

        $query->addSelect('party_roles.*');

        if ($request->id) {
            $query->where('party_roles.id', $request->id);
        }

        if ($request->code) {
            $query->where('party_roles.code', $request->code);
        }

        if ($request->description) {
            $query->where('party_roles.description', $request->description);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required|min:4',
            'plural' => 'required',
        ];

        $messages = [
            'description.required' => 'Please provide a description',
            'code.required' => 'Please specify a code to uniquely identify this Role',
            'code.unique' => 'This Code is being used by another Role',
            'plural.required' => 'Please provide the plural description',
        ];

        if (isset($request->id)) {
            $rules['code'] = ['required', Rule::unique('party_roles')->ignore($request->id)];
        }

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = isset($request->id) ? PartyRole::findOrFail($request->id) : new PartyRole;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('party_roles', $request->description);

            $record->description = $request->description;
            $record->plural = $request->plural;

            $record->save();

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
        return PartyRole::where('code', '<', $request->code)
        ->orderBy('code')
        ->count();
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, PartyRole::class);
    }
}
