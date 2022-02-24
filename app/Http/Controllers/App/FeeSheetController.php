<?php

namespace App\Http\Controllers\App;

use App\Models\FeeSheet;
use App\Models\FeeCode;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class FeeSheetController extends Controller {

    public function get(Request $request)
    {

        $returnData = new \stdClass();

        try {

            if ( isset($request->id) ){

                $apiUrl = "/feesheet/{$request->id}";

            } else {

                if ($request->method() == 'POST'){

                    $apiUrl = "/feesheet?". http_build_query($request->all());

                } else {

                    $url = $request->fullurl();

                    $parsedUrl = parse_url($url);

                    $apiUrl = "/feesheet?". $parsedUrl['query'];

                }

            }    

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

        $rules = [
            'description' => 'required',
        ];

        $messages = [
            'description.required' => 'Please specify a description of this Document Set',
        ];

        $validator = Validator::make($request->all(), $rules,$messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $postFields = "Description={$request->description}";
            // logger('$postFields',[$postFields]);
            if ( isset($request->recordid) ) {
                $apiUrl = "/feesheet/{$request->recordid}";
                $customRequest = 'PUT';
            } else {
                $apiUrl = "/feesheet";
                $customRequest = 'POST';
            } 

            $response = Utils::SetCurlParams($apiUrl, $customRequest, $postFields);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }
    
    }


    protected function copyFeeCodes($feeSheetId, $copyFromId) {

        $feeCodeController = new FeeCodeController;

        $feeCodes = DB::table('fee_codes')
        ->where('fee_codes.feeSheetId',$copyFromId)
        ->get()->toArray();

        foreach($feeCodes as $existingFeeCode) {

            $newFeeCode = FeeCode::create([
                'feeSheetId' => $feeSheetId,
                'code' => $existingFeeCode->code,
                'description' => $existingFeeCode->description,
            ]);

            $feeCodeController->copyFeeItems($newFeeCode->id, $existingFeeCode->id);

        }

    }


    private function generateCopyDescription($description)
    {

        $description = preg_replace("/ \(Copy(.*?)\)/i", "", $description);

        $counter = FeeSheet::where('description', 'like', $description . ' (Copy%')
        ->count();

        if ($counter) {

            while($counter <= 5000) {

                $existingRecord = FeeSheet::where('description',$description . ' (Copy' . $counter . ')')->first();

                if (!$existingRecord) break;

                $counter++;
                
            }

            return $description . ' (Copy' . $counter . ')';

        } else {

            return $description . ' (Copy)';

        }
        
    }


    private function checkDuplicateCode($id, $code) {

        $query = FeeSheet::where('code', $code);

        if ( isset($id) ) {
            $query->where('id', '!=' ,$id);
        }

        $counter = $query->count();

        if ($counter) {

            while($counter <= 5000) {

                $existingQuery = FeeSheet::where('code',$code . $counter);

                if ( isset($id) ) {
                    $existingQuery->where('id', '!=' ,$id);
                }

                $existingRecord = $existingQuery->first();

                if (!$existingRecord) break;

                $counter++;
                
            }

            return $code . $counter;

        } else {

            return $code;

        }

    }



    public function getTablePosition(Request $request)
    {

        $returnData = new \stdClass();

        try {

            if ( isset($request->id) ){
                $apiUrl = "/feesheet/{$request->id}";
            } else {
                $apiUrl = "/feesheet?". urldecode("&where[]=feesheet.description,<," . str_replace("'","''",$request->description) . "&orderby[]=Description&method=count");
            }    

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
    
        } catch(\Exception $e)  {
    
            $returnData->errors = $e->getMessage();
            return json_encode($returnData);
    
        }

    }

    public function destroy(Request $request) {

        $apiUrl = "/feesheet/";
        return DataTablesHelper::destroy($request->id, $apiUrl);

    }

}
