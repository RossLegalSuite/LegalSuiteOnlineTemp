<?php

namespace App\Http\Controllers\App;

use App\Models\ExtraScreenField;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidDate;
use App\Custom\Utils;

class ExtraScreenFieldController extends Controller {
    
    private function addColumns(&$query, $request)
    {
        $query->addSelect('extra_screen_fields.id');

        $query->addSelect('extra_screen_fields.type');
        $query->addSelect('extra_screen_fields.label');
        $query->addSelect('extra_screen_fields.subtype');
        $query->addSelect('extra_screen_fields.name');
        $query->addSelect('extra_screen_fields.className');

        $query->addSelect('extra_screen_fields.description');
        $query->addSelect('extra_screen_fields.placeholder');
        $query->addSelect('extra_screen_fields.required');
        $query->addSelect('extra_screen_fields.values');
        
        $query->addSelect('extra_screen_fields.extraScreenId');

    }

    private function tableJoins(&$query)
    {

        $query->leftJoin('extra_screens', 'extra_screens.id', '=', 'extra_screen_fields.extraScreenId');

    }    

    public function get(Request $request)
    {

        $query = DB::table('extra_screen_fields');

        $this->addColumns($query, $request);

        $this->tableJoins($query);

        if ($request->id) {

            $query->where('extra_screen_fields.id',$request->id);

        } else if ($request->parentId) {

            $query->where('extra_screen_fields.extraScreenId',$request->parentId);

        }    

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        
        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            return $datatables->make(true);

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }
    }


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'type' => 'required',
            'label' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = isset($request->id) ? ExtraScreenField::findOrFail($request->id) : new ExtraScreenField;

            $record->type = $request->type;
            $record->label = $request->label;
            $record->subtype = $request->subtype;
            $record->name = $request->name;
            $record->className = $request->className;
            $record->required = $request->required;
            $record->description = $request->description;
            $record->placeholder = $request->placeholder;
            $record->values = $request->values;

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
        return DataTablesHelper::destroy($request, ExtraScreenField::class);
    }



}
