<?php

namespace App\Http\Controllers\App;

use App\Models\DocumentSet;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class DocumentSetController extends Controller {

    public function get(Request $request)
    {

        $returnData = new \stdClass();

        try {

            if ( isset($request->id) ){
                $apiUrl = "/docgen/{$request->id}";
            } else {
                $apiUrl = "/docgen?". urldecode(http_build_query($request->all()));
            }    

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);

        } catch(\Exception $e)  {

            $returnData->errors = $e->getMessage();
            return json_encode($returnData);

        }

    }

    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'description' => 'required',
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Document Set',
        ];

        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $postFields = "Description={$request->description}";

            if ( isset($request->recordid) ) {
                $apiUrl = "/docgen/{$request->recordid}";
                $customRequest = 'PUT';
            } else {
                $apiUrl = "/docgen";
                $customRequest = 'POST';
            } 

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }
    
    }

    public function getTablePosition(Request $request)
    {

        $returnData = new \stdClass();

        try {

            if ( isset($request->id) ){
                $apiUrl = "/docgen/{$request->id}";
            } else {
                $apiUrl = "/docgen?". urldecode("&where[]=docgen.description,<," . str_replace("'","''",$request->description) . "&orderby[]=Description&method=count");
            }    

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function destroy(Request $request) {

        $apiUrl = "/docgen/";
        return DataTablesHelper::destroy($request->id, $apiUrl);

    }

}
