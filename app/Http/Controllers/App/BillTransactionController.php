<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use App\Custom\Utils;


class BillTransactionController extends Controller {

    private function addColumns(&$query, $request)
    {

        $query->addSelect('bill_transactions.id');
        $query->addSelect('bill_transactions.billId');
        $query->addSelect('bill_transactions.parentId');
        $query->addSelect('bill_transactions.date');
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(bill_transactions.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateFormatted") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(bill_transactions.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 

        $query->addSelect('bill_transactions.type');
        $query->addSelect('bill_transactions.subType');
        $query->addSelect('bill_transactions.description');

        $query->addSelect('bill_transactions.matterId');
        $query->addSelect('bill_transactions.expenseAccountId');
        $query->addSelect('bill_transactions.paymentId');

        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
        $query->addSelect(DB::raw("CONCAT(accounts.code, ' - ', accounts.description) as account"));
        $query->addSelect( DB::raw("CASE WHEN payments.id < 10000 THEN CONCAT( 'Payment: ',LPAD(payments.id,5,'0') ) ELSE CONCAT( 'Payment: ', payments.id)  END as payment") );
        
        $query->addSelect(DB::raw( "FORMAT(bill_transactions.amount, 2, 'en_" . session('countryCode')  . "') as amount") );
        $query->addSelect(DB::raw( "FORMAT(bill_transactions.taxAmount, 2, 'en_" . session('countryCode')  . "') as taxAmount") );
        $query->addSelect(DB::raw( "FORMAT(bill_transactions.totalAmount, 2, 'en_" . session('countryCode')  . "') as totalAmount") );
        
        //$query->addSelect('bill_transactions.amount as amountRaw');
        //$query->addSelect('bill_transactions.taxAmount as taxAmountRaw');
        //$query->addSelect('bill_transactions.totalAmount as totalAmountRaw');
        
        $query->addSelect( DB::raw("CASE WHEN bill_transactions.type = 'Credit' THEN -bill_transactions.amount ELSE bill_transactions.amount END as amountRaw") );
        $query->addSelect( DB::raw("CASE WHEN bill_transactions.type = 'Credit' THEN -bill_transactions.taxAmount ELSE bill_transactions.taxAmount END as taxAmountRaw") );
        $query->addSelect( DB::raw("CASE WHEN bill_transactions.type = 'Credit' THEN -bill_transactions.totalAmount ELSE bill_transactions.totalAmount END as totalAmountRaw") );
    }

    private function addTableJoins(&$query)
    {

        $query
        ->leftJoin('matters', 'matters.id', '=', 'bill_transactions.matterId')
        ->leftJoin('accounts', 'accounts.id', '=', 'bill_transactions.expenseAccountId')
        ->leftJoin('payments', 'payments.id', '=', 'bill_transactions.paymentId');

    }


    public function get(Request $request)
    {

        $query = DB::table('bill_transactions');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->parentId) {

            $query->where('bill_transactions.billId',$request->parentId);

        }    

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        
        if ($request->dataFormat === "dataTables") {

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

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }

    }




}
