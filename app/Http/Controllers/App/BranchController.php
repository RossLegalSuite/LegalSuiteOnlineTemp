<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Branch;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class BranchController extends Controller
{
    public function get(Request $request)
    {
        $returnData = new \stdClass();

        try {
            if (isset($request->id)) {
                $apiUrl = "/branch/{$request->id}";
            } else {
                if ($request->method() == 'POST') {
                    $apiUrl = '/branch?'.http_build_query($request->all());
                } else {
                    $url = $request->fullurl();

                    $parsedUrl = parse_url($url);

                    $apiUrl = '/branch?'.$parsedUrl['query'];
                }
            }

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function get_Ettorney(Request $request)
    {
        $query = DB::table('branches');

        $query->addSelect('branches.*');

        if ($request->id) {
            $query->where('branches.id', $request->id);
        }

        if ($request->code) {
            $query->where('branches.code', $request->code);
        }

        if ($request->description) {
            $query->where('branches.description', $request->description);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required',
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Branch',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            if (isset($request->recordid)) {
                $apiUrl = "/branch/{$request->recordid}";
                $customRequest = 'PUT';
            } else {
                $apiUrl = '/branch';
                $customRequest = 'POST';
            }

            unset($request['recordid']);
            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function store_Ettorney(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required|min:4',
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Branch',
            'code.required' => 'Please specify a code to uniquely identify this Branch',
            'code.unique' => 'This Code is being used by another Branch',
        ];

        if (isset($request->id)) {
            $rules['code'] = ['required', Rule::unique('branches')->ignore($request->id)];
        }

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = isset($request->id) ? Branch::findOrFail($request->id) : new Branch;

            $record->code = isset($request->id) ? $request->code : Utils::generateCode('branches', $request->description);

            $record->description = $request->description;

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
        $returnData = new \stdClass();

        try {
            if (isset($request->id)) {
                $apiUrl = "/branch/{$request->id}";
            } else {
                $apiUrl = '/branch?'.urldecode('&where[]=branch.description,<,'.str_replace("'", "''", $request->description).'&orderby[]=Description&method=count');
            }

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function getTablePosition_Ettorney(Request $request)
    {
        return Branch::where('Description', '<', $request->description)
        ->orderBy('Description')
        ->count();
    }

    // try {

    //     $apiUrl = "/branch/{$id}";
    //     $customRequest = 'DELETE';

    //     $response = Utils::SetCurlParams($apiUrl,$customRequest);

    //     return json_encode($response);

    // } catch(\Exception $e)  {

    //     $returnData->errors = $e->getMessage();
    //     return json_encode($returnData);

    // }

    public function destroy(Request $request)
    {
        $apiUrl = '/branch/';

        return DataTablesHelper::destroy($request->id, $apiUrl);
    }

    public function destroy_Verbose(Request $request)
    {
        $returnData = new \stdClass();

        if (is_array($request->id)) {
            foreach ($request->id as $id) {
                try {
                    $apiUrl = "/branch/{$id}";
                    $customRequest = 'DELETE';

                    $response = Utils::SetCurlParams($apiUrl, $customRequest);

                    //return json_encode($response);
                } catch (\Exception $e) {
                    $returnData->errors = $e->getMessage();

                    return json_encode($returnData);
                }
            }

            return json_encode($returnData);
        } else {
            try {
                $apiUrl = "/branch/{$request->id}";
                $customRequest = 'DELETE';

                $response = Utils::SetCurlParams($apiUrl, $customRequest);

                return json_encode($response);
            } catch (\Exception $e) {
                $returnData->errors = $e->getMessage();

                return json_encode($returnData);
            }
        }
    }
}
