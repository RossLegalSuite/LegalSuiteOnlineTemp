<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Correspondence;
use App\Models\CorrespondenceAttachment;
use App\Rules\ValidDate;
use Carbon\Carbon;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Maatwebsite\Excel\Concerns\Exportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeExport;
use Maatwebsite\Excel\Facades\Excel;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

class CorrespondenceController extends Controller
{
    private function addColumns(&$query, $request)
    {
        $query->addSelect('correspondence.id');
        $query->addSelect('correspondence.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(correspondence.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));

        $query->addSelect('created.name as createdEmployeeName');
        $query->addSelect('correspondence.type');
        $query->addSelect('correspondence.description');

        $query->addSelect(DB::raw("CASE WHEN parentType = 'Matter' THEN CONCAT(matters.fileRef, ' - ', matters.description) WHEN parentType = 'Party' THEN CONCAT(parties.code, ' - ', parties.name) WHEN parentType = 'Employee' THEN employees.name  ELSE '' END as parent"));

        $query->addSelect('correspondence.path');
        $query->addSelect('correspondence.url');
        $query->addSelect('correspondence.fileName');
        $query->addSelect('correspondence.fileType');
        $query->addSelect('correspondence.docxFile');

        if ($request->dataFormat === 'export') {
            $query->orderBy('correspondence.date');
        } else {
            $query->addSelect('correspondence.createdById');
            $query->addSelect('correspondence.batchId');
            $query->addSelect('correspondence.matterId');
            $query->addSelect('correspondence.partyId');
            $query->addSelect('correspondence.employeeId');
            $query->addSelect('correspondence.parentType');

            $query->addSelect('created.id as createdEmployeeId');

            $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(correspondence.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.fileRef as matterFileRef');
            $query->addSelect('matters.description as matterDescription');

            $query->addSelect('parties.code');
            $query->addSelect('parties.name');
            $query->addSelect(DB::raw("CONCAT(parties.code, ' - ', parties.name) as party"));

            $query->addSelect('employees.id as employeeId');
            $query->addSelect('employees.name as employeeName');
        }
    }

    private function tableJoins(&$query)
    {
        $query
        ->leftJoin('matters', 'matters.id', '=', 'correspondence.matterId')
        ->leftJoin('parties', 'parties.id', '=', 'correspondence.partyId')
        ->leftJoin('employees', 'employees.id', '=', 'correspondence.employeeId')
        ->join('employees as created', 'created.id', '=', 'correspondence.createdById');
    }

    public function get(Request $request)
    {
        $query = DB::table('correspondence');

        $this->addColumns($query, $request);

        $this->tableJoins($query);

        if ($request->id) {
            $query->where('correspondence.id', $request->id);
        } elseif ($request->matterId) {
            $query->where('correspondence.matterId', $request->matterId);
        } elseif ($request->partyId) {
            $query->where('correspondence.partyId', $request->partyId);
        } elseif ($request->employeeId) {
            $query->where('correspondence.employeeId', $request->employeeId);
        } elseif ($request->createdById) {
            $query->where('correspondence.createdById', $request->createdById);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables
                ->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(correspondence.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('parent', function ($query, $keyword) {
                    $sql = "CASE WHEN parentType = 'Matter' THEN CONCAT(matters.fileRef, ' - ', matters.description) WHEN parentType = 'Party' THEN CONCAT(parties.code, ' - ', parties.name) WHEN parentType = 'Employee' THEN employees.name  ELSE '' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            //Utils::LogSqlQuery($query);

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        //'batchId' => 'required',
        $rules = [
            'description' => 'bail|required',
            'type' => 'bail|required',
            'parentType' => 'bail|required',
            'url' => 'bail|required',
        ];

        $rules['matterId'] = $request->parentType === 'Matter' ? ['bail', 'required'] : [];
        $rules['partyId'] = $request->parentType === 'Party' ? ['bail', 'required'] : [];
        $rules['employeeId'] = $request->parentType === 'Employee' ? ['bail', 'required'] : [];

        $messages = [
            'url.required' => 'Please upload a file',
            'description.required' => 'Please provide a description of this item',
            'matterId.required' => 'Please select a Matter',
            'partyId.required' => 'Please select a Party',
            'employeeId.required' => 'Please select an Employee',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = isset($request->id) ? Correspondence::findOrFail($request->id) : new Correspondence;

            $record->date = Utils::convertDateTime($request->dateTime);
            $record->batchId = $request->batchId;
            $record->createdById = isset($request->createdById) ? $request->createdById : session('employeeId');
            $record->matterId = $request->matterId;
            $record->partyId = $request->partyId;
            $record->employeeId = $request->employeeId;
            $record->description = $request->description;
            $record->parentType = $request->parentType;
            $record->type = $request->type;
            $record->path = $request->path;
            $record->url = $request->url;
            $record->fileName = $request->fileName;
            $record->fileType = $request->fileType;
            $record->docxFile = $request->docxFile;
            $record->save();

            if ($request->type === 'Email' && isset($request->attachments)) {
                foreach (json_decode($request->attachments) as $attachment) {
                    CorrespondenceAttachment::create([
                        'correspondenceId' => $record->id,
                        'fileName' => $attachment->fileName,
                        'url' => $attachment->url,
                        'path' => $attachment->path,
                        'mimeType' => $attachment->mimeType,
                        'imageFileName' => $attachment->imageFileName,
                    ]);
                }
            }

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
        return DataTablesHelper::destroy($request, Correspondence::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('correspondence')
        ->where('date', '<', $request->date)
        ->orderBy('date')
        ->count();
    }

    public function export(Request $request)
    {
        $newRequest = new Request;
        $newRequest->tableColumns = false;
        $newRequest->dataFormat = 'export';

        $query = $this->get($newRequest);

        Utils::SetExcelMacros();

        return Excel::download(new class($query) implements FromQuery, WithHeadings, WithEvents, ShouldAutoSize {
            public function __construct($query)
            {
                $this->query = $query;
            }

            public function headings(): array
            {
                return [
                    'Id',
                    'Date',
                    'Created By',
                    'Type',
                    'Description',
                    'Linked To',
                    'Path',
                    'Url',
                    'File Name',
                ];
            }

            public function registerEvents(): array
            {
                return [

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Correspondence');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },
                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'correspondence.xlsx');
    }
}
