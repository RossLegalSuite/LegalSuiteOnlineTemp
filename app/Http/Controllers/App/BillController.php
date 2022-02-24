<?php

namespace App\Http\Controllers\App;

use App\Models\Company;
use App\Models\Bill;
use App\Models\BillDebit;
use App\Models\Payment;
use App\Models\PaymentTransaction;
use App\Models\AccountTransaction;
use App\Models\Disbursement;
use App\Models\Batch;
use App\Models\Matter;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidDate;
use App\Rules\ValidNumber;
use App\Custom\Utils;

use Maatwebsite\Excel\Facades\Excel;
use Maatwebsite\Excel\Concerns\{FromQuery, Exportable, WithHeadings, WithEvents, RegistersEventListeners, ShouldAutoSize};
use Maatwebsite\Excel\Events\{BeforeExport, AfterSheet};
use PhpOffice\PhpSpreadsheet\Style\{NumberFormat, Alignment};

class BillController extends Controller {

    private function addColumns(&$query, $request)
    {

        $format1 = "FORMAT( ";
        $format2 = ", 2, 'en_" . session('countryCode')  . "')";

        $query->addSelect('bills.id');
        $query->addSelect('bills.reference');
        $query->addSelect('bills.date');

        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(bills.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateFormatted") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(bills.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 

        $query->addSelect('created.name as createdEmployeeName');
        $query->addSelect( DB::raw("CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END as number") );
        $query->addSelect( DB::raw("CASE WHEN bills.posted = 1 THEN 'Posted' ELSE 'Unposted' END as postedDescription") );
        

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(amount){$format2} FROM bill_totals
            WHERE billId = bills.id and type = 'Debits'), 0.00) as debits") );
    
        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(amount){$format2} FROM bill_totals
            WHERE billId = bills.id and type = 'Credits'), 0.00) as credits") );
    
        if ( $request->dataFormat === 'export' ) {
            
            $query->orderBy('bills.id');
            
        } else {

            $query->addSelect('bills.createdById');
            
            $query->addSelect('created.id as createdEmployeeId');
            
            $query->addSelect('bills.posted');
            
            //$query->addSelect('bills.matterId');
            //$query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            //$query->addSelect("matters.fileRef as matterFileRef");
            //$query->addSelect( "matters.description as matterDescription");


            $query->addSelect( "creditors.id as creditorId");
            $query->addSelect( "creditors.code as creditorCode");
            $query->addSelect( "creditors.name as creditorName");
            $query->addSelect( "creditors.salutation as creditorSalutation");
            $query->addSelect(DB::raw("CONCAT(creditors.code, ' - ', creditors.name) as creditor"));

            // $query->addSelect( "emailAddress.description as email");
            // $query->addSelect( "emailAddress.id as emailId");

            $query->addSelect( DB::raw("CASE WHEN bills.posted = 1 THEN 1 ELSE 0 END as readOnly") );

            $query->addSelect(DB::raw("IFNULL( 
                (SELECT {$format1}SUM(amount){$format2} FROM bill_totals
                WHERE billId = bills.id and type = 'Debits'), 0.00) as totalAmount") );

            $query->addSelect(DB::raw("IFNULL( 
                (SELECT SUM(amount) FROM bill_totals
                WHERE billId = bills.id and type = 'Debits'), 0.00) as totalAmountRaw") );

        }
    }

    private function addAging(&$query, $prefix) {

        $format1 = "FORMAT( ";
        $format2 = ", 2, 'en_" . session('countryCode')  . "')";

        $query->leftJoin('bill_aging', 'bills.id', '=', 'bill_aging.billId');

        $query->addSelect( DB::raw("CASE WHEN bill_aging.current IS NOT NULL THEN {$format1}bill_aging.current{$format2} ELSE 0.00 END as `{$prefix}current`"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days30 IS NOT NULL THEN {$format1}bill_aging.days30{$format2} ELSE 0.00 END as `{$prefix}days30`"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days60 IS NOT NULL THEN {$format1}bill_aging.days60{$format2} ELSE 0.00 END as `{$prefix}days60`"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days90 IS NOT NULL THEN {$format1}bill_aging.days90{$format2} ELSE 0.00 END as `{$prefix}days90`"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days120 IS NOT NULL THEN {$format1}bill_aging.days120{$format2} ELSE 0.00 END as `{$prefix}days120`"));

        $query->addSelect( DB::raw("CASE WHEN bill_aging.current IS NOT NULL THEN bill_aging.current ELSE 0.00 END as currentRaw"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days30 IS NOT NULL THEN bill_aging.days30 ELSE 0.00 END as days30Raw"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days60 IS NOT NULL THEN bill_aging.days60 ELSE 0.00 END as days60Raw"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days90 IS NOT NULL THEN bill_aging.days90 ELSE 0.00 END as days90Raw"));
        $query->addSelect( DB::raw("CASE WHEN bill_aging.days120 IS NOT NULL THEN bill_aging.days120 ELSE 0.00 END as days120Raw"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(balance){$format2} FROM bill_balances 
            WHERE billId = bills.id), 0.00) as `{$prefix}balance`") );

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT SUM(balance) FROM bill_balances 
            WHERE billId = bills.id), 0.00) as balanceRaw") );

    }

    private function addTableJoins(&$query)
    {
        $query->join('employees as created', 'created.id', '=', 'bills.createdById')
        ->leftJoin('creditors', 'bills.creditorId', '=', 'creditors.id');
        
        // ->leftJoin('creditor_numbers as emailAddress', function ($join)  {
        //     $join->on('creditors.id', '=', 'emailAddress.creditorId')
        //         ->whereRaw('emailAddress.id IN (select max(id) from creditor_numbers WHERE methodId = ' . session('emailMethodId') . ' AND creditorId = creditors.id AND defaultFlag = 1 group by methodId)');
        // });


    }

    public function get(Request $request)
    {
        $prefix = ( $request->dataFormat === 'mergeArray' ) ? 'bill-&gt;' : '';

        $query = DB::table('bills');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        $this->addAging($query, $prefix);        

        if ($request->parentId) $query->where('bills.creditorId',$request->parentId);

        if ($request->createdById) $query->where('bills.createdById',$request->createdById);

        if ($request->posted) $query->where('posted',1);

        if ($request->id) $query->where('bills.id',$request->id);

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        //Utils::LogSqlQuery($query);

        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            // Customize global search function. See: https://yajrabox.com/docs/laravel-datatables/6.0/filter-column
            if ($keyword = $request->get('search')['value'] ) {

                $datatables->filterColumn('number', function($query, $keyword) {
                    $sql = "CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('date', function($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(bills.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('creditor', function($query, $keyword) {
                    $sql = "CONCAT(creditors.code, ' - ', creditors.name) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('postedDescription', function($query, $keyword) {
                    $sql = "CASE WHEN bills.posted = 1 THEN 'Posted' ELSE 'Unposted' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('totalAmountRaw', function($query, $keyword) {
                    $sql = "IFNULL( 
                    (SELECT SUM(amount) FROM bill_debits
                    WHERE billId = bills.id and type = 'Debits'), 0.00) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });

            } else if ( $request->tableFilter ) {

                $datatables->filterColumn('totalAmountRaw', function($query, $keyword) {
                    $sql = "IFNULL( 
                    (SELECT SUM(amount) FROM bill_debits
                    WHERE billId = bills.id and type = 'Debits'), 0.00) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('balanceRaw', function($query, $keyword) {
                    $sql = "IFNULL( 
                        (SELECT SUM(balance) FROM bill_balances 
                        WHERE billId = bills.id GROUP BY billId), 0.00) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });


            }

            return $datatables->make(true);

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }

    }


    public function getBalance(Request $request)
    {

        $query = DB::table('bills')
        ->addSelect(DB::raw("IFNULL( (SELECT SUM(balance) FROM bill_balances WHERE billId = bills.id), 0.00) as balance") )
        ->where('id', $request->id );

        return $query->get()->toJson();


    }

    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [];

        if ( isset($request->id) )  {

            $rules = [
                'creditorId' => 'required',
                'createdById' => 'required',
                'reference' => 'required',
                'dateTime' => new ValidDate,
            ];

        }
        
        $messages = [
            'creditorId.required' => 'Please select a Creditor',
            'reference.required' => 'Please provide a Reference',
        ];
        

        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            //https://fideloper.com/laravel-database-transactions

            return DB::transaction( function() use ($request)
            {

                $record = ( isset($request->id) ) ? Bill::findOrFail($request->id) : new Bill;

                $record->creditorId = $request->creditorId;
                $record->createdById = $request->createdById;
                $record->date = Utils::convertDateTime($request->dateTime);
                $record->reference = $request->reference;
                $record->posted = $request->posted;

                $record->save();  

                if ( isset($request->posted) && $request->posted == 1 ) {

                    $company = Company::first();

                    $totalExclAmount = DB::table('bill_debits')
                    ->where('billId',$request->id)
                    ->sum('amount');

                    $totalTaxAmount = DB::table('bill_debits')
                    ->where('billId',$request->id)
                    ->sum('taxAmount');


                    $batch = Batch::create([
                        'date' => date("Y-m-d H:i:s"),
                        'employeeId' => session('employeeId'),
                        'type' => 'Bill',
                        'reference' => 'Bill: ' . $record->reference,
                    ]);

                    // **********************************************
                    // Credit (Increase) Credtors Control Account (Type = Liability)
                    // **********************************************
                    AccountTransaction::create([
                        'batchId' => $batch->id,
                        'type' => 'Credit',
                        'accountId' => $company->creditorsControlAccountId,
                        'amount' => $totalExclAmount + $totalTaxAmount,
                    ]);

                    // **********************************************
                    // Debit (Increase) Expense Accounts
                    // **********************************************

                    $expenses = BillDebit::where('billId',$request->id)->where('type','Expense')->get();

                    foreach ($expenses as $expense) {

                        AccountTransaction::create([
                            'batchId' => $batch->id,
                            'type' => 'Debit',
                            'accountId' => $expense->expenseAccountId,
                            'amount' => $expense->amount
                        ]);

                        // **********************************************
                        // Debit (Reduce) Vat Control Account (Type = Liability)
                        // **********************************************
                        if ( $expense->taxAmount > 0 ) {

                            AccountTransaction::create([
                                'batchId' => $batch->id,
                                'type' => 'Debit',
                                'accountId' => $company->salesTaxControlAccountId,
                                'amount' => $expense->taxAmount,
                            ]);
    
                        }

                    }

                    $disbursements = BillDebit::where('billId',$request->id)->where('type','Disbursement')->get();

                    foreach ($disbursements as $disbursement) {

                        AccountTransaction::create([
                            'batchId' => $batch->id,
                            'type' => 'Debit',
                            'accountId' => $company->disbursementsControlAccountId,
                            'amount' => $disbursement->amount + $disbursement->taxAmount 
                        ]);

                        Disbursement::create([
                            'date' => date("Y-m-d H:i:s"),
                            'createdById' => $disbursement->createdById,
                            'matterId' => $disbursement->matterId,
                            'creditorId' => $record->creditorId,
                            'batchId' => $batch->id,
                            'taxRateId' => $disbursement->taxRateId,
                            'description' => $disbursement->description,
                            'taxAmount' => $disbursement->taxAmount,
                            'amount' => $disbursement->amount,
                        ]);
                    }

                }
                
                return json_encode($record);

            });

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
                    "Bill No",
                    "Date Due",
                    "Posted",
                    "Fees",
                    "Disbursements",
                    "Subtotal",
                    "Tax",
                    "Total",
                ];
            }

            public function registerEvents(): array
            {
                return [

                    AfterSheet::class => function(AfterSheet $event) {

                        $event->sheet->styleCells(
                            'A6:A11',
                            [
                                'alignment' => [
                                    'horizontal' => Alignment::HORIZONTAL_RIGHT,
                                ],
                            ]
                        );
                    },

                    BeforeExport::class => function(BeforeExport $event) {

                        $event->writer->getProperties()->setTitle('Bills');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },
                ];
            }

            public function query() { return $this->query; }
            

        },'bills.xlsx');

    }

}
