<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\ContactMethod;
use App\Models\CreditorNumber;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CreditorNumberController extends Controller
{
    public function get(Request $request)
    {
        $columns = 'creditor_numbers.id';
        $columns .= ', contact_methods.type';
        $columns .= ', contact_methods.description as method';
        $columns .= ', creditor_numbers.description';
        $columns .= ', creditor_numbers.defaultFlag';

        $query = CreditorNumber::selectRaw($columns)
        ->where('creditor_numbers.creditorId', $request->parentId)
        ->join('contact_methods', 'contact_methods.id', '=', 'creditor_numbers.methodId');

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function getByType(Request $request)
    {
        $columns = 'creditor_numbers.id';
        $columns .= ', creditors.id as creditorId';
        $columns .= ', creditor_numbers.description';
        $columns .= ', creditor_numbers.defaultFlag';

        $query = CreditorNumber::selectRaw($columns)
        ->where('contact_methods.type', $request->type)
        ->join('creditors', 'creditors.id', '=', 'creditor_numbers.creditorId')
        ->join('contact_methods', 'contact_methods.id', '=', 'creditor_numbers.methodId');

        if ($request->orderBy) {
            $query->orderBy('description');
        }

        return DataTablesHelper::ReturnData($query, $request);
    }

    protected function clearOtherDefaultFlags($creditorId, $methodId)
    {
        CreditorNumber::where('creditorId', $creditorId)
        ->where('methodId', $methodId)
        ->update(['defaultFlag' => 0]);
    }

    public function store(Request $request)
    {
        if ($request->method === 'Email') {
            $rules = [
                'description' => 'email|required',
            ];
        } else {
            $rules = [
                'description' => 'string|required|min:4',
            ];
        }

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return $validator->errors()->toJson();
        }

        $data = $request->except(['_token', 'method']);

        $contactMethod = ContactMethod::where('type', $request->method)->first();
        $data['methodId'] = $contactMethod->id;

        if ($request->defaultFlag === '1') {
            $this->clearOtherDefaultFlags($request->creditorId, $contactMethod->id);
        }

        if ($request->id) {
            $creditorNumber = CreditorNumber::find($request->id);
        } else {
            $creditorNumber = new CreditorNumber;
        }

        $creditorNumber->fill($data)->save();
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, CreditorNumber::class);
    }
}
