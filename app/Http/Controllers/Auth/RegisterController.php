<?php

namespace App\Http\Controllers\Auth;

use App\Custom\AccountingSeeder;
use App\Custom\Utils;
use App\Http\Controllers\App\Controller;
use App\Models\Employee;
use App\Models\User;
use DB;
use Illuminate\Auth\Events\Registered;
use Illuminate\Database\QueryException;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Validator;

class RegisterController extends Controller
{
    use RegistersUsers;

    public function register(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'name' => 'required',
            'email' => 'required',
            'password' => 'required',
            'password_confirmation' => 'required',
            'dbhost' => 'required',
            'dbport' => 'required',
            'dbdatabase' => 'required',
            'dbusername' => 'required',
            'dbpassword' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        $curl = curl_init();

        // ?company={$request->company}&login={$request->login}&password={$request->password}&source=lol&docgencode=LOLNEW",
        curl_setopt_array($curl, [
            CURLOPT_URL => config('api.url').'/externalregister',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $request->all(),
            CURLOPT_HTTPHEADER => [
                'authorization: '.config('api.devKey'),
            ],
        ]);

        //logger('Url',[config('api.url') . "/auth?company={$request->company}&login={$request->login}&password={$request->password}&source=lol",]);

        $response = json_decode(curl_exec($curl));

        // logger('$response',[$response]);

        if (curl_errno($curl)) {
            $returnData->errors = '<p>Could not connect to '.config('api.url').'</p><p>Curl Error No: '.curl_errno($curl).'</p><p>'.Utils::getCurlError(curl_errno($curl)).'</p>';
            curl_close($curl);

            return json_encode($returnData);
        } elseif (isset($response->errors)) {
            // } else if ( $response->success = 'false' ) {
            logger('$response', [$response]);
            $returnData->errors = $response->errors;

            curl_close($curl);

            return json_encode($returnData);
        }

        curl_close($curl);

        // if ( !isset($response->success) ) {

        // $returnData->errors = 'Registering via the LegalSuite API was not successful';
        // $returnData->response = "#".$response;

        return json_encode($response);

        // }
    }

    public function checkRegister(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'firmcode' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => config('api.url').'/checkregister',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $request->all(),
            CURLOPT_HTTPHEADER => [
                'authorization: '.config('api.devKey'),
            ],
        ]);

        $response = json_decode(curl_exec($curl));
        \logger([$response]);

        if (curl_errno($curl)) {
            $returnData->errors = '<p>Could not connect to '.config('api.url').'</p><p>Curl Error No: '.curl_errno($curl).'</p><p>'.Utils::getCurlError(curl_errno($curl)).'</p>';
            curl_close($curl);

            return json_encode($returnData);
        } elseif (isset($response->errors)) {
            $returnData->errors = $response->errors;
            curl_close($curl);

            return json_encode($returnData);
        } elseif (isset($response->response)) {
            $returnData->response = $response->response;
            curl_close($curl);

            return json_encode($returnData);
        }

        curl_close($curl);

        $returnData->response = $response->success;

        return json_encode($returnData);
    }
}
