<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Account;
use App\Models\AccountTransaction;
use App\Models\Batch;
use App\Models\Company;
use App\Models\Creditor;
use App\Models\FeeNote;
use App\Models\Invoice;
use App\Models\Matter;
use App\Models\Party;
use App\Rules\ValidDate;
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
use Storage;

class InvoiceController extends Controller
{
    private function addColumns(&$query, $request)
    {
        $format1 = 'FORMAT( ';
        $format2 = ", 2, 'en_".session('countryCode')."')";

        $query->addSelect('invoices.id');
        $query->addSelect('created.name as createdEmployeeName');
        $query->addSelect(DB::raw("CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END as number"));
        $query->addSelect(DB::raw("CASE WHEN invoices.posted = 1 THEN 'Posted' ELSE 'Unposted' END as postedDescription"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(matter_debits.amount){$format2} FROM matter_debits
            WHERE matter_debits.invoiceId = invoices.id AND matter_debits.type = 'Fee'
            GROUP BY matter_debits.invoiceId), 0.00) as fees"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(matter_debits.amount){$format2} FROM matter_debits
            WHERE matter_debits.invoiceId = invoices.id AND matter_debits.type = 'Disbursement'
            GROUP BY matter_debits.invoiceId), 0.00) as disbursements"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(matter_debits.taxAmount){$format2} FROM matter_debits
            WHERE matter_debits.invoiceId = invoices.id 
            GROUP BY matter_debits.invoiceId), 0.00) as tax"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(amount){$format2} FROM invoice_totals
            WHERE invoiceId = invoices.id and type = 'Debits'), 0.00) as debits"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(amount){$format2} FROM invoice_totals
            WHERE invoiceId = invoices.id and type = 'Credits'), 0.00) as credits"));

        // $query->addSelect(DB::raw("IFNULL(
        //     (SELECT {$format1}SUM(amount){$format2} FROM invoice_totals
        //     WHERE invoiceId = invoices.id), 0.00) as balance") );

        if ($request->dataFormat === 'export') {
            $query->orderBy('invoices.id');
        } else {
            $query->addSelect('invoices.createdById');

            $query->addSelect('created.id as createdEmployeeId');

            $query->addSelect('invoices.posted');
            $query->addSelect('invoices.date');
            $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));
            $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

            $query->addSelect('invoices.matterId');
            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.fileRef as matterFileRef');
            $query->addSelect('matters.description as matterDescription');

            $query->addSelect('invoices.incomeAccountId');
            $query->addSelect('accounts.id as accountId');
            $query->addSelect('accounts.code as accountCode');
            $query->addSelect('accounts.description as accountDescription');
            $query->addSelect('accounts.category as accountCategory');

            $query->addSelect('client.id as partyId');
            $query->addSelect('client.code as partyCode');
            $query->addSelect('client.name as party');

            $query->addSelect('client.id as clientId');
            $query->addSelect('client.code as clientCode');
            $query->addSelect('client.name as clientName');
            $query->addSelect('client.salutation as clientSalutation');
            $query->addSelect(DB::raw("CONCAT(client.code, ' - ', client.name) as client"));

            $query->addSelect('emailAddress.description as email');
            $query->addSelect('emailAddress.id as emailId');

            $query->addSelect(DB::raw('CASE WHEN invoices.posted = 1 THEN 1 ELSE 0 END as readOnly'));

            $query->addSelect(DB::raw("IFNULL( 
                (SELECT {$format1}SUM(amount){$format2} FROM invoice_totals
                WHERE invoiceId = invoices.id and type = 'Debits'), 0.00) as totalAmount"));

            $query->addSelect(DB::raw("IFNULL( 
                (SELECT SUM(amount) FROM invoice_totals
                WHERE invoiceId = invoices.id and type = 'Debits'), 0.00) as totalAmountRaw"));
        }
    }

    private function addAging(&$query)
    {
        $format1 = 'FORMAT( ';
        $format2 = ", 2, 'en_".session('countryCode')."')";

        $query->leftJoin('invoice_aging', 'invoices.id', '=', 'invoice_aging.invoiceId');

        $query->addSelect(DB::raw("CASE WHEN invoice_aging.current IS NOT NULL THEN {$format1}invoice_aging.current{$format2} ELSE 0.00 END as current"));
        $query->addSelect(DB::raw("CASE WHEN invoice_aging.days30 IS NOT NULL THEN {$format1}invoice_aging.days30{$format2} ELSE 0.00 END as days30"));
        $query->addSelect(DB::raw("CASE WHEN invoice_aging.days60 IS NOT NULL THEN {$format1}invoice_aging.days60{$format2} ELSE 0.00 END as days60"));
        $query->addSelect(DB::raw("CASE WHEN invoice_aging.days90 IS NOT NULL THEN {$format1}invoice_aging.days90{$format2} ELSE 0.00 END as days90"));
        $query->addSelect(DB::raw("CASE WHEN invoice_aging.days120 IS NOT NULL THEN {$format1}invoice_aging.days120{$format2} ELSE 0.00 END as days120"));

        $query->addSelect(DB::raw('CASE WHEN invoice_aging.current IS NOT NULL THEN invoice_aging.current ELSE 0.00 END as currentRaw'));
        $query->addSelect(DB::raw('CASE WHEN invoice_aging.days30 IS NOT NULL THEN invoice_aging.days30 ELSE 0.00 END as days30Raw'));
        $query->addSelect(DB::raw('CASE WHEN invoice_aging.days60 IS NOT NULL THEN invoice_aging.days60 ELSE 0.00 END as days60Raw'));
        $query->addSelect(DB::raw('CASE WHEN invoice_aging.days90 IS NOT NULL THEN invoice_aging.days90 ELSE 0.00 END as days90Raw'));
        $query->addSelect(DB::raw('CASE WHEN invoice_aging.days120 IS NOT NULL THEN invoice_aging.days120 ELSE 0.00 END as days120Raw'));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}balance{$format2} FROM invoice_balances 
            WHERE invoiceId = invoices.id), 0.00) as balance"));

        $query->addSelect(DB::raw('IFNULL( 
            (SELECT balance FROM invoice_balances 
            WHERE invoiceId = invoices.id), 0.00) as balanceRaw'));
    }

    private function addTableJoins(&$query)
    {
        $query->join('employees as created', 'created.id', '=', 'invoices.createdById')

        ->join('matters', 'matters.id', '=', 'invoices.matterId')

        ->leftJoin('matter_parties as clientParty', function ($join) {
            $join->on('matters.id', '=', 'clientParty.matterId')
            ->where('clientParty.roleId', session('clientRoleId'))
            ->where('clientParty.rank', 1);
        })

        ->leftJoin('parties as client', 'clientParty.partyId', '=', 'client.id')

        ->leftJoin('party_numbers as emailAddress', function ($join) {
            $join->on('client.id', '=', 'emailAddress.partyId')
            ->whereRaw('emailAddress.id IN (select max(id) from party_numbers WHERE methodId = '.session('emailMethodId').' AND partyId = client.id AND defaultFlag = 1 group by methodId)');
        })
        ->leftJoin('accounts', 'invoices.incomeAccountId', '=', 'accounts.id');
    }

    public function get(Request $request)
    {
        $query = DB::table('invoices');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        $this->addAging($query);

        if ($request->partyId) {
            $query->where('client.id', $request->partyId);
        }

        if ($request->matterId) {
            $query->where('invoices.matterId', $request->matterId);
        }

        if ($request->parentId) {
            $query->where('invoices.matterId', $request->parentId);
        }

        if ($request->createdById) {
            $query->where('invoices.createdById', $request->createdById);
        }

        if ($request->posted) {
            $query->where('posted', 1);
        }

        if ($request->id) {
            $query->where('invoices.id', $request->id);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        //Utils::LogSqlQuery($query);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            // Customize global search function. See: https://yajrabox.com/docs/laravel-datatables/6.0/filter-column
            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('number', function ($query, $keyword) {
                    $sql = "CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('matter', function ($query, $keyword) {
                    $sql = "CONCAT(matters.fileRef, ' - ', matters.description) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('postedDescription', function ($query, $keyword) {
                    $sql = "CASE WHEN invoices.posted = 1 THEN 'Posted' ELSE 'Unposted' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('totalAmountRaw', function ($query, $keyword) {
                    $sql = "IFNULL( 
                    (SELECT SUM(amount) FROM invoice_totals
                    WHERE invoiceId = invoices.id and type = 'Debits'), 0.00) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            } elseif ($request->tableFilter) {
                $datatables->filterColumn('totalAmountRaw', function ($query, $keyword) {
                    $sql = "IFNULL( 
                    (SELECT SUM(amount) FROM invoice_totals
                    WHERE invoiceId = invoices.id and type = 'Debits'), 0.00) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('balanceRaw', function ($query, $keyword) {
                    $sql = 'IFNULL( 
                        (SELECT SUM(balance) FROM invoice_balances 
                        WHERE invoiceId = invoices.id), 0.00) like ?';
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

        $rules = [];

        if (isset($request->id)) {
            $rules = [
                'matterId' => 'required',
                'createdById' => 'required',
                'dateTime' => new ValidDate,
            ];
        }

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {

            //https://fideloper.com/laravel-database-transactions

            return DB::transaction(function () use ($request) {
                $record = (isset($request->id)) ? Invoice::findOrFail($request->id) : new Invoice;

                $record->matterId = $request->matterId;
                $record->createdById = $request->createdById;
                $record->date = Utils::convertDateTime($request->dateTime);
                $record->posted = $request->posted;
                $record->incomeAccountId = $request->incomeAccountId;

                $record->save();

                if (isset($request->posted) && $request->posted == 1) {
                    $company = Company::first();

                    $totalFeesExclAmount = DB::table('matter_debits')
                    ->where('invoiceId', $request->id)
                    ->where('type', 'Fee')
                    ->sum('amount');

                    $totalFeesTaxAmount = 0;

                    if ($totalFeesExclAmount > 0) {
                        $totalFeesTaxAmount = DB::table('matter_debits')
                        ->where('invoiceId', $request->id)
                        ->where('type', 'Fee')
                        ->sum('taxAmount');
                    }

                    $totalDisbursementsAmount = DB::table('matter_debits')
                    ->where('invoiceId', $request->id)
                    ->where('type', 'Disbursement')
                    ->sum('totalAmount');

                    $batch = Batch::create([
                        'date' => date('Y-m-d H:i:s'),
                        'employeeId' => session('employeeId'),
                        'type' => 'Invoice',
                        'reference' => 'Invoice: '.Utils::padNumber($record->id),
                    ]);

                    // **********************************************
                    // Fees: Debit (Increase) Debtors Control Account (Type = Asset)
                    // **********************************************

                    AccountTransaction::create([
                        'batchId' => $batch->id,
                        'type' => 'Debit',
                        'accountId' => $company->debtorsControlAccountId,
                        'invoiceId' => $record->id,
                        'amount' => $totalFeesExclAmount + $totalFeesTaxAmount + $totalDisbursementsAmount,
                    ]);

                    if ($totalFeesExclAmount > 0) {

                        // **********************************************
                        // Fees: Credit (Increase) Income Account BY THE FEE AMOUNT (Type = Income)
                        // **********************************************
                        AccountTransaction::create([
                            'batchId' => $batch->id,
                            'type' => 'Credit',
                            'accountId' => $request->incomeAccountId,
                            'invoiceId' => $record->id,
                            'amount' => $totalFeesExclAmount,
                        ]);
                    }

                    // **********************************************
                    // Fees: Credit (Increase) Vat Control Account (Type = Liability)
                    // **********************************************

                    if ($totalFeesTaxAmount > 0) {
                        AccountTransaction::create([
                            'batchId' => $batch->id,
                            'type' => 'Credit',
                            'accountId' => $company->salesTaxControlAccountId,
                            'invoiceId' => $record->id,
                            'amount' => $totalFeesTaxAmount,
                        ]);
                    }

                    // ***************************************************************
                    // Disbursements: Credit (Decrease) the Disbursement Control Account (Asset)
                    // ***************************************************************

                    $disbursements = DB::table('matter_debits')
                    ->where('invoiceId', $request->id)
                    ->where('type', 'Disbursement')
                    ->get();

                    // See: https://help.kashoo.com/en/articles/370374-kashoo-classic-recording-reimbursable-expenses

                    if (! $disbursements->isEmpty()) {
                        $disbursements->each(function ($disbursement) use ($company, $batch, $record) {
                            $disbursementChildAccount = Utils::getDisbursementsControlAccount($company->disbursementsControlAccountId, $disbursement->id, $disbursement->description);

                            // **********************************************
                            // Credit Disbursement Control Account (Type = Asset)
                            // **********************************************
                            AccountTransaction::create([
                                'batchId' => $batch->id,
                                'type' => 'Credit',
                                'accountId' => $disbursementChildAccount->id,
                                'disbursementId' => $disbursement->id,
                                'invoiceId' => $record->id,
                                'amount' => $disbursement->totalAmount,
                            ]);

                            // **********************************************
                            // Debit Debtors Control Account (Type = Asset)
                            // **********************************************

                            // AccountTransaction::create([
                            //     'batchId' => $batch->id,
                            //     'type' => 'Debit',
                            //     'accountId' => $company->debtorsControlAccountId,
                            //     'invoiceId' => $record->id,
                            //     'amount' => $disbursement->totalAmount,
                            // ]);
                        });
                    }
                }

                return json_encode($record);
            });
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
                    'Invoice No',
                    'Date Due',
                    'Posted',
                    'Fees',
                    'Disbursements',
                    'Subtotal',
                    'Tax',
                    'Total',
                ];
            }

            public function registerEvents(): array
            {
                return [

                    AfterSheet::class => function (AfterSheet $event) {
                        $event->sheet->styleCells(
                            'A6:A11',
                            [
                                'alignment' => [
                                    'horizontal' => Alignment::HORIZONTAL_RIGHT,
                                ],
                            ]
                        );
                    },

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Invoices');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },
                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'invoices.xlsx');
    }
}
