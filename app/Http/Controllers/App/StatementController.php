<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StatementController extends Controller
{
    public function get(Request $request)
    {
        $query = DB::table('matter_business_balances');

        $query->addSelect(DB::raw("CONCAT(clientCode, ' - ', clientName) as client"));

        // Need this for the Datatables
        $query->addSelect('clientCode');
        $query->addSelect('matter_business_balances.clientId as id');

        $query->addSelect('matter_business_balances.clientId');

        $query->addSelect(DB::raw("FORMAT( SUM(debits), 2, 'en_".session('countryCode')."') AS debits"));
        $query->addSelect(DB::raw("FORMAT( SUM(credits), 2, 'en_".session('countryCode')."') AS credits"));
        $query->addSelect(DB::raw("FORMAT( SUM(debits - credits), 2, 'en_".session('countryCode')."') AS balance"));
        $query->addSelect(DB::raw('SUM(debits - credits) AS balanceRaw'));

        if ($request->id) {
            $query->where('matter_business_balances.clientId', $request->id);
        }

        $query->groupBy('matter_business_balances.clientId');

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        $datatables = Datatables::of($query);

        if ($keyword = $request->get('search')['value']) {
            $datatables->filterColumn('clientCode', function ($query, $keyword) {
                $sql = "CONCAT(clientCode, ' - ', clientName)
                like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            });
        }

        return $datatables->make(true);
    }

    private function addInvoiceColumns(&$query)
    {
        $query->addSelect('invoices.id');

        $query->addSelect('invoices.id as transactionId'); // Need this to loop transactions in the System Template v-for

        $query->addSelect(DB::raw("CASE WHEN invoices.id < 10000 THEN CONCAT('Invoice ', CONVERT(LPAD(invoices.id,5,'0'),char) ) ELSE CONCAT('Invoice ', CONVERT(invoices.id, char) ) END as document"));

        $query->addSelect(DB::raw("'Invoice' as type"));

        $query->addSelect('invoices.matterId');
        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        $query->addSelect('invoices.posted');

        $query->addSelect('invoices.date');

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT FORMAT( SUM(fee_notes.amount + fee_notes.taxAmount), 2, 'en_".session('countryCode')."') FROM fee_notes
            WHERE fee_notes.invoiceId = invoices.id
            GROUP BY fee_notes.invoiceId), 0.00) as debit"));

        $query->addSelect(DB::raw('null as credit'));

        $query->addSelect(DB::raw('0 as balance'));
    }

    private function addReceiptColumns(&$query)
    {
        $query->addSelect('receipts.id');

        // Need this to loop transactions in the System Template v-for
        $query->addSelect(DB::raw("CONCAT('receipt-', CONVERT(receipts.id, char),'-invoice-', CONVERT(invoices.id, char)) as transactionId"));

        $query->addSelect(DB::raw("CASE WHEN receipts.id < 10000 THEN CONCAT('Receipt ', CONVERT(LPAD(receipts.id,5,'0'),char) ) ELSE CONCAT('Receipt ', CONVERT(receipts.id, char) ) END as document"));

        $query->addSelect(DB::raw("'Receipt' as type"));

        $query->addSelect('invoices.matterId');
        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        $query->addSelect('receipts.posted');

        $query->addSelect('receipts.date');

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(receipts.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(receipts.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect(DB::raw('null as debit'));

        $query->addSelect(DB::raw("FORMAT(-receipt_transactions.amount, 2, 'en_".session('countryCode')."') as credit"));

        $query->addSelect(DB::raw('0 as balance'));
    }

    public function getPartyTransactions(Request $request)
    {
        $invoiceQuery = DB::table('invoices');
        $invoiceQuery->join('matters', 'matters.id', '=', 'invoices.matterId');

        $invoiceQuery->rightJoin('matter_parties as clientParty', function ($join) use ($request) {
            $join->on('invoices.matterId', '=', 'clientParty.matterId')
                ->where('clientParty.partyId', $request->parentId)
                ->where('clientParty.roleId', session('clientRoleId'))
                ->where('clientParty.rank', 1);
        });

        $invoiceQuery->where('posted', 1);

        $this->addInvoiceColumns($invoiceQuery);

        $query = DB::table('receipt_transactions');
        $query->join('receipts', 'receipts.id', '=', 'receipt_transactions.receiptId');
        $query->join('invoices', 'invoices.id', '=', 'receipt_transactions.invoiceId');
        $query->join('matters', 'matters.id', '=', 'invoices.matterId');

        $query->rightJoin('matter_parties as clientParty', function ($join) use ($request) {
            $join->on('invoices.matterId', '=', 'clientParty.matterId')
            ->where('clientParty.partyId', $request->parentId)
            ->where('clientParty.roleId', session('clientRoleId'))
            ->where('clientParty.rank', 1);
        });

        $query->where('receipts.posted', 1);
        $query->where('invoices.posted', 1);

        $query->union($invoiceQuery);

        $this->addReceiptColumns($query);

        $datatables = Datatables::of($query);

        if ($keyword = $request->get('search')['value']) {
            $datatables->filterColumn('dateTime', function ($query, $keyword) {
                $sql = "DATE_FORMAT( CONVERT_TZ(invoices.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') 
                OR DATE_FORMAT( CONVERT_TZ(receipts.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."')
                like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            })
            ->filterColumn('document', function ($query, $keyword) {
                $sql = "CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END 
                OR CASE WHEN receipts.id < 10000 THEN LPAD(receipts.id,5,'0') ELSE receipts.id END
                like ?";
                $query->whereRaw($sql, ["%{$keyword}%"]);
            });
        }

        return $datatables->make(true);

        //return DataTablesHelper::ReturnData($query, $request);
    }

    public function getMatterTransactions(Request $request)
    {
        $invoices = DB::table('invoices')
        ->join('matters', 'matters.id', '=', 'invoices.matterId')
        ->where('matters.id', $request->matterId)
        ->where('posted', 1);

        $this->addInvoiceColumns($invoices);

        $receipts = DB::table('receipt_transactions')
        ->join('receipts', 'receipts.id', '=', 'receipt_transactions.receiptId')
        ->join('invoices', 'invoices.id', '=', 'receipt_transactions.invoiceId')
        ->join('matters', 'matters.id', '=', 'invoices.matterId')
        ->where('matters.id', $request->matterId)
        ->where('receipts.posted', 1)
        ->where('invoices.posted', 1)
        ->union($invoices)
        ->orderBy('dateTime', 'asc');

        $this->addReceiptColumns($receipts);

        return $receipts->get()->toJson();
    }
}
