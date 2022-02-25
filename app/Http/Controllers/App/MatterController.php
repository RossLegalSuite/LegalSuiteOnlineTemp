<?php

namespace App\Http\Controllers\App;

use App\Custom\Utils;
use Illuminate\Http\Request;

class MatterController extends Controller
{
    // // public function get(Request $request)
    // // {

    // //     try {

    // //         $apiUrl = "/matter/get";

    // //         $postFields = http_build_query($request->all());

    // //         $response = Utils::SetCurlParams($apiUrl,'POST', $postFields);

    // //         return json_encode($response);

    // //     } catch(\Exception $e)  {

    // //         $returnData['errors'] = $e->getMessage();
    // //         return json_encode($returnData);

    // //     }

    // // }

    // // public function store(Request $request)
    // // {

    // //     $returnData = new \stdClass();

    // //     // Now done in the API
    // //     // if ( isset($request->recordid) ) {

    // //     //     $rules = [
    // //     //         'fileref' => 'required',
    // //     //         'description' => 'required',
    // //     //         'clientfeesheetid' => 'required',
    // //     //         'mattertypeid' => 'required',
    // //     //         'docgenid' => 'required',
    // //     //     ];

    // //     //     $validator = Validator::make($request->all(), $rules);

    // //     //     if ($validator->fails()) {

    // //     //         $returnData->error = $validator->errors();
    // //     //         return json_encode($returnData);

    // //     //     }

    // //     // }

    // //     try {

    // //         if ( isset($request->recordid) ) {
    // //             $apiUrl = "/matter/{$request->recordid}";
    // //             $customRequest = 'PUT';
    // //         } else {
    // //             $apiUrl = "/matter";
    // //             $customRequest = 'POST';
    // //         }

    // //         $postFields = $request->queryString;

    // //         $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

    // //         return json_encode($response);

    // //     } catch(\Exception $e)  {

    // //         $returnData->errors = $e->getMessage();
    // //         return json_encode($returnData);

    // //     }

    // // }

    // // public function destroy(Request $request)
    // // {

    // //     MatterExtraScreen::where('matterId', $request->id)->delete();

    // //     return DataTablesHelper::destroy($request, Matter::class);
    // // }

    // public function getNextFileRef(Request $request) {

    //     $returnData = new \stdClass();

    //     try {

    //         /* Go to API and run:

    //             RowCounter{PROP:SQL} = 'Select max(Convert(Int,FileRef)) from ( ' & |
    //                                     'Select case when charindex(''/'',fileref) > 1 Then ' & |
    //                                     'SubString(case when charindex(''-'',fileref,charindex(''/'',fileref)) > 1 Then SubString(fileref,1,charindex(''-'',fileref,charindex(''/'',fileref))-1) Else FileRef end ' & |
    //                                     ',charindex(''/'',fileref)+1,14) Else '''' End FileRef ' & |
    //                                     'from matter where fileref like ''' & ThePrefix & '/%'' and ' & |
    //                                     'fileref not like ''' & ThePrefix & '/99999%'' ) A ' & |
    //                                     'where Isnumeric(FileRef) <> 0'

    //             Next(RowCounter)
    //             a# = ROW:Counter + 1

    //             $number = 65;
    //             $length = 5;
    //             $string = substr(str_repeat(0, $length).$counter, - $length);

    //         */

    //         // For testing
    //         $counter = \rand ( 100 , 999 );

    //         if ( (int) $request->prefixOption >= 1 ) {

    //             if ( $counter < 100000 ) {

    //                 //https://www.delftstack.com/howto/php/how-to-properly-format-a-number-with-leading-zeros-in-php/
    //                 $returnData->fileRef = $request->matterPrefix . '/' . substr(str_repeat(0, 5).$counter, -5);

    //             } else {

    //                 $returnData->fileRef = $request->matterPrefix . '/' . $counter;
    //             }

    //         } else {

    //             if ( $counter < 10000 ) {

    //                 $returnData->fileRef = $request->matterPrefix . '/' . substr(str_repeat(0, 4).$counter, -4);

    //             } else {

    //                 $returnData->fileRef = $request->matterPrefix . '/' . $counter;
    //             }

    //         }

    //         return json_encode($returnData);

    //     } catch (\Illuminate\Database\QueryException $e) {

    //         $returnData->error = Utils::MySqlError($e);
    //         return json_encode($returnData);

    //     }

    // }
}
