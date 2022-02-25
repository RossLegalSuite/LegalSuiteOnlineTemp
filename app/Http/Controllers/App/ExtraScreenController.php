<?php

namespace App\Http\Controllers\App;

use App\Custom\Utils;
use Illuminate\Http\Request;

class ExtraScreenController extends Controller
{
    public function store(Request $request)
    {
        $returnData = new \stdClass();

        try {

            //'M' = select matterid from matfield
            //'D' = select docscreenid, matterid from matdocsc
            //'P' = select docscreenid, partyid  from parfield
            //'R' = select rolescreenid, matpartyid from ParRolSc

            // Check if there is a record (and create one if not)
            if ($request->screenType == 'M') {
                $apiUrl = '/matfield/'.$request->matterId;
            } elseif ($request->screenType == 'D') {
                $apiUrl = '/matdocsc/'.$request->matterId.'/'.$request->docScreenId;
            } elseif ($request->screenType == 'P') {
                $apiUrl = '/parfield/'.$request->partyId.'/'.$request->docScreenId;
            } elseif ($request->screenType == 'R') {
                $apiUrl = '/parrolsc/'.$request->matPartyId.'/'.$request->roleScreenId;
            }

            $existingRecord = Utils::SetCurlParams($apiUrl);

            if (empty($existingRecord->data)) {
                $customRequest = 'POST';
            } else {
                $customRequest = 'PUT';
            }

            //logger('$apiUrl',[$apiUrl,$customRequest]);

            $postFields = $request->queryString;

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }
}
