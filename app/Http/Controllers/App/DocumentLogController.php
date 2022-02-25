<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\DocumentLog;
use App\Rules\ValidDate;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class DocumentLogController extends Controller
{
    private function addColumns(&$query)
    {
        $query->addSelect('document_logs.id');
        $query->addSelect('document_logs.createdById');
        $query->addSelect('document_logs.matterId');
        $query->addSelect('document_logs.partyId');
        $query->addSelect('document_logs.employeeId');
        $query->addSelect('document_logs.type');
        $query->addSelect('document_logs.description');
        $query->addSelect('document_logs.path');
        $query->addSelect('document_logs.url');
        $query->addSelect('document_logs.fileName');

        $query->addSelect('document_logs.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(document_logs.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(document_logs.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
        $query->addSelect('matters.fileRef as matterFileRef');
        $query->addSelect('matters.description as matterDescription');

        $query->addSelect('parties.code');
        $query->addSelect('parties.name');
        $query->addSelect(DB::raw("CONCAT(parties.code, ' - ', parties.name) as party"));

        $query->addSelect('employees.name as employeeName');

        $query->addSelect('createdBy.name as createdByName');
    }

    public function get(Request $request)
    {
        $query = DB::table('document_logs')
        ->leftJoin('matters', 'matters.id', '=', 'document_logs.matterId')
        ->leftJoin('parties', 'parties.id', '=', 'document_logs.partyId')
        ->leftJoin('employees', 'employees.id', '=', 'document_logs.employeeId')
        ->join('employees as createdBy', 'createdBy.id', '=', 'document_logs.createdById');

        $this->addColumns($query);

        if ($request->id) {
            $query->where('document_logs.id', $request->id);
        } elseif ($request->matterId) {
            $query->where('document_logs.matterId', $request->matterId);
        } elseif ($request->partyId) {
            $query->where('document_logs.partyId', $request->partyId);
        } elseif ($request->employeeId) {
            $query->where('document_logs.employeeId', $request->employeeId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(document_logs.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'batchId' => 'required',
            'description' => 'required',
            'type' => 'required',
            'dateTime' => new ValidDate,
            'path' => 'required',
            'url' => 'required',
            'fileName' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? DocumentLog::findOrFail($request->id) : new DocumentLog;

            $record->date = Utils::convertDateTime($request->dateTime);
            $record->batchId = $request->batchId;
            $record->createdById = session('employeeId');
            $record->matterId = $request->matterId;
            $record->partyId = $request->partyId;
            $record->employeeId = $request->employeeId;
            $record->description = $request->description;
            $record->type = $request->type;
            $record->path = $request->path;
            $record->url = $request->url;
            $record->fileName = $request->fileName;

            $record->save();

            return json_encode($record);
        } catch (\Illuminate\Database\QueryException $e) {
            $validator->errors()->add('general', Utils::MySqlError($e));
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        } catch (\Exception $e) {
            $validator->errors()->add('general', $e->getMessage());
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, DocumentLog::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('document_logs')
        ->where('date', '<', $request->date)
        ->orderBy('date')
        ->count();
    }
}
