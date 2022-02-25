<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Company;
use App\Models\ContactMethod;
use App\Models\Creditor;
use App\Models\CreditorNumber;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
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

class CreditorController extends Controller
{
    use Exportable, RegistersEventListeners;

    private function tableJoins(&$query)
    {
        $query
        ->leftJoin('accounts', 'creditors.defaultExpenseId', '=', 'accounts.id')
        ->leftJoin('provinces as physicalProvince', 'creditors.physicalProvinceId', '=', 'physicalProvince.id')
        ->leftJoin('provinces as postalProvince', 'creditors.postalProvinceId', '=', 'postalProvince.id')
        ->leftJoin('countries as physicalCountry', 'creditors.physicalCountryId', '=', 'physicalCountry.id')
        ->leftJoin('countries as postalCountry', 'creditors.postalCountryId', '=', 'postalCountry.id')
        ->leftJoin('creditor_numbers as emailAddress', function ($join) {
            $join->on('creditors.id', '=', 'emailAddress.creditorId')
                ->whereRaw('emailAddress.id IN (select max(id) from creditor_numbers WHERE methodId = '.session('emailMethodId').' AND creditorId = creditors.id AND defaultFlag = 1 group by methodId)');
        })
        ->leftJoin('creditor_numbers as mobileNumber', function ($join) {
            $join->on('creditors.id', '=', 'mobileNumber.creditorId')
                ->whereRaw('mobileNumber.id IN (select max(id) from creditor_numbers WHERE methodId = '.session('mobileMethodId').' AND creditorId = creditors.id AND defaultFlag = 1 group by methodId)');
        });
    }

    private function basicColumns(&$query, $prefix)
    {
        $query->addSelect("creditors.id as {$prefix}id");
        $query->addSelect("creditors.code as {$prefix}code");
        $query->addSelect("creditors.name as {$prefix}name");
        $query->addSelect("creditors.type as {$prefix}type");
        $query->addSelect(DB::raw("CONCAT(creditors.code, ' - ', creditors.name) as `{$prefix}creditor`"));
    }

    private function tableColumns(&$query, $prefix)
    {
        $query->addSelect("creditors.id as {$prefix}id");
        $query->addSelect("creditors.code as {$prefix}code");
        $query->addSelect("creditors.name as {$prefix}name");
        $query->addSelect("creditors.type as {$prefix}type");
        $query->addSelect(DB::raw("CASE WHEN emailAddress.description IS NOT NULL THEN emailAddress.description ELSE '' END as `{$prefix}email`"));
        $query->addSelect(DB::raw("CASE WHEN mobileNumber.description IS NOT NULL THEN mobileNumber.description ELSE '' END as `{$prefix}mobile`"));

        $query->addSelect(DB::raw("CONCAT(creditors.code, ' - ', creditors.name) as `{$prefix}creditor`"));

        $query->addSelect('accounts.id as accountId');
        $query->addSelect('accounts.code as accountCode');
        $query->addSelect('accounts.description as accountDescription');
        $query->addSelect('accounts.category as accountCategory');
    }

