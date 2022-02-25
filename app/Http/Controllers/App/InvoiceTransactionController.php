<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InvoiceTransactionController extends Controller
{
    private function addColumns(&$query, $request)
    {
        $query->addSelect('invoice_transactions.id');
        $query->addSelect('invoice_transactions.invoiceId');
        $query->addSelect('invoice_transactions.matterId');
        $query->addSelect('invoice_transactions.receiptId');
        $query->addSelect('invoice_transactions.parentId');
        $query->addSelect('invoice_transactions.date');

        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoice_transactions.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(invoice_transactions.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect('invoice_transactions.type');
        $query->addSelect('invoice_transactions.subType');
        $query->addSelect('invoice_transactions.description');

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));

        $query->addSelect(DB::raw("CASE WHEN invoice_transactions.invoiceId < 10000 THEN CONCAT( 'Invoice: ',LPAD(invoice_transactions.invoiceId,5,'0') ) ELSE CONCAT( 'Invoice: ', invoice_transactions.invoiceId)  END as invoice"));

        $query->addSelect(DB::raw("FORMAT(invoice_transactions.amount, 2, 'en_".session('countryCode')."') as amount"));
        $query->addSelect(DB::raw("FORMAT(invoice_transactions.taxAmount, 2, 'en_".session('countryCode')."') as taxAmount"));
        $query->addSelect(DB::raw("FORMAT(invoice_transactions.totalAmount, 2, 'en_".session('countryCode')."') as totalAmount"));

        $query->addSelect(DB::raw("CASE WHEN invoice_transactions.type = 'Credit' THEN -invoice_transactions.amount ELSE invoice_transactions.amount END as amountRaw"));
        $query->addSelect(DB::raw("CASE WHEN invoice_transactions.type = 'Credit' THEN -invoice_transactions.taxAmount ELSE invoice_transactions.taxAmount END as taxAmountRaw"));
        $query->addSelect(DB::raw("CASE WHEN invoice_transactions.type = 'Credit' THEN -invoice_transactions.totalAmount ELSE invoice_transactions.totalAmount END as totalAmountRaw"));
    }

    private function addTableJoins(&$query)
    {
        $query
        ->leftJoin('matters', 'matters.id', '=', 'invoice_transactions.matterId');
    }

    public function get(Request $request)
    {
        $query = DB::table('invoice_transactions');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->parentId) {
            $query->where('invoice_transactions.invoiceId', $request->parentId);
        }
        if ($request->type) {
            $query->where('invoice_transactions.type', $request->type);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            // if ($keyword = $request->get('search')['value'] ) {

            //     $datatables->filterColumn('billNumber', function($query, $keyword) {
            //         $sql = "CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END like ?";
            //         $query->whereRaw($sql, ["%{$keyword}%"]);
            //     })

            //     ->filterColumn('account', function($query, $keyword) {
            //         $sql = "CONCAT(accounts.code, ' - ', accounts.description) OR CONCAT(matters.fileRef, ' - ', matters.description) like ?";
            //         $query->whereRaw($sql, ["%{$keyword}%"]);
            //     });

            // }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }
}
