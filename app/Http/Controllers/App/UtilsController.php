<?php

namespace App\Http\Controllers\App;

use Illuminate\Http\Request;
use App\Custom\Utils;

class UtilsController extends Controller {


    // Generic Utils caller
    // To Do: Change others below to use this
    public function call(Request $request, $method)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/" . strtolower($method);

            $postFields = http_build_query($request->all());

            //logger('$postFields',[$postFields]);

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }


    public function getApiKey(Request $request) {

        $returnData = new \stdClass();

        try {

            $postFields = http_build_query($request->all());

            $curl = curl_init();

            curl_setopt_array($curl, array(
                CURLOPT_URL => config('api.url') . "/getapikey",
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_ENCODING => '',
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 0,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => 'POST',
                CURLOPT_POSTFIELDS => $postFields,
                CURLOPT_HTTPHEADER => array(
                    'authorization: ' . config('api.devKey')
                ),
            ));
            
            //logger('Url',[config('api.url') . "/auth?company={$request->company}&login={$request->login}&password={$request->password}&source=lol",]);
    
            $response = json_decode( curl_exec($curl) );
    
            if ( curl_errno($curl) ) {
                
                $returnData->errors = '<p>Could not connect to ' . config('api.url') . '</p><p>Curl Error No: ' . curl_errno($curl) . '</p><p>' . Utils::getCurlError( curl_errno($curl) ) . '</p>'; 
                curl_close($curl);
                return json_encode($returnData);
    
            } else if ( isset($response->error) ) {
    
                $returnData->errors = $response->error;
    
                curl_close($curl);
    
                return json_encode($returnData);            
    
            }     
    
            curl_close($curl);

            session([
                'api_token' => $response->apikey,
                //'region' => 'af-south-1',
                //'companyCode' => $response->company->firmcode,
                //'companyName' => $response->company->companyname,
            ]);
    
    
            return json_encode($response);            

        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function initializeData(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $returnData->companyCode = strtolower( session('companyCode') );
            $returnData->companyName = session('companyName');
            $returnData->loggedInEmployeeId = session('employeeId');
            $returnData->loggedInEmployeeName = session('employeeName');
            $returnData->loggedInEmployeeEmail = session('employeeEmail');
            $returnData->loggedInEmployeeGroupCode = session('employeeGroupCode');
            $returnData->loggedInEmployeeSecGroupId = session('employeeSecGroupId');
            $returnData->loggedInEmployeeUseMatterCostCentreFlag = session('employeeUseMatterCostCentreFlag');
            $returnData->loggedInEmployeeAllocateToId = session('employeeAllocateToId');
            $returnData->loggedInEmployeeAllocateToName = session('employeeAllocateToName');
            $returnData->supervisorFlag = session('employeeGroupCode') === 'supervisor' ? true : false;
            
            $returnData->secGroupBusinessOption      = session('secGroupBusinessOption');
            $returnData->secGroupMatterOption        = session('secGroupMatterOption');
            $returnData->secGroupCreditorOption      = session('secGroupCreditorOption');
            $returnData->secGroupCostCentreOption    = session('secGroupCostCentreOption');
            $returnData->secGroupEmployeeOption      = session('secGroupEmployeeOption');
            $returnData->secGroupClientOption        = session('secGroupClientOption');
            $returnData->secGroupSpreadSheetOption   = session('secGroupSpreadSheetOption');
            $returnData->secGroupReportOption        = session('secGroupReportOption');
            $returnData->secGroupMatterFileRefFlag   = session('secGroupMatterFileRefFlag');
            $returnData->secGroupMatterArchivedFlag  = session('secGroupMatterArchivedFlag');
            $returnData->secGroupFinancialAlertsFlag = session('secGroupFinancialAlertsFlag');
    
            return json_encode($returnData);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function deleteEmployeeTags(Request $request)
    {
        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/deleteemployeetags";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function deleteTagged(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/deletetagged";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function clearTagged(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/cleartagged";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }


    
    public function getCollCommPercentAndLimit(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/getcollcommpercentandlimit?date=70000";
            //$apiUrl = "/utils/getcollcommpercentandlimit?date=" . $request->date;

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function uploadDocLogDocument (Request $request, $recordId) {

        try {

            $apiUrl = "/doclog/upload/" . $recordId;

            $response = Utils::SetCurlParams($apiUrl,'POST');

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData['errors'] = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function getIncomeAccount(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/getincomeaccount";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function getBasicData(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/getbasicdata";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function getFileType(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/getfiletype";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function getMimeType(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $apiUrl = "/utils/getmimetype";

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

}
