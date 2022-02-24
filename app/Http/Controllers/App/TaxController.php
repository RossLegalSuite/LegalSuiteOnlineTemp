<?php

namespace App\Http\Controllers\App;

use App\Models\TaxRate;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Custom\Utils;

class TaxController extends Controller {

    public function get(Request $request)
    {

        $columns = "tax_rates.*";

        $query = DB::table('tax_rates')->selectRaw($columns);

        if ($request->id) $query->where('tax_rates.id',$request->id);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }

    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'description' => 'required',
        ];


        $validator = Validator::make($request->all(), $rules); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = ( isset($request->id) ) ? TaxRate::findOrFail($request->id) : new TaxRate;

            $record->description = $request->description;

            $record->save();

            return json_encode($record);
    
        } catch (\Illuminate\Database\QueryException $e) {

            $validator->errors()->add('general', Utils::MySqlError($e));
            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        } catch(\Exception $e)  {

            $validator->errors()->add('general', $e->getMessage());
            $returnData->errors = $validator->errors();
            return json_encode($returnData);

        }

    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, TaxRate::class);
    }


    public function getTablePosition(Request $request)
    {

        return DB::table('tax_rates')
        ->where('description', '<' , $request->description)
        ->orderBy('description')
        ->count();

    }    


}
