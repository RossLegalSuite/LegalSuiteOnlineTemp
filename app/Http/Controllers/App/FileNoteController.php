<?php

namespace App\Http\Controllers\App;

use App\Models\FileNote;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidDate;
use App\Custom\Utils;

use Maatwebsite\Excel\Facades\Excel;
use Maatwebsite\Excel\Concerns\{FromQuery, Exportable, WithHeadings, WithEvents, RegistersEventListeners, ShouldAutoSize};
use Maatwebsite\Excel\Events\{BeforeExport, AfterSheet};
use PhpOffice\PhpSpreadsheet\Style\{NumberFormat, Alignment};

class FileNoteController extends Controller {
    
    private function addColumns(&$query, $request)
    {
        $query->addSelect('file_notes.id');

        $query->addSelect('created.name as createdEmployeeName');

        $query->addSelect('file_notes.description');
        
        $query->addSelect( DB::raw("CASE WHEN parentType = 'Matter' THEN CONCAT(matters.fileRef, ' - ', matters.description) WHEN parentType = 'Party' THEN CONCAT(parties.code, ' - ', parties.name) WHEN parentType = 'Employee' THEN employees.name  ELSE '' END as parent") );
    
        if ( $request->dataFormat === 'export' ) {
            
            $query->orderBy('file_notes.date');
            
        } else {

            $query->addSelect('file_notes.createdById');
            $query->addSelect('file_notes.parentType');
            $query->addSelect('file_notes.matterId');
            $query->addSelect('file_notes.partyId');
            $query->addSelect('file_notes.employeeId');
            
            $query->addSelect('created.id as createdEmployeeId');
            
            $query->addSelect('file_notes.date');
            $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(file_notes.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateFormatted") ); 
            $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(file_notes.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 

            $query->addSelect('matters.id as matterId');
            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.fileRef as matterFileRef');
            $query->addSelect('matters.description as matterDescription');

            $query->addSelect('parties.id as partyId');
            $query->addSelect("parties.code");
            $query->addSelect("parties.name");
            $query->addSelect(DB::raw("CONCAT(parties.code, ' - ', parties.name) as party"));

            $query->addSelect('employees.name as employeeName');
            

        }
    }

    private function tableJoins(&$query)
    {

        $query
        ->leftJoin('matters', 'matters.id', '=', 'file_notes.matterId')
        ->leftJoin('parties', 'parties.id', '=', 'file_notes.partyId')
        ->leftJoin('employees', 'employees.id', '=', 'file_notes.employeeId')
        ->join('employees as created', 'created.id', '=', 'file_notes.createdById');

    }    

    public function get(Request $request)
    {

        $query = DB::table('file_notes');

        $this->addColumns($query, $request);

        $this->tableJoins($query);

        if ($request->id) {

            $query->where('file_notes.id',$request->id);

        } else if ($request->matterId) {

            $query->where('file_notes.matterId',$request->matterId);

        } else if ($request->partyId) {

            $query->where('file_notes.partyId',$request->partyId);

        } else if ($request->employeeId) {

            $query->where('file_notes.employeeId',$request->employeeId);

        } else if ($request->createdById) {

            $query->where('file_notes.createdById',$request->createdById);

        }    

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        
        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value'] ) {

                $datatables
                ->filterColumn('date', function($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(file_notes.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('parent', function($query, $keyword) {
                    $sql = "CASE WHEN parentType = 'Matter' THEN CONCAT(matters.fileRef, ' - ', matters.description) WHEN parentType = 'Party' THEN CONCAT(parties.code, ' - ', parties.name) WHEN parentType = 'Employee' THEN employees.name  ELSE '' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });

            }

            return $datatables->make(true);

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }
    }


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'createdById' => 'required',
            'description' => 'required',
            'parentType' => 'required',
            'dateTime' => new ValidDate,
        ];

        $rules['matterId'] = $request->parentType === 'Matter' ? ['required'] : [];       
        $rules['partyId'] = $request->parentType === 'Party' ? ['required'] : [];       
        $rules['employeeId'] = $request->parentType === 'Employee' ? ['required'] : [];       

        $messages = [
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

            $record = isset($request->id) ? FileNote::findOrFail($request->id) : new FileNote;

            $record->createdById = $request->createdById;
            $record->description = $request->description;
            $record->parentType = $request->parentType;

            $record->matterId = $request->matterId;
            $record->partyId = $request->partyId;
            $record->employeeId = $request->employeeId;

            $record->date = Utils::convertDateTime($request->dateTime);
            
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
        return DataTablesHelper::destroy($request, FileNote::class);
    }

    public function getTablePosition(Request $request)
    {

        return DB::table('file_notes')
        ->where('date', '<' , $request->date)
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
                    "Date",
                    "Created By",
                    "Description",
                    "Linked To",
                ];
            }

            public function registerEvents(): array
            {
                return [

                    BeforeExport::class => function(BeforeExport $event) {

                        $event->writer->getProperties()->setTitle('File Notes');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },
                ];
            }
            
            public function query() { return $this->query; }

        },'filenotes.xlsx');

    }

}
