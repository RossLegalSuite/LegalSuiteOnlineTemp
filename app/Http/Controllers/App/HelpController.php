<?php

namespace App\Http\Controllers\App;


use Illuminate\Http\Request;


class HelpController extends Controller {

    public function get(Request $request)
    {
        
        $returnData = new \stdClass();

        try {

            $templatePath = base_path() . '/resources/js/pages/help/';

            $returnData->contents = file_get_contents($templatePath . $request->fileName);
    

            return json_encode($returnData);            

        } catch (Exception $e) {

            $returnData->error = $e->getMessage();

            return json_encode($returnData);            

        }  

    }                  

}
