<?php

namespace App\Http\Controllers\App;

use App\Custom\Utils;
use Illuminate\Http\Request;

class ColDebitController extends Controller
{
    public function get(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $apiUrl = '/matter/getdebtorsaccount?matterid='.$request->matterId;

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }
}
