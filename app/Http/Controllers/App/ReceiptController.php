<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Account;
use App\Models\AccountTransaction;
use App\Models\Batch;
use App\Models\Company;
use App\Models\Matter;
use App\Models\Party;
use App\Models\Receipt;
use App\Models\ReceiptTransaction;
use App\Rules\ValidDate;
use App\Rules\ValidNumber;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ReceiptController extends Controller
{
    private function addColumns(&$query)
    {
        $query->addSelect('receipts.id');
        $query->addSelect('receipts.createdById');

        $query->addSelect('created.id as createdEmployeeId');
        $query->addSelect('created.name as createdEmployeeName');

        $query->addSelect('receipts.clientId');
        $query->addSelect(DB::raw("CASE WHEN receipts.id < 10000 THEN LPAD(receipts.id,5,'0') ELSE receipts.id END as number"));
        $query->addSelect('receipts.method');
        $query->addSelect('receipts.reference');
        $query->addSelect('receipts.type');
        $query->addSelect('receipts.postTo');
        $query->addSelect('receipts.posted');
        $query->addSelect(DB::raw("CASE WHEN receipts.posted = 1 THEN 'Posted' ELSE 'Unposted' END as postedDescription"));

        $query->addSelect('receipts.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(receipts.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(receipts.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect('parties.id as partyId');
        $query->addSelect('parties.code as partyCode');
        $query->addSelect('parties.name as party');
        $query->addSelect('emailAddress.description as email');
        $query->addSelect('emailAddress.id as emailId');

        $query->addSelect('receipts.businessBankAccountId');
        $query->addSelect('receipts.trustBankAccountId');
        $query->addSelect('businessBankAccount.description as businessBankAccountDescription');
        $query->addSelect('trustBankAccount.description as trustBankAccountDescription');

        $query->addSelect(DB::raw("CASE 
        WHEN receipts.postTo = 'Business' THEN businessBankAccount.code 
        WHEN receipts.postTo = 'Trust' THEN trustBankAccount.code 
        ELSE null END as accountCode"));

        $query->addSelect(DB::raw("CASE 
        WHEN receipts.postTo = 'Business' THEN receipts.businessBankAccountId 
        WHEN receipts.postTo = 'Trust' THEN receipts.trustBankAccountId 
        ELSE null END as accountId"));

        $query->addSelect(DB::raw("CASE 
        WHEN receipts.postTo = 'Business' THEN businessBankAccount.description 
        WHEN receipts.postTo = 'Trust' THEN trustBankAccount.description 
        ELSE 'Unknown' END as account"));

        $query->addSelect(DB::raw('CASE WHEN receipts.posted = 1 THEN 1 ELSE 0 END as readOnly'));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT FORMAT( SUM(amount), 2, 'en_".session('countryCode')."') FROM receipt_transactions 
            WHERE receiptId = receipts.id GROUP BY receiptId), 0.00) as amount"));

        $query->addSelect(DB::raw('IFNULL( 
            (SELECT SUM(amount) FROM receipt_transactions 
            WHERE receiptId = receipts.id GROUP BY receiptId), 0.00) as amountRaw'));
    }

    public function get(Request $request)
    {
        $query = DB::table('receipts')
        ->join('parties', 'parties.id', '=', 'receipts.clientId')
        ->join('employees as created', 'created.id', '=', 'receipts.createdById')
        ->leftJoin('accounts as businessBankAccount', 'receipts.businessBankAccountId', '=', 'businessBankAccount.id')
        ->leftJoin('accounts as trustBankAccount', 'receipts.trustBankAccountId', '=', 'trustBankAccount.id')

        ->leftJoin('party_numbers as emailAddress', function ($join) {
            $join->on('parties.id', '=', 'emailAddress.partyId')
                ->whereRaw('emailAddress.id IN (select max(id) from party_numbers WHERE methodId = '.session('emailMethodId').' AND partyId = parties.id AND defaultFlag = 1 group by methodId)');
        });

        $this->addColumns($query);

        if ($request->id) {
            $query->where('receipts.id', $request->id);
        }

        if ($request->partyId) {
            $query->where('receipts.clientId', $request->partyId);
        }

        if ($request->posted) {
            $query->where('posted', 1);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        // Utils::LogSqlQuery($query);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            // Customize global search function. See: https://yajrabox.com/docs/laravel-datatables/6.0/filter-column
            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('number', function ($query, $keyword) {
                    $sql = "CASE WHEN receipts.id < 10000 THEN LPAD(receipts.id,5,'0') ELSE receipts.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(receipts.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('postedDescription', function ($query, $keyword) {
                    $sql = "CASE WHEN receipts.posted = 1 THEN 'Posted' ELSE 'Unposted' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('account', function ($query, $keyword) {
                    $sql = "CASE 
                    WHEN receipts.postTo = 'Business' THEN businessBankAccount.description 
                    WHEN receipts.postTo = 'Trust' THEN trustBankAccount.description 
                    ELSE 'Unknown' END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('amountRaw', function ($query, $keyword) {
                    $sql = "IFNULL( 
                        (SELECT FORMAT( SUM(amount), 2, 'en_".session('countryCode')."') FROM receipt_transactions 
                        WHERE receiptId = receipts.id GROUP BY receiptId), 0.00) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            } elseif ($request->tableFilter) {
                $datatables->filterColumn('accountCode', function ($query, $keyword) {
                    $sql = "CASE 
                    WHEN receipts.postTo = 'Business' THEN businessBankAccount.code 
                    WHEN receipts.postTo = 'Trust' THEN trustBankAccount.code 
                    ELSE null END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function getPostedInvoices(Request $request)
    {
        $query = DB::table('invoices')
        ->join('matters', 'matters.id', '=', 'invoices.matterId');

        $query
        ->leftJoin('matter_parties as clientParty', function ($join) {
            $join->on('matters.id', '=', 'clientParty.matterId')
                ->where('clientParty.roleId', session('clientRoleId'))
                ->where('clientParty.rank', 1);
        });

        $query->leftJoin('parties as client', 'clientParty.partyId', '=', 'client.id');

        if ($request->parentId) {
            $query->where('client.id', $request->parentId);
        }

        if ($request->matterId) {
            $query->where('invoices.matterId', $request->matterId);
        }

        // To only show Invoices with Balances
        if ($request->customTableHaving) {
            $query->havingRaw($request->customTableHaving);
        }

        $query->where('invoices.posted', 1);

        $query->orderBy('invoices.id', 'asc');

        $query->addSelect('invoices.id'); // Need this for Datatables

        $query->addSelect('invoices.id as invoiceId');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as invoiceDate"));
        $query->addSelect(DB::raw("CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END as invoiceNumber"));

        $query->addSelect('matters.id as matterId');
        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT FORMAT( SUM(amount), 2, 'en_".session('countryCode')."') FROM invoice_totals
            WHERE invoiceId = invoices.id), 0.00) as balance"));

        $query->addSelect(DB::raw('IFNULL( 
            (SELECT SUM(amount) FROM invoice_totals
            WHERE invoiceId = invoices.id), 0.00) as balanceRaw'));

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('invoiceDate', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('invoiceNumber', function ($query, $keyword) {
                    $sql = "CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('totalBalance', function ($query, $keyword) {
                    $sql = 'IFNULL( 
                    (SELECT SUM(amount) FROM invoice_totals
                    WHERE invoiceId = invoices.id ), 0.00) like ?';
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            } elseif ($request->tableFilter) {
                $datatables->filterColumn('totalBalance', function ($query, $keyword) {
                    $sql = 'IFNULL( 
                    (SELECT SUM(amount) FROM invoice_totals
                    WHERE invoiceId = invoices.id ), 0.00) like ?';
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function getAllocatedInvoices(Request $request)
    {
        $query = DB::table('receipt_transactions')
        ->join('receipts', 'receipts.id', '=', 'receipt_transactions.receiptId')
        ->join('invoices', 'invoices.id', '=', 'receipt_transactions.invoiceId')
        ->join('matters', 'matters.id', '=', 'invoices.matterId');

        if ($request->parentId) {
            $query->where('receipt_transactions.receiptId', $request->parentId);
        }

        if ($request->matterId) {
            $query->where('matters.id', $request->matterId);
        }

        $query->orderBy('invoices.id', 'asc');

        $query->addSelect('receipt_transactions.amount');

        $query->addSelect(DB::raw('CASE WHEN receipts.posted = 1 THEN 1 ELSE 0 END as readOnly'));

        $query->addSelect(DB::raw("CASE WHEN receipts.id < 10000 THEN LPAD(receipts.id,5,'0') ELSE receipts.id  END as receiptNumber"));
        $query->addSelect('receipts.id as receiptId');
        $query->addSelect('receipts.method as receiptMethod');
        $query->addSelect('receipts.reference as receiptReference');
        $query->addSelect('receipts.type as receiptType');
        $query->addSelect('receipts.posted as receiptPosted');

        $query->addSelect('invoices.id as invoiceId');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as invoiceDate"));
        $query->addSelect(DB::raw("CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END as invoiceNumber"));

        $query->addSelect('matters.id as matterId');
        $query->addSelect('matters.fileRef as matterFileRef');
        $query->addSelect('matters.description as matterDescription');

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('invoiceDate', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('invoiceNumber', function ($query, $keyword) {
                    $sql = "CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function getAllocatedMatters(Request $request)
    {
        $query = DB::table('receipt_transactions')
        ->join('matters', 'matters.id', '=', 'receipt_transactions.matterId')
        ->where('receipt_transactions.receiptId', $request->parentId)
        ->orderBy('matters.fileRef', 'asc');

        $query->addSelect('receipt_transactions.*');

        $query->addSelect('matters.fileRef as matterFileRef');
        $query->addSelect('matters.description as matterDescription');

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'createdById' => 'required',
            'clientId' => 'required',
            'method' => 'required',
            'type' => 'required',
            'dateTime' => new ValidDate,
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            return DB::transaction(function () use ($request) {
                $record = (isset($request->id)) ? Receipt::findOrFail($request->id) : new Receipt;

                $record->clientId = $request->clientId;
                $record->createdById = $request->createdById;
                $record->date = Utils::convertDateTime($request->dateTime);
                $record->method = $request->method;
                $record->type = $request->type;
                $record->reference = $request->reference;
                $record->postTo = $request->postTo;
                $record->posted = $request->posted;
                $record->businessBankAccountId = $request->businessBankAccountId;
                $record->trustBankAccountId = $request->trustBankAccountId;

                $record->save();

                if (isset($request->posted) && $request->posted == 1) {
                    $company = Company::first();
                    $amount = 0;

                    foreach (json_decode($request->allocatedInvoices) as $allocatedInvoice) {
                        ReceiptTransaction::create([
                            'receiptId' => $request->id,
                            'invoiceId' => $allocatedInvoice->invoiceId,
                            'matterId' => $allocatedInvoice->matterId,
                            'amount' => $allocatedInvoice->amount,
                        ]);

                        $amount += $allocatedInvoice->amount;
                    }

                    foreach (json_decode($request->allocatedMatters) as $allocatedMatter) {
                        ReceiptTransaction::create([
                            'receiptId' => $request->id,
                            'matterId' => $allocatedMatter->matterId,
                            'amount' => $allocatedMatter->amount,
                        ]);

                        $amount += $allocatedMatter->amount;
                    }

                    $batch = Batch::create([
                        'date' => date('Y-m-d H:i:s'),
                        'employeeId' => session('employeeId'),
                        'type' => 'Receipt',
                        'reference' => 'Receipt: '.Utils::padNumber($record->id),
                    ]);

                    // **********************************************
                    // Debit Bank Account (Type = Asset)
                    // **********************************************
                    AccountTransaction::create([
                        'batchId' => $batch->id,
                        'type' => 'Debit',
                        'accountId' => $record->postTo == 'Trust' ? $request->trustBankAccountId : $request->businessBankAccountId,
                        'receiptId' => $record->id,
                        'amount' => $amount,
                    ]);

                    if ($record->type == 'Payment') {
                        foreach (json_decode($request->allocatedInvoices) as $allocatedInvoice) {
                            AccountTransaction::create([
                                'batchId' => $batch->id,
                                'type' => 'Credit',
                                'accountId' => $company->debtorsControlAccountId,
                                'receiptId' => $record->id,
                                'invoiceId' => $allocatedInvoice->invoiceId,
                                'amount' => $allocatedInvoice->amount,
                            ]);
                        }
                    } elseif ($record->type == 'Retainer' || $record->type == 'Deposit') {
                        $trustControlAccount = Account::findOrFail($company->trustControlAccountId);

                        foreach (json_decode($request->allocatedMatters) as $allocatedMatter) {
                            $this->creditMatterTrustAccount($company, $trustControlAccount, $batch->id, $record->id, $allocatedMatter->matterId, $allocatedMatter->amount, null, 1);
                        }
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

    protected function creditMatterTrustAccount($company, $trustControlAccount, $batchId, $id, $matterId, $amount, $invoiceId = null, $reservedFlag = 0)
    {
        $mattertrustAccount = Account::where('matterId', $matterId)->where('parentId', $trustControlAccount->id)->first();

        if (! $mattertrustAccount) {
            $matter = Matter::findOrFail($matterId);

            $mattertrustAccount = Account::create([
                'code' => $trustControlAccount->code.'-'.$matterId,
                'description' => 'Trust Account ('.$matter->fileRef.')',
                'category' => 'Liabilities',
                'type' => 'Current Liability',
                'matterId' => $matterId,
                'parentId' => $trustControlAccount->id,
                'taxRateId' => $company->noTaxRateId,
            ]);
        }

        // **********************************************
        // Credit Matter Trust Account (Type = Liability)
        // **********************************************
        AccountTransaction::create([
            'batchId' => $batchId,
            'type' => 'Credit',
            'accountId' => $mattertrustAccount->id,
            'receiptId' => $id,
            'invoiceId' => $invoiceId,
            'reservedFlag' => $reservedFlag,
            'amount' => $amount,
        ]);
    }
}
