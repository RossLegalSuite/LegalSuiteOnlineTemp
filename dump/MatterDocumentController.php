<?php

namespace App\Http\Controllers;

use App\MatterDocument;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use DB;
use Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidDate;
use App\Custom\Utils;

class MatterDocumentController extends Controller {

    private function addColumns(&$query)
    {

        $query->addSelect('matter_documents.id');
        $query->addSelect('matter_documents.matterId');
        $query->addSelect('matter_documents.type');
        $query->addSelect('matter_documents.description');
        $query->addSelect('matter_documents.path');
        $query->addSelect('matter_documents.fileName');

        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(matter_documents.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as date") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(matter_documents.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
        $query->addSelect('matters.fileRef as matterFileRef');
        $query->addSelect('matters.description as matterDescription');
        $query->addSelect('employees.name as employeeName');

    }


    public function get(Request $request)
    {

        $query = DB::table('matter_documents')
        ->join('matters', 'matters.id', '=', 'matter_documents.matterId')
        ->join('employees', 'employees.id', '=', 'matter_documents.employeeId');

        $this->addColumns($query);

        if ($request->where) $query->where( $request->where['column'], $request->where['value'] );

        if ($request->whereIn) $query->whereIn( $request->whereIn['column'], $request->whereIn['value'] );

        if ($request->whereNull) $query->whereNull( $request->whereNull );


        if ($request->id) {

            $query->where('matter_documents.id',$request->id);

        } else if ($request->matterId) {

            $query->where('matter_documents.matterId',$request->matterId);

        }    

        if ($request->whereClause) $query->whereRaw($request->whereClause);

        return DataTablesHelper::ReturnData($query, $request);

    }


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'matterId' => 'required',
            'employeeId' => 'required',
            'description' => 'required',
            'type' => 'required',
            'dateTime' => new ValidDate,
            'path' => 'required',
            'fileName' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            $record = ( isset($request->id) ) ? $record = MatterDocument::find($request->id) : new MatterDocument;
        
            $record->date = Utils::convertDateTime($request->dateTime);
            $record->matterId = $request->matterId;
            $record->employeeId = $request->employeeId;
            $record->description = $request->description;
            $record->type = $request->type;
            $record->path = $request->path;
            $record->fileName = $request->fileName;

            $record->save();

            return json_encode($record);

        } catch (\Illuminate\Database\QueryException $e) {

            $validator->errors()->add('general', Utils::MySqlError($e));

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }

    }

    public function destroy(Request $request)
    {
        MatterDocument::find($request->id)->delete();
    }


    public function getTablePosition(Request $request)
    {

        return DB::table('matter_documents')
        ->where('matterId',$request->matterId)
        ->where('date', '<' , $request->date)
        ->orderBy('matterId')
        ->orderBy('date')
        ->count();

    }    

}
