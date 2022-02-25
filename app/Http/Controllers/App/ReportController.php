<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Report;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ReportController extends Controller
{
    public function get(Request $request)
    {
        $query = DB::table('reports')
        ->join('employees', 'employees.id', '=', 'reports.employeeId')
        ->leftJoin('employee_groups', 'reports.employeeGroupId', '=', 'employee_groups.id');

        $query->addSelect('reports.*');

        $query->addSelect('employee_groups.description as employeeGroupDescription');

        if ($request->id) {
            $query->where('reports.id', $request->id);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required',
            'employeeId' => 'required',
            'source' => 'required',
            'contents' => 'required',
        ];

        $rules['title'] = isset($request->id) ? ['required', Rule::unique('reports')->ignore($request->id)] : ['required', Rule::unique('reports')];

        $messages = [
            'title.unique' => 'A Report with this title already exists.',
            'contents.required' => 'Please add some content to the Report',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? Report::findOrFail($request->id) : new Report;

            $record->title = $request->title;
            $record->description = $request->description;
            $record->source = $request->source;
            $record->employeeId = $request->employeeId;
            $record->employeeGroupId = $request->employeeGroupId;
            $record->contents = $request->contents;

            $record->save();

            return json_encode($record);
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

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, Report::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('reports')
        ->where('title', '<', $request->title)
        ->orderBy('title')
        ->count();
    }

    public function get_Old(Request $request)
    {
        $columns = 'reports.*';

        $query = DB::table('reports')
        ->selectRaw($columns)
        ->orderBy('title', 'asc');

        if ($request->id) {
            $query->where('reports.id', $request->id);
        }

        if ($request->whereClause) {
            $query->whereRaw($request->whereClause);
        }

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store_Old(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'bail|required',
        ];

        $rules['title'] = isset($request->id) ? ['required', Rule::unique('reports')->ignore($request->id)] : ['required', Rule::unique('reports')];
        $rules['component'] = isset($request->id) ? ['required', Rule::unique('reports')->ignore($request->id)] : ['required', Rule::unique('reports')];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? Report::findOrFail($request->id) : new Report;

            $record->title = $request->title;
            $record->description = $request->description;
            $record->component = $request->component;
            $record->heading = $request->heading;
            $record->subHeading = $request->subHeading;
            $record->employeeId = $request->employeeId;
            $record->matterId = $request->matterId;
            $record->partyId = $request->partyId;
            $record->startDate = $request->startDate;
            $record->endDate = $request->endDate;
            $record->fromAmount = $request->fromAmount;
            $record->toAmount = $request->toAmount;
            $record->period = $request->period;

            $record->save();

            return json_encode($record);
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

    public function incomeStatement(Request $request)
    {
        $query = DB::table('ledger_view');

        $query->leftJoin('accounts', 'ledger_view.id', '=', 'accounts.id');

        $query->addSelect('accounts.*');
        $query->addSelect('ledger_view.balance');

        $query->whereIn('accounts.category', ['Revenue', 'Expenses']);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function balanceSheet(Request $request)
    {
        $query = DB::table('ledger_view');

        $query->leftJoin('accounts', 'ledger_view.id', '=', 'accounts.id');

        $query->addSelect('accounts.*');
        $query->addSelect('ledger_view.balance');

        $query->whereIn('accounts.category', ['Assets', 'Liabilities', 'Equity']);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function trialBalance(Request $request)
    {
        $query = DB::table('ledger_view');

        $query->leftJoin('accounts', 'ledger_view.id', '=', 'accounts.id');

        $query->addSelect('accounts.*');
        $query->addSelect('ledger_view.debits');
        $query->addSelect('ledger_view.credits');

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    /*
        public function trialBalance_Cursor(Request $request)
        {

            $accounts = array();

            $parentAccounts = Account::distinct()->whereNotNull( 'parentId' )->pluck('parentId')->toArray();

            $columns = "accounts.*";

            $columns .= ",COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount END),0) AS debits";
            $columns .= ",COALESCE(SUM(CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount END),0) AS credits";

            // Do the top level accounts
            foreach (Account::selectRaw($columns)
                    ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
                    ->whereNull( 'accounts.parentId' )
                    ->whereNotIn('accounts.id', $parentAccounts)
                    ->groupBy('accounts.id')
                    ->cursor() as $account) {

                array_push($accounts,$account);

            }

            // Do the accounts that have a parentId
            foreach (Account::selectRaw($columns)
                    ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
                    ->whereIn('accounts.id', $parentAccounts)
                    ->groupBy('accounts.id')
                    ->cursor() as $account) {

                    // Do this sub account
                    foreach (Account::selectRaw($columns)
                            ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
                            ->where('parentId', $account->id)
                            ->groupBy('accounts.id')
                            ->cursor() as $subAccount) {

                        $account->debits += $subAccount->debits;
                        $account->credits += $subAccount->credits;

                    }

                // Populate return data as string to keep it consistent
                $account->debits = strval($account->debits);
                $account->credits = strval($account->credits);

                array_push($accounts,$account);

            }

            return json_encode($accounts);

        }

        public function trialBalanceWorking(Request $request)
        {

            $accounts = array();

            $parentAccounts = Account::distinct()->whereNotNull( 'parentId' )->pluck('parentId')->toArray();

            $columns = "accounts.*";

            $columns .= ",COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount END),0) AS debits";
            $columns .= ",COALESCE(SUM(CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount END),0) AS credits";

            foreach (Account::selectRaw($columns)
                    ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
                    ->whereNull( 'accounts.parentId' )
                    ->whereNotIn('accounts.id', $parentAccounts)
                    ->groupBy('accounts.id')
                    ->cursor() as $account) {

                array_push($accounts,$account);

            }

            foreach (Account::selectRaw($columns)
                    ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
                    ->whereIn('accounts.id', $parentAccounts)
                    ->groupBy('accounts.id')
                    ->cursor() as $account) {

                foreach (Account::selectRaw($columns)
                        ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
                        ->where('parentId', $account->id)
                        ->groupBy('accounts.id')
                        ->cursor() as $subAccount) {

                    $account->debits += $subAccount->debits;
                    $account->credits += $subAccount->credits;

                }

                array_push($accounts,$account);

            }

            return json_encode($accounts);

        }

        public function trialBalanceOld(Request $request)
        {

            $columns = "accounts.*";

            $columns .= ",COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount END),0) AS debits";
            $columns .= ",COALESCE(SUM(CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount END),0) AS credits";

            $query = DB::table('accounts')
            ->selectRaw($columns)
            ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
            //->orderBy('accounts.code', 'asc')
            ->groupBy('accounts.id');

            if ($request->whereClause) {
                $query->whereRaw($request->whereClause);
            }

            //Utils::LogSqlQuery($query);

            return DataTablesHelper::ReturnData($query, $request);

        }
    */
}
