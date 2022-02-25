<?php

namespace App\Http\Controllers\Auth;

use App\Custom\Utils;
use App\Http\Controllers\App\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

//use Illuminate\Database\QueryException;
//use Illuminate\Support\Facades\Hash;
//use Illuminate\Support\Facades\Artisan;
//use Illuminate\Validation\Rule;

class LoginController extends Controller
{
    public function login(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'company' => 'required',
            'login' => 'required',
            'password' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => config('api.url')."/auth?company={$request->company}&login={$request->login}&password={$request->password}&source=lol&docgencode=LOLNEW",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'GET',
            CURLOPT_HTTPHEADER => [
                'authorization: '.config('api.devKey'),
            ],
        ]);

        //logger('Url',[config('api.url') . "/auth?company={$request->company}&login={$request->login}&password={$request->password}&source=lol",]);

        $response = json_decode(curl_exec($curl));

        //logger('$response',[$response]);

        if (curl_errno($curl)) {
            $returnData->errors = '<p>Could not connect to '.config('api.url').'</p><p>Curl Error No: '.curl_errno($curl).'</p><p>'.Utils::getCurlError(curl_errno($curl)).'</p>';
            curl_close($curl);

            return json_encode($returnData);
        } elseif (isset($response->error)) {
            $returnData->errors = $response->error;

            curl_close($curl);

            return json_encode($returnData);
        }

        curl_close($curl);

        if (isset($response->errors)) {
            $returnData->errors = $response->errors;

            return json_encode($returnData);
        } elseif (! isset($response->success)) {
            $returnData->errors = 'Login via the LegalSuite API was not successful';

            return json_encode($returnData);
        }

        if ($response->employee->supervisorflag) {
            $employeeGroupCode = 'supervisor';
        } else {
            $employeeGroupCode = 'user';
        }

        // Note: These are copied to the root object in app.js
        // using initializeData() in the UtilsController.php

        //logger('$response->success',[$response->success]);

        session([
            'region' => 'af-south-1',
            'api_token' => $response->success,
            'employee' => $response->employee,
            'employeeGroupCode' => $employeeGroupCode,
            'companyCode' => $response->company->firmcode,
            'companyName' => $response->company->companyname,
            'employeeId' => $response->employee->recordid,
            'employeeName' => $response->employee->name,
            'employeeEmail' => $response->employee->email,
            'employeeSecGroupId' => $response->employee->secgroupid,
            'employeeUseMatterCostCentreFlag' => $response->employee->usemattercostcentreflag,
            'employeeAllocateToId' => $response->employee->recordid,
            'employeeAllocateToName' => $response->employee->name,
            'secGroupBusinessOption' => $response->secgroup->businessoption,
            'secGroupMatterOption' => $response->secgroup->matteroption,
            'secGroupCreditorOption' => $response->secgroup->creditoroption,
            'secGroupCostCentreOption' => $response->secgroup->costcentreoption,
            'secGroupEmployeeOption' => $response->secgroup->employeeoption,
            'secGroupClientOption' => $response->secgroup->clientoption,
            'secGroupReportOption' => $response->secgroup->reportoption,
            'secGroupSpreadSheetOption' => $response->secgroup->spreadsheetoption,
            'secGroupMatterFileRefFlag' => $response->secgroup->matterfilerefflag,
            'secGroupMatterArchivedFlag' => $response->secgroup->matterarchivedflag,
            'secGroupFinancialAlertsFlag' => $response->secgroup->financialalertsflag,
        ]);

        /*
        SetSecurity     Routine

        Access:SecGroup.UseFile
        SG:RecordId = GLO:SecGroupId
        If Access:SecGroup.Fetch(SG:PrimaryKey)
            If GLO:SupervisorFlag
                Message('Cannot Access Security Setting||Please re-allocated a security group to |yourself (Setup/Employee/Access)','Set Security',ICON:Exclamation)
            Else
                Message('Cannot Access Security Setting||Please get your supervisor to re-allocated a |security group to you. (Setup/Employee/Access)','Set Security',ICON:Exclamation)
            .
        .
        GLO:SecBusinessOption      = SG:BusinessOption
        GLO:SecMatterOption        = SG:MatterOption
        GLO:SecCreditorOption      = SG:CreditorOption
        GLO:SecCostCentreOption    = SG:CostCentreOption
        GLO:SecEmployeeOption      = SG:EmployeeOption
        GLO:SecClientOption        = SG:ClientOption
        GLO:SecSpreadSheetOption   = SG:SpreadSheetOption
        GLO:SecReportOption        = SG:ReportOption
        GLO:SecMatterFileRefFlag   = SG:MatterFileRefFlag
        GLO:SecMatterArchivedFlag  = SG:MatterArchivedFlag
        GLO:SecFinancialAlertsFlag = SG:FinancialAlertsFlag
        */
    }

    public function logout()
    {

        //Remove all data from the session
        session()->flush();

        return route('welcome');
    }
}
