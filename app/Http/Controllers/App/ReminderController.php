<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Reminder;
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

class ReminderController extends Controller
{
    private function addColumns(&$query, $request)
    {
        $query->addSelect('reminders.id');

        $query->addSelect('reminders.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(reminders.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));

        $query->addSelect('created.name as createdEmployeeName');
        $query->addSelect('reminders.description');

        $query->addSelect(DB::raw("CASE 
        WHEN parentType = 'Matter' THEN CONCAT(matters.fileRef, ' - ', matters.description) 
        WHEN parentType = 'Party' THEN CONCAT(parties.code, ' - ', parties.name) 
        ELSE '' 
        END as parent"));

        $query->addSelect('target.name as targetEmployeeName');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(reminders.targetDate,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as targetDate"));
        $query->addSelect('completedBy.name as completedEmployeeName');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(reminders.completedDate,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as completedDate"));

        if ($request->dataFormat === 'export') {
            $query->orderBy('reminders.date');
        } else {
            $query->addSelect('reminders.parentType');

            $query->addSelect('reminders.matterId');
            $query->addSelect('reminders.partyId');
            $query->addSelect('reminders.createdById');
            $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(reminders.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

            $query->addSelect('matters.id as matterId');
            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.fileRef as matterFileRef');
            $query->addSelect('matters.description as matterDescription');

            $query->addSelect('parties.id as partyId');
            $query->addSelect('parties.code');
            $query->addSelect('parties.name');
            $query->addSelect(DB::raw("CONCAT(parties.code, ' - ', parties.name) as party"));

            $query->addSelect('created.id as createdEmployeeId');
            $query->addSelect('target.id as targetEmployeeId');
            $query->addSelect('completedBy.id as completedEmployeeId');

            $query->addSelect('reminders.recurringFlag');
            $query->addSelect('reminders.recurringPeriod');
            $query->addSelect('reminders.recurringCustomUnits');
            $query->addSelect(DB::raw('CONVERT(reminders.recurringCustomAmount,char) as recurringCustomAmount'));
            $query->addSelect('reminders.completedFlag');

            $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(reminders.completedDate,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as completedDateTime"));

            $query->addSelect('reminders.parentId');
            $query->addSelect('reminders.childId');
        }
    }

    private function tableJoins(&$query)
    {
        $query
        ->leftJoin('matters', 'matters.id', '=', 'reminders.matterId')
        ->leftJoin('parties', 'parties.id', '=', 'reminders.partyId')
        ->join('employees as created', 'created.id', '=', 'reminders.createdById')
        ->join('employees as target', 'target.id', '=', 'reminders.targetEmployeeId')
        ->leftJoin('employees as completedBy', 'completedBy.id', '=', 'reminders.completedEmployeeId');
    }

    public function get(Request $request)
    {
        $query = DB::table('reminders');

        $this->addColumns($query, $request);

        $this->tableJoins($query);

        if ($request->id) {
            $query->where('reminders.id', $request->id);
        } elseif ($request->matterId) {
            $query->where('reminders.matterId', $request->matterId);
        } elseif ($request->partyId) {
            $query->where('reminders.partyId', $request->partyId);
        } elseif ($request->createdById) {
            $query->where('reminders.createdById', $request->createdById);
        } elseif ($request->targetEmployeeId) {
            $query->where('reminders.targetEmployeeId', $request->targetEmployeeId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        //Utils::LogSqlQuery($query);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables
                ->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(reminders.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('targetDate', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(reminders.targetDate,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('completedDate', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(reminders.completedDate,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('parent', function ($query, $keyword) {
                    $sql = "CASE 
                    WHEN parentType = 'Matter' THEN CONCAT(matters.fileRef, ' - ', matters.description) 
                    WHEN parentType = 'Party' THEN CONCAT(parties.code, ' - ', parties.name) 
                    ELSE '' 
                    END
                    like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('recurringFlag', function ($query, $keyword) {
                    $sql = "CASE 
                    WHEN recurringFlag = 1 THEN 'Yes'
                    WHEN recurringFlag = 0 THEN 'No'
                    END
                    like ?";
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
            'createdById' => 'required',
            'parentType' => 'required',
            'description' => 'required',
            'dateTime' => new ValidDate,
            'targetDate' => new ValidDate,
            'targetEmployeeId' => 'required',
        ];

        $rules['matterId'] = $request->parentType === 'Matter' ? ['required'] : [];
        $rules['partyId'] = $request->parentType === 'Party' ? ['required'] : [];
        $rules['completedDateTime'] = $request->completedFlag == 1 ? [new ValidDate] : [];

        $messages = [
            'matterId.required' => 'Please select a Matter',
            'partyId.required' => 'Please select a Party',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? Reminder::findOrFail($request->id) : new Reminder;

            $record->parentType = $request->parentType;
            $record->matterId = $request->matterId;
            $record->partyId = $request->partyId;
            $record->createdById = $request->createdById;
            $record->description = $request->description;
            $record->date = Utils::convertDateTime($request->dateTime);
            $record->targetDate = Utils::convertDate($request->targetDate);
            $record->targetEmployeeId = $request->targetEmployeeId;
            $record->completedFlag = $request->completedFlag;
            $record->completedDate = $request->completedFlag == 1 ? Utils::convertDateTime($request->completedDateTime) : null;
            $record->completedEmployeeId = $request->completedEmployeeId;
            $record->recurringFlag = $request->recurringFlag;
            $record->recurringPeriod = $request->recurringPeriod;
            $record->recurringCustomUnits = $request->recurringCustomUnits;
            $record->recurringCustomAmount = $request->recurringCustomAmount;

            $record->save();

            if (! $record->childId && $record->completedFlag && $record->recurringFlag) {
                $this->repeat($record);
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

    protected function repeat($parentRecord)
    {
        $record = new Reminder;

        $record->parentType = $parentRecord->parentType;
        $record->matterId = $parentRecord->matterId;
        $record->partyId = $parentRecord->partyId;
        $record->employeeId = $parentRecord->employeeId;
        $record->description = $parentRecord->description;
        $record->targetEmployeeId = $parentRecord->targetEmployeeId;
        $record->recurringFlag = $parentRecord->recurringFlag;
        $record->recurringPeriod = $parentRecord->recurringPeriod;
        $record->recurringCustomUnits = $parentRecord->recurringCustomUnits;
        $record->recurringCustomAmount = $parentRecord->recurringCustomAmount;

        $record->parentId = $parentRecord->id;
        $record->childId = null;
        $record->completedFlag = 0;
        $record->completedDate = null;
        $record->completedEmployeeId = null;

        $record->date = date('Y-m-d H:i:s', strtotime(Carbon::now()));
        $targetDate = Carbon::now();

        if ($record->recurringPeriod === 'Monthly') {
            $targetDate->addMonthsWithNoOverflow(1);
        }

        $record->targetDate = date('Y-m-d H:i:s', strtotime($targetDate));

        $record->save();

        $parentRecord->childId = $record->id;
        $parentRecord->save();
    }

    public function complete(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $returnData->result = DB::table('reminders')->whereIn('id', $request->id);

            $returnData->result->update([
                'completedFlag' => 1,
                'completedEmployeeId' => session('employeeId'),
                'completedDate' => Utils::convertDateTime($request->date),
            ]);

            return json_encode($returnData);
        } catch (\Illuminate\Database\QueryException $e) {
            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);
        }
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, Reminder::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('reminders')
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
                    'Created On',
                    'Created By',
                    'Description',
                    'Linked To',
                    'Assigned To',
                    'Target Date',
                    'Completed By',
                    'Completed On',
                ];
            }

            public function registerEvents(): array
            {
                return [

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Reminders');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },
                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'reminders.xlsx');
    }
}
