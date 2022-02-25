<?php

namespace App\Http\Controllers\App;

use App\Custom\Utils;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LibraryController extends Controller
{
    public function store(Request $request)
    {
        $returnData = new \stdClass();

        if (! isset($request->doNotValidate)) {
            $rules = [
                'description' => 'required',
            ];

            $validator = Validator::make($request->all(), $rules);

            if ($validator->fails()) {
                $returnData->error = $validator->errors();

                return json_encode($returnData);
            }
        }

        try {
            if (isset($request->recordid)) {
                $apiUrl = '/library/update';
            } else {
                $apiUrl = '/library/store';
            }

            $postFields = $request->queryString;

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function getTablePosition(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $apiUrl = '/library/get';

            $postFields['whereRaw'] = $request->whereRaw.' AND description < \''.str_replace("'", "''", $request->description).'\'';
            $postFields['orderby'] = 'description';
            $postFields['method'] = 'count';

            //logger('getTablePosition $postFields',$postFields);

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }
}
