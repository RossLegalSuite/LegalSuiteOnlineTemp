<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\AccountTransaction;
use Datatables;
use Illuminate\Http\Request;
//use Illuminate\Support\Facades\Validator;
//use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;

class AccountTransactionController extends Controller
{
    private function addColumns(&$query)
    {
        $query->addSelect('account_transactions.id');

        $query->addSelect('account_transactions.accountId');

        $query->addSelect('account_transactions.billId');
        $query->addSelect('account_transactions.journalId');
        $query->addSelect('account_transactions.invoiceId');
        $query->addSelect('account_transactions.receiptId');
        $query->addSelect('account_transactions.paymentId');
        $query->addSelect('account_transactions.disbursementId');

        $query->addSelect('account_transactions.type');
        $query->addSelect('account_transactions.reservedFlag');

        $query->addSelect(DB::raw("FORMAT(account_transactions.amount, 2, 'en_".session('countryCode')."') as amount"));

        $query->addSelect(DB::raw("CASE WHEN account_transactions.type='Debit' THEN FORMAT(account_transactions.amount, 2, 'en_".session('countryCode')."') ELSE NULL END AS debit"));
        $query->addSelect(DB::raw("CASE WHEN account_transactions.type='Credit' THEN FORMAT(account_transactions.amount, 2, 'en_".session('countryCode')."') ELSE NULL END AS credit"));

        $query->addSelect('batches.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(batches.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));
        $query->addSelect('batches.employeeId');
        $query->addSelect('batches.reference');
        $query->addSelect('batches.type as batchType');

        $query->addSelect('employees.name as employeeName');

        $query->addSelect(DB::raw("CONCAT(accounts.code, ' - ', accounts.description) as account"));
        $query->addSelect('accounts.id as accountId');
        $query->addSelect('accounts.description as accountDescription');
        $query->addSelect('accounts.parentId as accountParentId');
        $query->addSelect('accounts.category as accountCategory');
        $query->addSelect('accounts.type as accountType');
        $query->addSelect('parent.description as accountParentName');
    }

    public function get(Request $request)
    {
        $query = DB::table('account_transactions')
        ->join('accounts', 'accounts.id', '=', 'account_transactions.accountId')
        ->join('batches', 'batches.id', '=', 'account_transactions.batchId')
        ->join('employees', 'employees.id', '=', 'batches.employeeId')
        ->leftJoin('accounts as parent', 'parent.id', '=', 'accounts.parentId');

        $this->addColumns($query);

        if ($request->id) {
            $query->where('account_transactions.id', $request->id);
        }

        if ($request->batchId) {
            $query->where('account_transactions.batchid', $request->batchId);
        }

        if ($request->children) {
            $query
            ->whereIn('account_transactions.accountId', $request->children)
            ->orWhere('account_transactions.accountId', $request->parentId);
        } elseif ($request->parentId) {
            $query->where('account_transactions.accountId', $request->parentId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(batches.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('account', function ($query, $keyword) {
                    $sql = "CONCAT(accounts.code, ' - ', accounts.description) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('debit', function ($query, $keyword) {
                    $sql = 'account_transactions.amount like ?';
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('credit', function ($query, $keyword) {
                    $sql = 'account_transactions.amount like ?';
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
                //$query->addSelect( DB::raw("CASE WHEN account_transactions.type='Debit' THEN FORMAT(account_transactions.amount, 2, 'en_" . session('countryCode')  . "') ELSE NULL END AS debit") );
                //$query->addSelect( DB::raw("CASE WHEN account_transactions.type='Credit' THEN FORMAT(account_transactions.amount, 2, 'en_" . session('countryCode')  . "') ELSE NULL END AS credit") );
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }
}