    private function addAging(&$query, $prefix)
    {
        $format1 = 'FORMAT( ';
        $format2 = ", 2, 'en_".session('countryCode')."')";

        $query->leftJoin('creditor_aging', 'creditors.id', '=', 'creditor_aging.creditorId');

        $query->addSelect(DB::raw("CASE WHEN creditor_aging.current IS NOT NULL THEN {$format1}creditor_aging.current{$format2} ELSE 0.00 END as `{$prefix}current`"));
        $query->addSelect(DB::raw("CASE WHEN creditor_aging.days30 IS NOT NULL THEN {$format1}creditor_aging.days30{$format2} ELSE 0.00 END as `{$prefix}days30`"));
        $query->addSelect(DB::raw("CASE WHEN creditor_aging.days60 IS NOT NULL THEN {$format1}creditor_aging.days60{$format2} ELSE 0.00 END as `{$prefix}days60`"));
        $query->addSelect(DB::raw("CASE WHEN creditor_aging.days90 IS NOT NULL THEN {$format1}creditor_aging.days90{$format2} ELSE 0.00 END as `{$prefix}days90`"));
        $query->addSelect(DB::raw("CASE WHEN creditor_aging.days120 IS NOT NULL THEN {$format1}creditor_aging.days120{$format2} ELSE 0.00 END as `{$prefix}days120`"));

        $query->addSelect(DB::raw('CASE WHEN creditor_aging.current IS NOT NULL THEN creditor_aging.current ELSE 0.00 END as currentRaw'));
        $query->addSelect(DB::raw('CASE WHEN creditor_aging.days30 IS NOT NULL THEN creditor_aging.days30 ELSE 0.00 END as days30Raw'));
        $query->addSelect(DB::raw('CASE WHEN creditor_aging.days60 IS NOT NULL THEN creditor_aging.days60 ELSE 0.00 END as days60Raw'));
        $query->addSelect(DB::raw('CASE WHEN creditor_aging.days90 IS NOT NULL THEN creditor_aging.days90 ELSE 0.00 END as days90Raw'));
        $query->addSelect(DB::raw('CASE WHEN creditor_aging.days120 IS NOT NULL THEN creditor_aging.days120 ELSE 0.00 END as days120Raw'));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(balance){$format2} FROM creditor_balances 
            WHERE creditorId = creditors.id GROUP BY creditorId), 0.00) as `{$prefix}balance`"));

        $query->addSelect(DB::raw('IFNULL( 
            (SELECT SUM(balance) FROM creditor_balances 
            WHERE creditorId = creditors.id GROUP BY creditorId), 0.00) as balanceRaw'));
    }

    private function allColumns(&$query, $request, $prefix)
    {
        $query->addSelect("creditors.id as {$prefix}id")
        ->addSelect("creditors.code as {$prefix}code")
        ->addSelect("creditors.type as {$prefix}type")
        ->addSelect("creditors.name as {$prefix}name")
        ->addSelect("creditors.firstName as {$prefix}firstName")
        ->addSelect("creditors.lastName as {$prefix}lastName")
        ->addSelect("creditors.title as {$prefix}title")
        ->addSelect("creditors.friendlyName as {$prefix}friendlyName")
        ->addSelect("creditors.salutation as {$prefix}salutation")
        ->addSelect("creditors.physicalLine1 as {$prefix}physicalLine1")
        ->addSelect("creditors.physicalLine2 as {$prefix}physicalLine2")
        ->addSelect("creditors.physicalLine3 as {$prefix}physicalLine3")
        ->addSelect("creditors.physicalCode as {$prefix}physicalCode")
        ->addSelect("physicalProvince.description as {$prefix}physicalProvince")
        ->addSelect("physicalCountry.description as {$prefix}physicalCountry")
        ->addSelect("creditors.postalLine1 as {$prefix}postalLine1")
        ->addSelect("creditors.postalLine2 as {$prefix}postalLine2")
        ->addSelect("creditors.postalLine3 as {$prefix}postalLine3")
        ->addSelect("creditors.postalCode as {$prefix}postalCode")
        ->addSelect("postalProvince.description as {$prefix}postalProvince")
        ->addSelect("postalCountry.description as {$prefix}postalCountry")
        ->addSelect("accounts.description as {$prefix}defaultExpenseAccount")
        ->addSelect('creditors.defaultExpenseId')
        ->addSelect('creditors.vatVendor');

        if ($request->dataFormat === 'export') {
            $query->addSelect("creditors.vatVendor as {$prefix}vatVendor");

            $query->addSelect(DB::raw("CASE 
            WHEN creditors.vatVendor = 1 THEN 'Yes'
            WHEN creditors.vatVendor = 0 THEN 'No'
            END as vatVendor"));
        } else {
            $query->addSelect("creditors.vatVendor as {$prefix}vatVendor");
        }
        $query->addSelect("creditors.vatNumber as {$prefix}vatNumber");
        $query->addSelect(DB::raw("CASE WHEN emailAddress.description IS NOT NULL THEN emailAddress.description ELSE '' END as `{$prefix}email`"));
        $query->addSelect(DB::raw("CASE WHEN mobileNumber.description IS NOT NULL THEN mobileNumber.description ELSE '' END as `{$prefix}mobile`"));
    }

    private function formColumns(&$query)
    {
        $query->addSelect(DB::raw("CONCAT(creditors.code, ' - ', creditors.name) as creditor"));
        $query->addSelect(DB::raw('CASE WHEN emailAddress.id IS NOT NULL THEN emailAddress.id ELSE NULL END as emailId'));

        $query->addSelect('creditors.postalProvinceId');
        $query->addSelect('creditors.postalCountryId');
        $query->addSelect('creditors.physicalProvinceId');
        $query->addSelect('creditors.physicalCountryId');
        $query->addSelect('physicalProvince.code as physicalProvinceCode');
        $query->addSelect('postalProvince.code as postalProvinceCode');
        $query->addSelect('physicalCountry.code as physicalCountryCode');
        $query->addSelect('postalCountry.code as postalCountryCode');
        $query->addSelect('creditors.vatNumber');

        $query->addSelect('accounts.id as accountId');
        $query->addSelect('accounts.code as accountCode');
        $query->addSelect('accounts.description as accountDescription');
        $query->addSelect('accounts.category as accountCategory');
    }

    public function get(Request $request)
    {
        $prefix = ($request->dataFormat === 'mergeArray') ? 'creditor-&gt;' : '';

        $query = DB::table('creditors');

        if ($request->dataFormat === 'mergeArray') {
            $query->orderBy('creditors.code');

            $this->allColumns($query, $request, $prefix);

            $this->addAging($query, $prefix);

            $this->tableJoins($query);
        } elseif ($request->dataFormat === 'idArray') {
            $query->orderBy('creditors.code');

            $query->addSelect('creditors.id');
            $query->addSelect('creditors.code');
            $query->addSelect('creditors.name');
        } elseif ($request->basicColumns) {
            $this->basicColumns($query, $prefix);
        } elseif ($request->tableColumns) {
            $this->tableColumns($query, $prefix);

            $this->tableJoins($query);

            $this->addAging($query, $prefix);
        } elseif ($request->dataFormat === 'export') {
            $query->orderBy('creditors.code');

            $this->allColumns($query, $request, $prefix);

            $this->tableJoins($query);
        } else {
            $this->allColumns($query, $request, $prefix);

            $this->formColumns($query);

            $this->addAging($query, $prefix);

            $this->tableJoins($query);
        }

        if ($request->id) {
            $query->where('creditors.id', $request->id);
        }

        if ($request->code) {
            $query->where('creditors.code', $request->code);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        //Utils::LogSqlQuery($query);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($request->tableFilter) {
                $datatables->filterColumn('balanceRaw', function ($query, $keyword) {
                    $sql = 'IFNULL( 
                        (SELECT SUM(balance) FROM creditor_balances 
                        WHERE creditorId = creditors.id GROUP BY creditorId), 0.00) like ?';
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function export(Request $request)
    {
        $newRequest = new Request;
        $newRequest->tableColumns = false;
        $newRequest->dataFormat = 'export';

        $query = $this->get($newRequest);

        Utils::SetExcelMacros();

        // https://github.com/Maatwebsite/Laravel-Excel/issues/1610
        // To avoid defining an export class for each model, use an anonymous class:

        return Excel::download(new class($query) implements FromQuery, WithHeadings, WithEvents, ShouldAutoSize {
            public function __construct($query)
            {
                $this->query = $query;
            }

            public function headings(): array
            {
                return [
                    'Id',
                    'Code',
                    'Name',
                    'First Name',
                    'Last Name',
                    'Title',
                    'Friendly Name',
                    'Salutation',
                    'Type',
                    'Physical Line1',
                    'Physical Line2',
                    'Physical Line3',
                    'Physical Code',
                    'Physical Province',
                    'Physical Country',
                    'Postal Line1',
                    'Postal Line2',
                    'Postal Line3',
                    'Postal Code',
                    'Postal Province',
                    'Postal Country',
                    'Expense Account',
                    'Vat Vendor',
                    'Vat Number',
                    'Email',
                    'Mobile',
                ];
            }

            public function registerEvents(): array
            {
                return [
                    AfterSheet::class => function (AfterSheet $event) {
                        $event->sheet->styleCells(
                            'A1:A1',
                            [
                                'alignment' => [
                                    'horizontal' => Alignment::HORIZONTAL_RIGHT,
                                ],
                            ]
                        );
                    },

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Creditors');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },

                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'creditors.xlsx');
    }

    public function emails(Request $request)
    {
        $query = CreditorNumber::where('contact_methods.type', 'Email')
        ->join('creditors', 'creditors.id', '=', 'creditor_numbers.creditorId')
        ->join('contact_methods', 'contact_methods.id', '=', 'creditor_numbers.methodId');

        $query->addSelect('creditor_numbers.id');
        $query->addSelect('creditors.code');
        $query->addSelect('creditors.name');
        $query->addSelect('creditor_numbers.description');

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, Creditor::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('creditors')
        ->where('code', '<', $request->column)
        ->orderBy('code')
        ->count();
    }

    // public function getExpenseAccountId(Request $request)
    // {
    //     return Creditor::where('id', $request->id )->pluck('defaultExpenseId');
    // }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        if ($request->type === 'Business') {
            $rules = [
                'name' => 'required|min:4',
                'type' => 'required',
                'salutation' => 'required',
                'physicalCode' => 'nullable|string|max:50',
                'postalCode' => 'nullable|string|max:50',
                'postalProvinceId' => 'required',
                'physicalProvinceId' => 'required',
                'postalCountryId' => 'required',
                'physicalCountryId' => 'required',
            ];
        } else {
            $rules = [
                'title' => 'max:50',
                'firstName' => 'required',
                'lastName' => 'required',
                'salutation' => 'required',
                'physicalCode' => 'nullable|string|max:50',
                'postalCode' => 'nullable|string|max:50',
                'postalProvinceId' => 'required',
                'physicalProvinceId' => 'required',
                'postalCountryId' => 'required',
                'physicalCountryId' => 'required',
            ];
        }

        $messages = [
            'code.required' => 'Please specify a Code for this Creditor',
            'postalProvinceId.required' => 'Please select a Province',
            'physicalProvinceId.required' => 'Please select a Province',
            'postalCountryId.required' => 'Please select a Country',
            'physicalCountryId.required' => 'Please select a Country',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        $company = Company::first();

        // if ( $request->defaultExpenseId === $company->disbursementRecoveryAccountId ) {

        //     $validator->errors()->add('defaultExpenseId','You cannot post expenses to this Account');

        //     $returnData->errors = $validator->errors();
        //     return json_encode($returnData);

        // }

        try {

            // Inserting a new record
            if (! isset($request->id)) {
                $creditor = new Creditor;

                if ($request->type === 'Person') {
                    $creditor->code = $this->generateCreditorCode($request->lastName);
                } else {
                    $creditor->code = $this->generateCreditorCode($request->name);
                }
            } else {
                $creditor = Creditor::find($request->id);

                $creditor->code = $request->code;
            }

            $creditor->name = $request->type === 'Person' ? $request->lastName.', '.$request->firstName : $request->name;

            $creditor->type = $request->type;
            $creditor->defaultExpenseId = $request->defaultExpenseId;
            $creditor->firstName = $request->firstName;
            $creditor->lastName = $request->lastName;
            $creditor->title = $request->title;
            $creditor->friendlyName = $request->friendlyName;
            $creditor->salutation = $request->salutation;
            $creditor->physicalLine1 = $request->physicalLine1;
            $creditor->physicalLine2 = $request->physicalLine2;
            $creditor->physicalLine3 = $request->physicalLine3;
            $creditor->physicalCode = $request->physicalCode;
            $creditor->physicalProvinceId = $request->physicalProvinceId;
            $creditor->physicalCountryId = $request->physicalCountryId;
            $creditor->postalLine1 = $request->postalLine1;
            $creditor->postalLine2 = $request->postalLine2;
            $creditor->postalLine3 = $request->postalLine3;
            $creditor->postalCode = $request->postalCode;
            $creditor->postalProvinceId = $request->postalProvinceId;
            $creditor->postalCountryId = $request->postalCountryId;
            $creditor->vatVendor = $request->vatVendor;
            $creditor->vatNumber = $request->vatNumber;

            $creditor->save();

            if (! isset($request->id)) {
                foreach ($request->contactNumbers as $number) {
                    $method = ContactMethod::where('type', $number['method'])->first();

                    if ($method) {
                        $creditorNumber = new CreditorNumber;
                        $creditorNumber->creditorId = $creditor->id;
                        $creditorNumber->description = $number['description'];
                        $creditorNumber->methodId = $method->id;
                        $creditorNumber->defaultFlag = $number['defaultFlag'];
                        $creditorNumber->save();
                    } else {
                        logger('System Error', ['Create Creditor - Adding Contact Numbers', 'Contact method not found', $number['method']]);
                    }
                }
            }

            // This is used in the drop downs
            $creditor->creditor = $creditor->code.' - '.$creditor->name;

            return json_encode($creditor);
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

    protected function generateCreditorCode($name)
    {
        $name = preg_replace('/[^a-zA-Z0-9]/', '', $name);

        while (strlen($name) < 3) {
            $name = $name.'1';
        }

        $code = strtoupper(substr($name, 0, 3));

        $counter = Creditor::where('code', 'like', $code.'%')->count();

        if ($counter) {
            $counter++;

            while ($counter <= 5000) {
                $existingCreditor = Creditor::where('code', $code.$counter)->first();

                if (! $existingCreditor) {
                    break;
                }

                $counter++;
            }

            return $code.$counter;
        } else {
            return $code.'1';
        }
    }
}
