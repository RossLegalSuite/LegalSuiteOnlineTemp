<?php

namespace App\Http\Controllers\App;

use App\Models\TemplateField;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Custom\Utils;

class TemplateFieldController extends Controller {

    private function addColumns(&$query)
    {

        $query->addSelect('template_fields.*');

    }

    public function get(Request $request)
    {

        $query = DB::table('template_fields');

        $this->addColumns($query);

        if ($request->id) $query->where('template_fields.id',$request->id);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'contents' => 'bail|required',
        ];

        $rules['title'] = isset($request->id) ? ['required',Rule::unique('template_fields')->ignore($request->id)] : ['required',Rule::unique('template_fields')];        

        $validator = Validator::make($request->all(), $rules); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = ( isset($request->id) ) ? TemplateField::findOrFail($request->id) : new TemplateField;
        
            $record->title = $request->title;
            $record->contents = $request->contents;

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
        return DataTablesHelper::destroy($request, TemplateField::class);
    }


    public function getTablePosition(Request $request)
    {
        return DB::table('template_fields')
        ->where('title','<',$request->title)
        ->orderBy('title')
        ->count();
    }    

}
