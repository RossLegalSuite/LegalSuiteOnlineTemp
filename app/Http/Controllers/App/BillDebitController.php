<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Bill;
use App\Models\BillDebit;
use App\Models\Company;
use App\Rules\ValidNumber;
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

class BillDebitController extends Controller
{
    private function addColumns(&$query, $request)
    {
        $query->addSelect('bill_debits.id');

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(bill_debits.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as date"));
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(bill_debits.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect('created.name as createdEmployeeName');

        $query->addSelect('bill_debits.type');
        $query->addSelect('bill_debits.description');
        $query->addSelect('matters.fileRef as matterFileRef');

        $query->addSelect('bill_debits.expenseAccountId');
        $query->addSelect('accounts.id as accountId');
        $query->addSelect('accounts.code as accountCode');
        $query->addSelect('accounts.description as accountDescription');
        $query->addSelect('accounts.category as accountCategory');

        $query->addSelect(DB::raw("CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id  END as billNumber"));

        if ($request->dataFormat === 'export') {
            $query->orderBy('bill_debits.id');

            $query->addSelect('bill_debits.taxAmount');
            $query->addSelect('bill_debits.amount');
            $query->addSelect('bill_debits.totalAmount');
        } else {
            $query->addSelect(DB::raw("CONCAT(accounts.code, ' - ', accounts.description) as account"));

            $query->addSelect(DB::raw("FORMAT(bill_debits.taxAmount, 2, 'en_".session('countryCode')."') as taxAmount"));
            $query->addSelect(DB::raw("FORMAT(bill_debits.amount, 2, 'en_".session('countryCode')."') as amount"));
            $query->addSelect(DB::raw("FORMAT(bill_debits.totalAmount, 2, 'en_".session('countryCode')."') as totalAmount"));

            $query->addSelect('bill_debits.totalAmount as totalAmountRaw');

            $query->addSelect('bill_debits.matterId');
            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.id as matterId');
            $query->addSelect('matters.description as matterDescription');

            $query->addSelect('bill_debits.taxRateId');
            $query->addSelect('bills.posted as billPosted');
            $query->addSelect('bills.posted as readOnly');

            $query->addSelect('bill_debits.createdById');
            $query->addSelect('created.id as createdEmployeeId');

            $query->addSelect('bill_debits.billId');
        }
    }

    private function addTableJoins(&$query)
    {
        $query
        ->leftJoin('matters', 'matters.id', '=', 'bill_debits.matterId')
        ->join('employees as created', 'created.id', '=', 'bill_debits.createdById')
        ->leftJoin('bills', 'bills.id', '=', 'bill_debits.billId')
        ->leftJoin('accounts', 'bill_debits.expenseAccountId', '=', 'accounts.id');
    }

    public function get(Request $request)
    {
        $query = DB::table('bill_debits');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->posted) {
            $query->where('bills.posted', 1);
        }

        if ($request->id) {
            $query->where('bill_debits.id', $request->id);
        } elseif ($request->matterId) {
            $query->where('bill_debits.matterId', $request->matterId);
        } elseif ($request->employeeId) {
            $query->where('bill_debits.createdById', $request->employeeId);
        } elseif ($request->createdById) {
            $query->where('bill_debits.createdById', $request->createdById);
        } elseif ($request->parentId) {
            $query->where('bill_debits.billId', $request->parentId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('billNumber', function ($query, $keyword) {
                    $sql = "CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })

                ->filterColumn('account', function ($query, $keyword) {
                    $sql = "CONCAT(accounts.code, ' - ', accounts.description) OR CONCAT(matters.fileRef, ' - ', matters.description) like ?";
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
            'taxRateId' => 'required',
            'description' => 'required',
            'type' => 'required',
            'amount' => new ValidNumber,
        ];

        if ($request->type === 'Disbursement') {
            $rules['matterId'] = 'required';
        } else {
            $rules['expenseAccountId'] = 'required';
        }

        $messages = [
            'matterId.required' => 'Please select a Matter',
            'expenseAccountId.required' => 'Please select an Expense Account',
            'createdById.required' => 'Please select an Employee',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? BillDebit::findOrFail($request->id) : new BillDebit;

            $record->date = date('Y-m-d H:i:s', strtotime(Carbon::now()));
            $record->matterId = $request->matterId;
            $record->expenseAccountId = $request->expenseAccountId;
            $record->createdById = $request->createdById;
            $record->billId = $request->billId;
            $record->taxRateId = $request->taxRateId;
            $record->description = $request->description;
            $record->type = $request->type;

            $record->amount = $request->amount;
            $record->taxAmount = $request->taxAmount;

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
        return DataTablesHelper::destroy($request, BillDebit::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('bill_debits')
        ->where('id', '<', $request->id)
        ->orderBy('id')
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
                    'Matter',
                    'Bill No',
                    'Net Amount',
                    'Tax',
                    'Amount',
                ];
            }

            public function registerEvents(): array
            {
                return [
                    AfterSheet::class => function (AfterSheet $event) {
                        $event->sheet->styleCells(
                            'A8:A10',
                            [
                                'alignment' => [
                                    'horizontal' => Alignment::HORIZONTAL_RIGHT,
                                ],
                            ]
                        );
                    },

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Items');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },

                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'billDebits.xlsx');
    }
}
