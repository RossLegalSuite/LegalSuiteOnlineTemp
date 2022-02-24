<?php

namespace App\Http\Controllers\App;

use App\Models\Payment;
use App\Models\Disbursement;
use App\Models\Company;
use App\Models\Batch;
use App\Models\AccountTransaction;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidDate;
use App\Rules\ValidNumber;
use App\Custom\Utils;

use Maatwebsite\Excel\Facades\Excel;
use Maatwebsite\Excel\Concerns\{FromQuery, Exportable, WithHeadings, WithEvents, RegistersEventListeners, ShouldAutoSize};
use Maatwebsite\Excel\Events\{BeforeExport, AfterSheet};
use PhpOffice\PhpSpreadsheet\Style\{NumberFormat, Alignment};


class DisbursementController extends Controller {

    private function addColumns(&$query, $request)
    {

        $query->addSelect('disbursements.id');
        $query->addSelect('disbursements.date');
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(disbursements.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateFormatted") ); 
        $query->addSelect('created.name as createdEmployeeName');

        $query->addSelect('disbursements.description');
        $query->addSelect('matters.fileRef as matterFileRef');
        
        $query->addSelect( DB::raw("CASE WHEN batches.id < 10000 THEN LPAD(batches.id,5,'0') ELSE batches.id END as batchNumber") );
        $query->addSelect( DB::raw("CASE WHEN payments.id < 10000 THEN LPAD(payments.id,5,'0') ELSE payments.id END as paymentNumber") );
        $query->addSelect( DB::raw("CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id  END as invoiceNumber") );

        if ( $request->dataFormat === 'export' ) {

            $query->orderBy('disbursements.date');

            $query->addSelect('disbursements.taxAmount');
            $query->addSelect('disbursements.amount');
            $query->addSelect('disbursements.totalAmount');
            
        } else {

            if ($request->dataFormat === "dataTables") {
                $query->addSelect(DB::raw( "FORMAT(disbursements.amount, 2, 'en_" . session('countryCode')  . "') as amount") );
                $query->addSelect(DB::raw( "FORMAT(disbursements.taxAmount, 2, 'en_" . session('countryCode')  . "') as taxAmount") );
                $query->addSelect(DB::raw( "FORMAT(disbursements.totalAmount, 2, 'en_" . session('countryCode')  . "') as totalAmount") );
            } else {
                $query->addSelect('disbursements.amount');
                $query->addSelect('disbursements.taxAmount');
                $query->addSelect('disbursements.totalAmount');
            }
                    
            $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(disbursements.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 
            
            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.id as matterId');
            $query->addSelect('matters.description as matterDescription');
            
            $query->addSelect('disbursements.taxRateId');

            $query->addSelect('invoices.posted as invoicePosted');
            
            $query->addSelect('disbursements.createdById');
            $query->addSelect('created.id as createdEmployeeId');
            $query->addSelect('disbursements.method');

            //$query->addSelect('disbursements.creditorId');
            //$query->addSelect('creditors.name as creditorName');
            $query->addSelect('disbursements.bankAccountId');
            $query->addSelect('accounts.description as bankAccount');

            $query->addSelect('disbursements.batchId');
            $query->addSelect('disbursements.paymentId');
            $query->addSelect('disbursements.invoiceId');

            $query->addSelect(DB::raw('CASE WHEN ISNULL(disbursements.invoiceId) THEN 0 ELSE 1 END as invoiced'));
            $query->addSelect(DB::raw('CASE WHEN ISNULL(disbursements.batchId) THEN 0 ELSE 1 END as batched'));
            $query->addSelect(DB::raw('CASE WHEN ISNULL(disbursements.paymentId) THEN 0 ELSE 1 END as paid'));

            $query->addSelect(DB::raw('CASE WHEN !ISNULL(disbursements.invoiceId) OR !ISNULL(disbursements.paymentId)  OR !ISNULL(disbursements.batchId) THEN 1 ELSE 0 END as readOnly'));
        }

    }

    private function addTableJoins(&$query)
    {
        $query
        ->join('matters', 'matters.id', '=', 'disbursements.matterId')
        ->join('employees as created', 'created.id', '=', 'disbursements.createdById')
        ->leftJoin('invoices', 'invoices.id', '=', 'disbursements.invoiceId')
        ->leftJoin('batches', 'batches.id', '=', 'disbursements.batchId')
        ->leftJoin('payments', 'payments.id', '=', 'disbursements.paymentId')
        //->leftJoin('creditors', 'creditors.id', '=', 'disbursements.creditorId')
        ->leftJoin('accounts', 'accounts.id', '=', 'disbursements.bankAccountId');
    }

    public function get(Request $request)
    {
        $query = DB::table('disbursements');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->paid) $query->whereNotNull('disbursements.batchId');
        if ($request->invoiced) $query->where('invoices.posted',1);

        if ($request->id) {

            $query->where('disbursements.id',$request->id);

        } else if ($request->matterId) {

            $query->where('disbursements.matterId',$request->matterId);

        } else if ($request->employeeId) {

            $query->where('disbursements.createdById',$request->employeeId);

        } else if ($request->createdById) {

            $query->where('disbursements.createdById',$request->createdById);

        } else if ($request->batchId) {

            $query->where('disbursements.batchId',$request->batchId);

        } else if ($request->invoiceId) {

            $query->where('disbursements.invoiceId',$request->invoiceId);

        }    

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        
        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value'] ) {

                $datatables->filterColumn('date', function($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(disbursements.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('batchNumber', function($query, $keyword) {
                    $sql = "CASE WHEN batches.id < 10000 THEN LPAD(batches.id,5,'0') ELSE batches.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('invoiceNumber', function($query, $keyword) {
                    $sql = "CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('matter', function($query, $keyword) {
                    $sql = "CONCAT(matters.fileRef, ' - ', matters.description) like ?";
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

        // See: https://help.kashoo.com/en/articles/370374-kashoo-classic-recording-reimbursable-expenses

        $returnData = new \stdClass();

        $rules = [
            'matterId' => 'required',
            'bankAccountId' => 'required',
            'description' => 'required',
            'method' => 'required',
            'amount' => new ValidNumber,
            'dateTime' => new ValidDate,
        ];

        $messages = [];

        $messages['method.required'] = 'Please select a Payment method';
        $messages['matterId.required'] = 'Please select a Matter';
        $messages['bankAccountId.required'] = 'Please select a Bank Account';

        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            
        }        

        try {

            // Note: This code is repeated in FeeCodeController
            return DB::transaction( function() use ($request)
            {

                $company = Company::first();

                $batch = Batch::create([
                    'date' => date("Y-m-d H:i:s"),
                    'employeeId' => session('employeeId'),
                    'type' => 'Payment',
                    'reference' => $request->description,
                ]);

                $payment = Payment::create([                
                    'createdById' => $request->createdById,
                    'date' => Utils::convertDateTime($request->dateTime),
                    'method' => $request->method,
                    'reference' => $request->reference,
                    'type' => 'Disbursement',
                    'posted' => 1,
                    'bankAccountId' => $request->bankAccountId,
                    'matterId' => $request->matterId,
                    'description' => $request->description,
                    'taxRateId' => $request->taxRateId,
                    'amount' => $request->amount,
                    'taxAmount' => $request->taxAmount,
                ]);


                $disbursement = Disbursement::create([
                    'date' => Utils::convertDateTime($request->dateTime),
                    'matterId' => $request->matterId,
                    'createdById' => $request->createdById,
                    'bankAccountId' => $request->bankAccountId,
                    'batchId' => $batch->id,
                    'paymentId' => $payment->id,
                    'taxRateId' => $request->taxRateId,
                    'description' => $request->description,
                    'amount' => $request->amount,
                    'taxAmount' => $request->taxAmount,
                ]);

                // **********************************************
                // Credit (Decrease) Bank Account (Type = Asset)
                // **********************************************
                AccountTransaction::create([
                    'batchId' => $batch->id,
                    'type' => 'Credit',
                    'accountId' => $request->bankAccountId,
                    'paymentId' => $payment->id,
                    'amount' => $request->amount + $request->taxAmount
                ]);

                // *********************************************
                // Debit (Increase) Disbursement Recovery Control Account (Type = Asset)
                // *********************************************

                $disbursementChildAccount = Utils::getDisbursementsControlAccount($company->disbursementsControlAccountId, $disbursement->id, $disbursement->description);

                AccountTransaction::create([
                    'batchId' => $batch->id,
                    'type' => 'Debit',
                    'accountId' => $disbursementChildAccount->id,
                    'paymentId' => $payment->id,
                    'amount' => $request->amount + $request->taxAmount
                ]);

                return json_encode($disbursement);

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

    public function allocateToInvoice(Request $request)
    {
        Disbursement::where('id', $request->id)->update(array('invoiceId' => $request->invoiceId));
    }

    public function allocateInvoiceDisbursements(Request $request)
    {
        $returnData = new \stdClass();

        try {
        
            $returnData->result = DB::table('disbursements');

            if ( isset($request->ids) ) {

                $returnData->result->whereIn('id', $request->ids);

            } else {
                
                $returnData->result->where('matterId', $request->matterId);

            }

            $returnData->result->update(['invoiceId' => $request->invoiceId]);

            return json_encode($returnData);

        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);            

        }        
    }

    public function unallocateInvoiceDisbursement(Request $request)
    {
        $returnData = new \stdClass();

        try {
        
            $returnData->result = DB::table('disbursements')
            ->where('id', $request->id)
            ->update(['invoiceId' => null]);

            return json_encode($returnData);

        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);            

        }        
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, Disbursement::class);
    }

    public function getTablePosition(Request $request)
    {

        return DB::table('disbursements')
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
                    "Type",
                    "Description",
                    "Matter",
                    "Invoice No",
                    "Batch No",
                    "Net Amount",
                    "Tax",
                    "Amount",
                ];
            }

            public function registerEvents(): array
            {

                return [
                    AfterSheet::class => function(AfterSheet $event) {

                        $event->sheet->styleCells(
                            'A8:A10',
                            [
                                'alignment' => [
                                    'horizontal' => Alignment::HORIZONTAL_RIGHT,
                                ],
                            ]
                        );
                    },

                    BeforeExport::class => function(BeforeExport $event) {

                        $event->writer->getProperties()->setTitle('Disbursements');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },

                ];
            }

            public function query() { return $this->query; }

        },'disbursements.xlsx');

    }

}
