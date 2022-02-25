<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Employee;
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

class EmployeeController extends Controller
{
    use Exportable, RegistersEventListeners;

    public function get(Request $request)
    {
        try {
            $apiUrl = '/employee/get';

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }

        /*$returnData = new \stdClass();

        try {

            if ( isset($request->id) ){
                $apiUrl = "/employee/{$request->id}";
            } else if ( isset($request->name) ){
                $apiUrl = "/employee?where=Employee.Name,=," . $request->name;
            } else {
                $apiUrl = "/employee?". urldecode(http_build_query($request->all()));
            }

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);

        } catch(\Exception $e)  {

            $returnData->errors = $e->getMessage();
            return json_encode($returnData);

        }*/
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
                    'Name',
                    'Email',
                    'Employee Group Code',
                    'Employee Group Description',
                ];
            }

            public function registerEvents(): array
            {
                return [

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Employees');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },

                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'employees.xlsx');
    }

    public function getCurrent(Request $request)
    {
        $employee = Employee::find(session('employeeId'));

        return $employee;
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'name' => 'required',
            'employeeGroupId' => 'required',
            'allocateToId' => 'required',
        ];

        $rules['email'] = isset($request->id) ? ['required', Rule::unique('employees')->ignore($request->id)] : ['required', Rule::unique('employees')];

        if (! isset($request->id)) {
            $rules['password'] = ['required', 'min:8'];
        }

        $messages = [
            'allocateToId.required' => 'Please select an Employee',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? Employee::findOrFail($request->id) : new Employee;

            $record->name = $request->name;
            $record->email = $request->email;
            $record->employeeGroupId = $request->employeeGroupId;
            $record->allocateToId = $request->allocateToId;

            $record->smtpUserName = $request->smtpUserName;
            $record->smtpPassword = $request->smtpPassword;

            if (! isset($request->id)) {
                $record->password = $request->password;
            }

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

    public function saveSmtpDetails(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $record = Employee::findOrFail($request->id);

            $record->smtpUserName = $request->smtpUserName;
            $record->smtpPassword = $request->smtpPassword;

            $record->save();

            return json_encode($record);
        } catch (\Illuminate\Database\QueryException $e) {
            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, Employee::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('employees')
        ->where('name', '<', $request->name)
        ->orderBy('name')
        ->count();
    }
}
