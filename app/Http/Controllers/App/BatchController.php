<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Batch;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BatchController extends Controller
{
    private function addColumns(&$query)
    {
        $format1 = 'FORMAT( ';
        $format2 = ", 2, 'en_".session('countryCode')."')";

        $query->addSelect('batches.id');
        $query->addSelect('batches.employeeId');
        $query->addSelect('batches.type');
        $query->addSelect('batches.reference');
        $query->addSelect('batches.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(batches.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(batches.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

        $query->addSelect(DB::raw("CASE WHEN batches.id < 10000 THEN LPAD(batches.id,5,'0') ELSE batches.id END as number"));

        $query->addSelect('employees.name as employeeName');

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(account_transactions.amount){$format2} FROM account_transactions
            WHERE account_transactions.batchId = batches.id AND account_transactions.type = 'Debit'
            GROUP BY account_transactions.batchId), 0.00) as debits"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(account_transactions.amount){$format2} FROM account_transactions
            WHERE account_transactions.batchId = batches.id AND account_transactions.type = 'Credit'
            GROUP BY account_transactions.batchId), 0.00) as credits"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(CASE WHEN account_transactions.type = 'Credit' THEN -account_transactions.amount ELSE account_transactions.amount END){$format2} FROM account_transactions
            WHERE account_transactions.batchId = batches.id 
            GROUP BY account_transactions.batchId), 0.00) as balance"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT SUM(account_transactions.amount) FROM account_transactions
            WHERE account_transactions.batchId = batches.id AND account_transactions.type = 'Debit'
            GROUP BY account_transactions.batchId), 0.00) as debitsRaw"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT SUM(account_transactions.amount) FROM account_transactions
            WHERE account_transactions.batchId = batches.id AND account_transactions.type = 'Credit'
            GROUP BY account_transactions.batchId), 0.00) as creditsRaw"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT SUM(CASE WHEN account_transactions.type = 'Credit' THEN -account_transactions.amount ELSE account_transactions.amount END) FROM account_transactions
            WHERE account_transactions.batchId = batches.id 
            GROUP BY account_transactions.batchId), 0.00) as balanceRaw"));
    }

    public function get(Request $request)
    {
        $query = DB::table('batches')
        ->join('employees', 'employees.id', '=', 'batches.employeeId');

        $this->addColumns($query);

        if ($request->id) {
            $query->where('batches.id', $request->id);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(batches.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('number', function ($query, $keyword) {
                    $sql = "CASE WHEN batches.id < 10000 THEN LPAD(batches.id,5,'0') ELSE batches.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }
}
