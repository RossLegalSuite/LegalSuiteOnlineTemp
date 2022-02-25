<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\MergeColumns;
use App\Custom\Utils;
use App\Models\MatterParty;
use App\Models\MatterPartyExtraScreen;
use App\Models\PartyRole;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

//use Illuminate\Validation\Rule;

class MatterPartyController extends Controller
{
    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $data = $request->all();

        $rules = [
            'matterid' => 'required',
            'partyid' => 'required',
            'roleid' => 'required',
            'sorter' => 'numeric|required',
        ];

        $messages = [
            'matterid.required' => 'No Matter was specified',
            'partyid.required' => 'Please select a Party',
            'roleid.required' => 'Please select a Role for this Party',
            'sorter.required' => 'Please provide a Rank (Sorter) for this Party',
            'sorter.numeric' => 'The Rank must be numeric',
        ];

        $validator = Validator::make($data, $rules, $messages);

        if ($validator->fails()) {
            $returnData->error = $validator->errors();

            return json_encode($returnData);
        }

        try {

            // Check if adding a second Client
            if ($request->roleid == '1') {
                $apiUrl = '/matparty';
                $apiUrl .= '?where[]=MatParty.MatterId,=,'.$request->matterid;
                $apiUrl .= '&where[]=MatParty.RoleId,=,'.$request->roleid;

                if (isset($request->recordid)) {
                    $apiUrl .= '&where[]=MatParty.RecordId,<>,'.$request->recordid;
                }

                //logger('Check if adding a second Client $apiUrl',[$apiUrl]);

                $existingRecord = Utils::SetCurlParams($apiUrl);

                if (! empty($existingRecord->errors)) {
                    $returnData->errors = $existingRecord->errors;

                    return json_encode($returnData);
                } elseif (! empty($existingRecord->data)) {
                    $returnData->errors = '<p>This Matter already has a Client assigned to it.</p><p>A Matter can only have one Client.</p>';

                    return json_encode($returnData);
                }
            }

            // Check for duplicate Party Roles
            $apiUrl = '/matparty';
            $apiUrl .= '?where[]=MatParty.MatterId,=,'.$request->matterid;
            $apiUrl .= '&where[]=MatParty.PartyId,=,'.$request->partyid;
            $apiUrl .= '&where[]=MatParty.RoleId,=,'.$request->roleid;

            if (isset($request->recordid)) {
                $apiUrl .= '&where[]=MatParty.RecordId,<>,'.$request->recordid;
            }

            //logger('Check for duplicate Party Roles',[$apiUrl]);

            $existingPartyRole = Utils::SetCurlParams($apiUrl);

            if (! empty($existingPartyRole->errors)) {
                $returnData->errors = $existingPartyRole->errors;

                return json_encode($returnData);
            } elseif (! empty($existingPartyRole->data)) {
                $returnData->errors = '<p>This Party already plays this Role on this Matter';

                return json_encode($returnData);
            }

            if (isset($request->recordid)) {
                $apiUrl = "/matparty/{$request->recordid}";
                $customRequest = 'PUT';
            } else {
                $apiUrl = '/matparty';
                $customRequest = 'POST';
            }

            $postFields = $request->queryString;

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            $this->refreshSortOrders($request);

            return json_encode($response);
        } catch (\Illuminate\Database\QueryException $e) {
            $validator->errors()->add('general', Utils::MySqlError($e));

            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }
    }

    // Not doing this....!
    /*public function moveUp(Request $request)
    {

        $returnData = new \stdClass();
        $returnData->error = null;

        try {

            $currentParty = Utils::SetCurlParams("/matparty/" . $request->recordId);

            if ( empty($currentParty->data) ) {
                $returnData->error = 'First Party not found';
                return json_encode($returnData);
            }

            $matterParty1 = $currentParty->data[0];

            $previousSorter = (int) $matterParty1->sorter - 1;

            $apiUrl = "/matparty";
            $apiUrl .= "?where[]=MatParty.MatterId,=," . $matterParty1->matterid;
            $apiUrl .= "&where[]=MatParty.RoleId,=," . $matterParty1->roleid;
            $apiUrl .= "&where[]=MatParty.Sorter,=," . $previousSorter;

            $partyAbove = Utils::SetCurlParams($apiUrl);

            if ( empty($partyAbove->data) ) {
                $returnData->error = 'Party above not found';
                return json_encode($returnData);
            }

            $matterParty2 = $partyAbove->data[0];

            $saveMatterParty1Sorter = $matterParty1->sorter;
            $saveMatterParty2Sorter = $matterParty2->sorter;

            $matterParty1->sorter = 0;
            $apiUrl = "/matparty/{$matterParty1->recordid}";
            $response = Utils::SetCurlParams($apiUrl, 'PUT', http_build_query($matterParty1) );

            if ( $response->errors ) {
                $returnData->error = $response->errors;
                return json_encode($returnData);
            }

            logger('$response1',[$response]);

            $matterParty2->sorter = $saveMatterParty1Sorter;
            $apiUrl = "/matparty/{$matterParty2->recordid}";
            $response = Utils::SetCurlParams($apiUrl, 'PUT', http_build_query($matterParty2) );
            logger('$response2',[$response]);

            if ( $response->errors ) {
                $returnData->error = $response->errors;
                return json_encode($returnData);
            }


            $matterParty1->sorter = $saveMatterParty2Sorter;
            $apiUrl = "/matparty/{$matterParty1->recordid}";
            $response = Utils::SetCurlParams($apiUrl, 'PUT', http_build_query($matterParty1) );
            logger('$response3',[$response]);

            if ( $response->errors ) {
                $returnData->error = $response->errors;
                return json_encode($returnData);
            }

            return json_encode($returnData);

        } catch (Exception $e) {

            $returnData->error = $e->getMessage();
            return json_encode($returnData);

        }


    }*/

    public function checkSorter(Request $request)
    {
        $apiUrl = '/matparty';
        $apiUrl .= '?where[]=MatParty.MatterId,=,'.$request->matterid;
        $apiUrl .= '&where[]=MatParty.RoleId,=,'.$request->roleid;
        $apiUrl .= '&where[]=MatParty.Sorter,=,'.$request->sorter;
        $apiUrl .= '&where[]=MatParty.RecordID,<>,'.$request->recordid;

        $duplicateRoleSorter = Utils::SetCurlParams($apiUrl);

        if (! empty($duplicateRoleSorter->data)) {
            $nextSorter = 0;

            $apiUrl = '/matparty';
            $apiUrl .= '?where[]=MatParty.MatterId,=,'.$request->matterid;
            $apiUrl .= '&where[]=MatParty.RoleId,=,'.$request->roleid;
            $apiUrl .= '&orderby[]=MatParty.RoleId';
            $apiUrl .= '&orderby[]=MatParty.Sorter';

            $existingRoles = Utils::SetCurlParams($apiUrl);

            if (! empty($existingRoles->data)) {
                foreach ($existingRoles->data as $matterParty) {
                    $nextSorter = (int) $matterParty->sorter;
                }
            }

            return $nextSorter + 1;
        } else {
            return $request->sorter;
        }
    }

    private function refreshSortOrders($request)
    {
        $apiUrl = '/matparty';
        $apiUrl .= '?where[]=MatParty.MatterId,=,'.$request->matterid;
        $apiUrl .= '&orderby[]=MatParty.RoleId';
        $apiUrl .= '&orderby[]=MatParty.Sorter';

        $existingParties = Utils::SetCurlParams($apiUrl);

        if (! empty($existingParties->data)) {
            $correctSorter = 0;
            $thisRoleId = null;

            foreach ($existingParties->data as $matterParty) {

                //logger('$matterParty roleId/sorter',[$matterParty->roleid,$matterParty->sorter]);

                if ((int) $matterParty->roleid !== $thisRoleId) {
                    $thisRoleId = $matterParty->roleid;
                    $correctSorter = 0;
                }

                $correctSorter++;

                if ((int) $matterParty->sorter !== $correctSorter) {

                    //logger('Correcting',[$matterParty->roleid,$matterParty->sorter, $correctSorter]);

                    $matterParty->sorter = $correctSorter;

                    // Update the MatParty with the correct sorter
                    $apiUrl = "/matparty/{$matterParty->recordid}";
                    $response = Utils::SetCurlParams($apiUrl, 'PUT', http_build_query($matterParty));

                    //logger('Corrected $response',[$response]);
                }
            }
        }
    }

    public function destroy(Request $request)
    {
        $returnData = new \stdClass();
        $returnData->error = null;

        //$clientRole = DB::table('party_roles')->where('code', 'CLI')->first();

        if ($request->roleId == '1' && (int) $request->sorter === '1') {
            $returnData->error = '<p>You cannot delete the Client for a Matter.</p><p>A Matter must have a Client.</p>';

            return json_encode($returnData);
        }

        try {

            //MatterParty::findOrFail($request->id)->delete();

            $matterParty = MatterParty::findOrFail($request->id);
            $matterParty->delete();

            // Adjust the ranking of the other Parties with this Role
            $this->refreshSortOrders($matterParty);

            return json_encode($returnData);
        } catch (\Illuminate\Database\QueryException $e) {
            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function getTablePosition(Request $request)
    {
        /*
        $roleDescription = PartyRole::where('id', $request->roleId )->pluck('description')->first();

        return DB::table('matter_parties')
        ->join('party_roles', 'party_roles.id', '=', 'matter_parties.roleId')
        ->where('matter_parties.matterId', $request->matterId)
        ->where('party_roles.description', '<' , $roleDescription)
        ->where('matter_parties.rank', '<' , $request->rank)
        ->orderBy('party_roles.description')
        ->orderBy('matter_parties.rank')
        ->count();*/

        $returnData = new \stdClass();

        try {
            $apiUrl = '/matparty';
            $apiUrl .= '?where[]=MatParty.MatterId,=,'.$request->matterId;
            $apiUrl .= '&where[]=Role.Description,<,'.$request->roleDescription;
            $apiUrl .= '&where[]=MatParty.Sorter,<,'.$request->sorter;
            $apiUrl .= '&orderby[]=Role.Description';
            $apiUrl .= '&orderby[]=MatParty.Sorter';
            $apiUrl .= '&method=count';

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }
}
