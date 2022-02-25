<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PartyNumberController extends Controller
{
    public function get(Request $request)
    {
        try {
            $apiUrl = '/partele/get';

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }

        /*$returnData = new \stdClass();

        try {

            if ( isset($request->id) ){
                $apiUrl = "/partele/{$request->id}";
            } else {
                $apiUrl = "/partele?". urldecode(http_build_query($request->all()));
            }

            //logger('$apiUrl',[$apiUrl]);

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);

        } catch(\Exception $e)  {

            $returnData->errors = $e->getMessage();
            return json_encode($returnData);

        }*/
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        if ($request->method === 'Email') {
            $rules = [
                'number' => 'email|required',
            ];
        } else {
            $rules = [
                'number' => 'string|required|min:4',
            ];
        }

        $messages = [
            'number.required' => 'Please specify a Contact Method',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return $validator->errors()->toJson();
        }

        try {
            if (isset($request->recordid)) {
                $apiUrl = "/partele/{$request->recordid}";
                $customRequest = 'PUT';
            } else {
                $apiUrl = '/partele';
                $customRequest = 'POST';
            }
            //unset($request['recordid']);

            $postFields = $request->queryString;

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function destroy(Request $request)
    {
        $apiUrl = '/partele/';

        return DataTablesHelper::destroy($request->id, $apiUrl);
    }
}
