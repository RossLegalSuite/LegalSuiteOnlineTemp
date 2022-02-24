<?php

namespace App\Http\Controllers\App;


use Illuminate\Http\Request;
use App\Custom\Utils;

class LolSettingsController extends Controller {

    // public function get(Request $request)
    // {

    //     try {

    //         $apiUrl = "/lolsettings/get";

    //         $response = Utils::SetCurlParams($apiUrl);

    //         return json_encode($response);
    
    //     } catch(\Exception $e)  {
    
    //         $returnData['errors'] = $e->getMessage();
            
    //         return json_encode($returnData);
    
    //     }

    // }


    // public function store(Request $request)
    // {

    //     $returnData = new \stdClass();


    //     try {

    //         $response = Utils::SetCurlParams('/lolsettings/store', 'PUT', $request->queryString);

    //         return json_encode($response);

    //     } catch(\Exception $e)  {

    //         $returnData->errors = $e->getMessage();
    //         return json_encode($returnData);

    //     }

    // }


}
