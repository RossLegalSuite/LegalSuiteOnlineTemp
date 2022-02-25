<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\CompanyNumber;
use App\Models\ContactMethod;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CompanyNumberController extends Controller
{
    public function get(Request $request)
    {
        $columns = 'company_numbers.id';
        $columns .= ', contact_methods.type';
        $columns .= ', contact_methods.description as method';
        $columns .= ', company_numbers.description';
        $columns .= ', company_numbers.defaultFlag';

        $query = CompanyNumber::selectRaw($columns)
        ->join('contact_methods', 'contact_methods.id', '=', 'company_numbers.methodId');

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    protected function clearOtherDefaultFlags($partyId, $methodId)
    {
        CompanyNumber::where('methodId', $methodId)->update(['defaultFlag' => 0]);
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
            $this->clearOtherDefaultFlags($request->partyId, $contactMethod->id);
        }

        if ($request->id) {
            $companyNumber = CompanyNumber::find($request->id);
        } else {
            $companyNumber = new CompanyNumber;
        }

        $companyNumber->fill($data)->save();
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, CompanyNumber::class);
    }
}
