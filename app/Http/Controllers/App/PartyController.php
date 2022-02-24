<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use App\Custom\Utils;
use Illuminate\Support\Facades\Validator;

class PartyController extends Controller {

    /* Using Generic Controller 
    public function get(Request $request)
    {
        try {

            $apiUrl = "/party/get";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData['errors'] = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function store(Request $request)
    {

        $returnData = new \stdClass();

        if ( isset($request->emailaddress) ) {

            $rules = [
                'emailaddress' => 'email',
            ];

            $messages = [
                'emailaddress.email' => 'Invalid email address',
            ];


            $validator = Validator::make($request->all(), $rules, $messages); 
            
            if ($validator->fails()) {

                $returnData->error = $validator->errors();
                return json_encode($returnData);            

            }

        }

        try {

            if ( isset($request->recordid) ) {
                $apiUrl = "/party/{$request->recordid}";
                $customRequest = 'PUT';
            } else {
                $apiUrl = "/party";
                $customRequest = 'POST';
            } 

            $postFields = $request->queryString;

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);

        } catch(\Exception $e)  {

            $returnData->errors = $e->getMessage();
            return json_encode($returnData);

        }

    }*/



}
