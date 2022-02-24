<?php

namespace App\Http\Controllers\App;

use App\Models\Payment;
use App\Models\BillCredit;
use App\Models\Disbursement;
use App\Models\AccountTransaction;
use App\Models\Batch;
use App\Models\Account;
use App\Models\Company;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use Illuminate\Support\Facades\Validator;
use App\Rules\ValidDate;
use App\Rules\ValidNumber;
use Illuminate\Validation\Rule;
use App\Custom\Utils;

class PaymentController extends Controller {


    private function addColumns(&$query, $request)
    {

        $query->addSelect('payments.id');
        $query->addSelect('payments.createdById');

        $query->addSelect('created.id as createdEmployeeId');
        $query->addSelect('created.name as createdEmployeeName');

        $query->addSelect( DB::raw("CASE WHEN payments.id < 10000 THEN LPAD(payments.id,5,'0') ELSE payments.id END as number") );
        $query->addSelect('payments.method');
        $query->addSelect('payments.reference');

        //$query->addSelect('payments.description');
        $query->addSelect( DB::raw("CASE WHEN payments.type = 'Creditor' THEN creditors.name ELSE payments.description END as description") );

        $query->addSelect('payments.type');
        $query->addSelect('payments.posted');
        $query->addSelect('payments.taxRateId');

        $query->addSelect( DB::raw("CASE WHEN payments.posted = 1 THEN 'Posted' ELSE 'Unposted' END as postedDescription") );
        
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payments.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as date") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payments.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payments.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateFormatted") );
        
        $query->addSelect('payments.creditorId');
        $query->addSelect('payments.matterId');
        $query->addSelect('payments.disbursementId');
        $query->addSelect('payments.ledgerAccountId');
        
        $query->addSelect( "emailAddress.description as email");
        $query->addSelect( "emailAddress.id as emailId");

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
        $query->addSelect(DB::raw("CONCAT(accounts.code, ' - ', accounts.description) as account"));

        $query->addSelect( "creditors.code as creditorCode");
        $query->addSelect( "creditors.name as creditor");

        $query->addSelect("payments.bankAccountId");   
        $query->addSelect("bankAccount.description as bankAccountDescription");        

        $query->addSelect( DB::raw("CASE WHEN payments.posted = 1 THEN 1 ELSE 0 END as readOnly") );

        if ($request->dataFormat === "dataTables") {
            $query->addSelect(DB::raw( "FORMAT(payments.amount, 2, 'en_" . session('countryCode')  . "') as amount") );
            $query->addSelect(DB::raw( "FORMAT(taxAmount, 2, 'en_" . session('countryCode')  . "') as taxAmount") );
            $query->addSelect(DB::raw( "FORMAT(totalAmount, 2, 'en_" . session('countryCode')  . "') as totalAmount") );
        } else {
            $query->addSelect('payments.amount');
            $query->addSelect('payments.taxAmount');
            $query->addSelect('payments.totalAmount');
        }

    }


    public function get(Request $request)
    {

        $query = DB::table('payments')
        ->join('employees as created', 'created.id', '=', 'payments.createdById')
        ->leftJoin('creditors', 'creditors.id', '=', 'payments.creditorId')
        ->leftJoin('accounts as bankAccount', 'payments.bankAccountId', '=', 'bankAccount.id')
        ->leftJoin('matters', 'matters.id', '=', 'payments.matterId')
        ->leftJoin('accounts', 'accounts.id', '=', 'payments.ledgerAccountId')
        ->leftJoin('creditor_numbers as emailAddress', function ($join)  {
            $join->on('creditors.id', '=', 'emailAddress.creditorId')
                ->whereRaw('emailAddress.id IN (select max(id) from creditor_numbers WHERE methodId = ' . session('emailMethodId') . ' AND creditorId = creditors.id AND defaultFlag = 1 group by methodId)');
        });



        $this->addColumns($query, $request);

        if ($request->id) $query->where('payments.id',$request->id);

        if ($request->creditorId) $query->where('payments.creditorId',$request->creditorId);

        if ($request->posted) $query->where('posted',1);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        // Utils::LogSqlQuery($query);

        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            // Customize global search function. See: https://yajrabox.com/docs/laravel-datatables/6.0/filter-column
            if ($keyword = $request->get('search')['value']) {

                $datatables->filterColumn('number', function($query, $keyword) {
                    $sql = "CASE WHEN payments.id < 10000 THEN LPAD(payments.id,5,'0') ELSE payments.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('date', function($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(payments.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('postedDescription', function($query, $keyword) {
                    $sql = "CASE WHEN payments.posted = 1 THEN 'Posted' ELSE 'Unposted' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }

    }


    public function getPostedBills(Request $request)
    {
        
        $query = DB::table('bills');

        $query->where('bills.creditorId',$request->parentId);

        // To only show Bills with Balances
        if ($request->customTableHaving) $query->havingRaw($request->customTableHaving);

        $query->where('bills.posted',1);

        $query->orderBy('bills.id', 'asc');

        $query->addSelect('bills.id'); // Need this for Datatables

        $query->addSelect('bills.id as billId');
        $query->addSelect('bills.reference');
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(bills.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as billDate") ); 
        $query->addSelect( DB::raw("CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END as billNumber") );
        
        // $query->addSelect('matters.id as matterId');
        // $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT FORMAT( SUM(amount), 2, 'en_" . session('countryCode')  . "') FROM bill_totals
            WHERE billId = bills.id), 0.00) as balance") );

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT SUM(amount) FROM bill_totals
            WHERE billId = bills.id), 0.00) as balanceRaw") );


        $datatables = Datatables::of($query);

        if ($keyword = $request->get('search')['value'] ) {

            $datatables->filterColumn('billDate', function($query, $keyword) {
                $sql = "DATE_FORMAT( CONVERT_TZ(bills.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            })
            ->filterColumn('billNumber', function($query, $keyword) {
                $sql = "CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            })
            ->filterColumn('totalBalance', function($query, $keyword) {
                $sql = "IFNULL( 
                (SELECT SUM(amount) FROM bill_transactions
                WHERE billId = bills.id ), 0.00) like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            });            

        } else if ( $request->tableFilter ) {

            $datatables->filterColumn('totalBalance', function($query, $keyword) {
                $sql = "IFNULL( 
                (SELECT SUM(amount) FROM bill_transactions
                WHERE billId = bills.id ), 0.00) like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            });



        }

        return $datatables->make(true);
        
    }     

    public function getPaidBills(Request $request)
    {

        $format1 = "FORMAT( ";
        $format2 = ", 2, 'en_" . session('countryCode')  . "')";
        
        $query = DB::table('bill_credits')
        ->join('payments', 'payments.id', '=', 'bill_credits.paymentId')
        ->join('bills', 'bills.id', '=', 'bill_credits.billId');

        if ($request->parentId) $query->where('bill_credits.paymentId', $request->parentId);

        $query->orderBy('bills.id', 'asc');

        $query->addSelect('bill_credits.id');

        $query->addSelect('bill_credits.amount');
        $query->addSelect('bill_credits.date');

        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payments.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateFormatted") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payments.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 


        // $query->addSelect( DB::raw("CASE WHEN payments.id < 10000 THEN LPAD(payments.id,5,'0') ELSE payments.id  END as paymentNumber") );
        // $query->addSelect('payments.id as paymentId');
        // $query->addSelect('payments.method as paymentMethod');
        // $query->addSelect('payments.reference as paymentReference');
        // $query->addSelect('payments.type as type');
        // $query->addSelect('payments.posted as paymentPosted');
        
        $query->addSelect( DB::raw("CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END as billNumber") );
        $query->addSelect('bills.reference');


        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(amount){$format2} FROM bill_totals
            WHERE billId = bills.id), 0.00) as balance") );

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT SUM(amount) FROM bill_totals
            WHERE billId = bills.id), 0.00) as balanceRaw") );


        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value'] ) {

                $datatables->filterColumn('billNumber', function($query, $keyword) {
                    $sql = "CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });

            } else if ( $request->tableFilter ) {

                $datatables->filterColumn('balanceRaw', function($query, $keyword) {
                    $sql = "IFNULL( 
                        (SELECT SUM(amount) FROM bill_totals 
                        WHERE billId = bills.id), 0.00) like ?";
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
            'method' => 'required',
            'dateTime' => new ValidDate,
        ];

        $messages = [];

        if ( isset($request->posted) && $request->posted == 1) {

            if ( $request->type === 'Creditor' ) {

                $rules['creditorId'] =  ['required']; 
                $messages['creditorId.required'] = 'Please select a Creditor';

            } else {

                $rules['amount'] = new ValidNumber;
                $rules['description'] = 'required';
                $messages['description.required'] = 'Please provide a description';

                if ( $request->type === 'Disbursement' ) {
                    $rules['matterId'] = 'required';
                    $messages['matterId.required'] = 'Please select a Matter';
                } else if ( $request->type === 'Expense' || $request->type === 'Asset' ) {
                    $rules['ledgerAccountId'] = 'required';
                    $messages['ledgerAccountId.required'] = 'Please select an Account';
                }
            }

        }        

        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {
            $returnData->errors = $validator->errors();
            return json_encode($returnData);            
        }        

        try {

            return DB::transaction( function() use ($request)
            {

                $record = ( isset($request->id) ) ? Payment::findOrFail($request->id) : new Payment;

                $record->createdById = $request->createdById;
                $record->date = Utils::convertDateTime($request->dateTime);
                $record->method = $request->method;
                $record->reference = $request->reference;
                $record->type = $request->type;
                $record->posted = $request->posted;
                $record->bankAccountId = $request->bankAccountId;
                
                $record->creditorId = $record->type === 'Creditor' ? $request->creditorId : null;
                $record->matterId = $record->type === 'Disbursement' ? $request->matterId : null;
                $record->ledgerAccountId = $record->type === 'Expense' || $record->type === 'Asset' ? $request->ledgerAccountId : null;
    
                $record->description = $request->description;
                
                $record->taxRateId = $request->taxRateId;

                $record->amount = $request->amount;
                $record->taxAmount = $request->taxAmount;

                //*************************************************************
                // For Creditors set the Amount to the total of the Bills Paid
                //*************************************************************
                if ( $request->type === 'Creditor' && isset($request->posted) && $request->posted == 1) {

                    $record->amount = 0;
                    $record->taxAmount = 0;
    
                    foreach(json_decode($request->allocatedBills) as $allocatedBill) {
                        
                        $record->amount += $allocatedBill->amount;

                    }
                }

                $record->save();  

                //logger('$record',[$record]);

                if ( isset($request->posted) && $request->posted == 1) {

                    $company = Company::first();

                    $totalAmount = 0;

                    $batch = Batch::create([
                        'date' => date("Y-m-d H:i:s"),
                        'employeeId' => session('employeeId'),
                        'type' => 'Payment',
                        'reference' => 'Payment: ' . Utils::padNumber($record->id),
                    ]);
                        
                    if ( $request->type === 'Creditor') {
                            
                        foreach(json_decode($request->allocatedBills) as $allocatedBill) {
                            
                            BillCredit::create([
                                'date' => Utils::convertDateTime($request->dateTime),
                                'paymentId' => $record->id,
                                'billId' => $allocatedBill->billId,
                                'amount' => $allocatedBill->amount,
                            ]);

                            $totalAmount += $allocatedBill->amount;

                        }


                        // **********************************************
                        // Debit (Decrease) Credtors Control Account (Type = Liability)
                        // **********************************************
                        AccountTransaction::create([
                            'batchId' => $batch->id,
                            'type' => 'Debit',
                            'accountId' => $company->creditorsControlAccountId,
                            'amount' => $totalAmount,
                        ]);


                    } else {
                    
                        $totalAmount = $record->amount + $record->taxAmount;

                        if ( $request->type === 'Expense' || $request->type === 'Asset') {

                            // **********************************************
                            // Debit (Decrease) Ledger Account (Type = Expense or Asset)
                            // **********************************************
                            AccountTransaction::create([
                                'batchId' => $batch->id,
                                'type' => 'Debit',
                                'accountId' => $request->ledgerAccountId,
                                'paymentId' => $record->id,
                                'amount' => $record->amount,
                            ]);

                            if ( $record->taxAmount > 0 ) {

                                // **********************************************
                                // Debit (Decrease) Vat Control Account (Type = Liability)
                                // **********************************************

                                AccountTransaction::create([
                                    'batchId' => $batch->id,
                                    'type' => 'Debit',
                                    'accountId' => $company->salesTaxControlAccountId,
                                    'paymentId' => $record->id,
                                    'amount' => $record->taxAmount,
                                ]);
        
                            }

                        } else if ( $request->type === 'Disbursement') {

                            $disbursement = Disbursement::create([
                                'date' => Utils::convertDateTime($request->dateTime),
                                'matterId' => $request->matterId,
                                'createdById' => $request->createdById,
                                'taxRateId' => $request->taxRateId,
                                'bankAccountId' => $request->bankAccountId,
                                'batchId' => $batch->id,
                                'description' => $request->description,
                                'amount' => $request->amount,
                                'taxAmount' => $request->taxAmount,
                            ]);

                            //Update the Payment with the Disbursement ID
                            $record->disbursementId = $disbursement->id;
                            $record->save();


                            // *********************************************
                            // Debit (Increase) Disbursement Recovery Control Account (Type = Asset)
                            // *********************************************

                            $disbursementChildAccount = Utils::getDisbursementsControlAccount($company->disbursementsControlAccountId, $disbursement->id, $disbursement->description);

                            AccountTransaction::create([
                                'batchId' => $batch->id,
                                'type' => 'Debit',
                                'accountId' => $disbursementChildAccount->id,
                                'disbursementId' => $disbursement->id,
                                'amount' => $totalAmount
                            ]);


                        }

                    }

                    // **********************************************
                    // Credit (Decrease) Bank Account (Type = Asset)
                    // **********************************************
                    AccountTransaction::create([
                        'batchId' => $batch->id,
                        'type' => 'Credit',
                        'accountId' => $request->bankAccountId,
                        'paymentId' => $record->id,
                        'amount' => $totalAmount,
                    ]);

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


}
