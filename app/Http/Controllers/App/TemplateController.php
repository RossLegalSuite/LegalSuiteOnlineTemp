<?php

namespace App\Http\Controllers\App;

use Illuminate\Http\Request;
use App\Custom\Utils;

class TemplateController extends Controller {

    public function get(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/systemtemplates/get?id=" . $request->id;

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function index(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/systemtemplates/index";

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

        try {

            if ($request->copyFlag) {
                $request['title'] = $this->generateTitle($request['title']);
            }

            $apiUrl = "/systemtemplates/store";
            if ( isset($request->recordid) ) {
                $customRequest = 'PUT';
            } else {
                $customRequest = 'POST';
            } 
            
            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }
    
    }



    protected function generateTitle($title)
    {

        $title = preg_replace("/ \(Copy(.*?)\)/i", "", $title);

        return $title . ' (Copy' . random_int(100, 999) . ')';


        /*$counter = Template::where('title', 'like', $title . ' (Copy%')
        ->count();

        if ($counter) {

            while($counter <= 5000) {

                $existingRecord = Template::where('title',$title . ' (Copy' . $counter . ')')->first();

                if (!$existingRecord) break;

                $counter++;
                
            }

            return $title . ' (Copy' . $counter . ')';

        } else {

            return $title . ' (Copy)';

        }*/
        
    }

    public function destroy(Request $request)
    {
        //return DataTablesHelper::destroy($request, Template::class);
    }


    public function getTablePosition(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = '/systemtemplates/getTablePosition?title=' . $request['title'];

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }    


}
