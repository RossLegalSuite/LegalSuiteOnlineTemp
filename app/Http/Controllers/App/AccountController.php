<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Account;
use App\Models\AccountTransaction;
use App\Models\Batch;
use App\Rules\ValidDate;
use App\Rules\ValidNumber;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class AccountController extends Controller
{
    private function addColumns(&$query)
    {
        $query->addSelect('accounts.id');
        $query->addSelect('accounts.code');
        $query->addSelect('accounts.systemFlag');
        $query->addSelect('accounts.description');
        $query->addSelect('accounts.notes');
        $query->addSelect('accounts.category');
        $query->addSelect('accounts.type');

        $query->addSelect('accounts.matterId');
        $query->addSelect('accounts.creditorId');

        // $query->addSelect("accounts.invoiceId");
        // $query->addSelect("accounts.receiptId");
        // $query->addSelect("accounts.paymentId");
        // $query->addSelect("accounts.disbursementId");

        $query->addSelect('accounts.parentId');
        $query->addSelect('accounts.taxRateId');

        $query->addSelect('accounts.bankAccountInstitution');
        $query->addSelect('accounts.bankAccountName');
        $query->addSelect('accounts.bankAccountNumber');
        $query->addSelect('accounts.bankAccountBranch');
        $query->addSelect('accounts.bankAccountCode');

        $query->addSelect('tax_rates.description as taxRateDescription');

        $query->addSelect(DB::raw("CONCAT(accounts.code, ' - ', accounts.description) as account"));

        $query->addSelect(DB::raw("CASE WHEN accounts.systemFlag = 1 
        OR COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount END),0) > 0
        OR COALESCE(SUM(CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount END),0) > 0
        THEN 1 ELSE 0 END as noEdit"));

        $this->addTransactionsColumns($query);
    }

    private function addTransactionsColumns(&$query)
    {
        $query->addSelect(DB::raw("COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount END),0) AS debits"));
        $query->addSelect(DB::raw("COALESCE(SUM(CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount END),0) AS credits"));
        $query->addSelect(DB::raw("COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount WHEN account_transactions.type='Credit' THEN -account_transactions.amount END),0) AS balance"));
    }

    private function addJoins(&$query)
    {
        $query->join('tax_rates', 'tax_rates.id', '=', 'accounts.taxRateId')
        ->leftJoin('account_transactions', 'account_transactions.accountId', '=', 'accounts.id')
        ->groupBy('accounts.id');
    }

    public function get(Request $request)
    {
        $query = DB::table('accounts');
        $this->addColumns($query);
        $this->addJoins($query);

        if ($request->id) {
            $query->where('accounts.id', $request->id);

            $account = $query->first();

            $account->children = Account::distinct()->where('parentId', $account->id)->pluck('id')->toArray();

            if (! empty($account->children)) {
                $account->noEdit = 1;
            }

            $account->parent = $account->parentId ? Account::where('id', $account->parentId)->first() : [];

            return  $request->dataFormat === 'get' ? $account : json_encode([$account]);
        } else {
            if ($request->dataFlag === 'topLevelOnly') {
                $query->whereNull('accounts.parentId');
            }

            if ($request->parentId) {
                $query->where('accounts.parentId', $request->parentId);
            }

            if ($request->code) {
                $query->where('accounts.code', $request->code);
            }

            DataTablesHelper::AddCommonWhereClauses($query, $request, false);

            $query->orderBy('accounts.code');

            if ($request->dataFormat === 'dataTables') {
                $accounts = [];

                $parentAccounts = Account::distinct()->whereNotNull('parentId')->pluck('parentId')->toArray();

                foreach ($query->cursor() as $account) {
                    $account->children = [];

                    if (array_search($account->id, $parentAccounts) !== false) {
                        $account->noEdit = 1;

                        $account->parentFlag = true;

                        // Add children for Tree Grid
                        $childQuery = DB::table('accounts')
                        ->where('accounts.parentId', $account->id);

                        $this->addColumns($childQuery);
                        $this->addJoins($childQuery);
                        $this->addTransactionsColumns($childQuery);

                        foreach ($childQuery->cursor() as $subAccount) {
                            $account->debits += $subAccount->debits;
                            $account->credits += $subAccount->credits;

                            // Added - 25 Nov 2020
                            $account->balance += ($subAccount->debits - $subAccount->credits);

                            array_push($account->children, $subAccount);
                        }
                    } else {
                        $account->parentFlag = false;
                    }

                    array_push($accounts, $account);
                }

                //Utils::LogSqlQuery($query);

                $returnData = new \stdClass();
                $returnData->data = $accounts;

                return json_encode($returnData);
            } else {
                return DataTablesHelper::ReturnData($query, $request);
            }
        }
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'category' => 'required',
            'type' => 'required',
            'taxRateId' => 'required',
            'description' => 'required',
        ];

        $rules['code'] = isset($request->id) ? ['required', Rule::unique('accounts')->ignore($request->id)] : ['required', Rule::unique('accounts')];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? Account::findOrFail($request->id) : new Account;

            $record->code = $request->code;
            $record->category = $request->category;
            $record->type = $request->type;
            $record->description = $request->description;
            $record->notes = $request->notes;
            $record->taxRateId = $request->taxRateId;
            $record->parentId = $request->parentId;
            $record->systemFlag = $request->systemFlag;

            $record->bankAccountInstitution = $request->bankAccountInstitution;
            $record->bankAccountName = $request->bankAccountName;
            $record->bankAccountNumber = $request->bankAccountNumber;
            $record->bankAccountBranch = $request->bankAccountBranch;
            $record->bankAccountCode = $request->bankAccountCode;

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

    public function postJournal(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'debitId' => 'required',
            'creditId' => 'required',
            'description' => 'required',
            'amount' => new ValidNumber,
            'dateTime' => new ValidDate,
        ];

        $messages = [
            'debitId.required' => 'Please select an Account to debit',
            'creditId.required' => 'Please select an Account to credit',
            'description.required' => 'Please provide a description of the AccountTransaction',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            return DB::transaction(function () use ($request) {
                $batch = Batch::create([
                    'date' => Utils::convertDateTime($request->dateTime),
                    'employeeId' => session('employeeId'),
                    'type' => 'Journal',
                    'reference' => $request->description,
                ]);

                // **********************************************
                // Debit
                // **********************************************
                AccountTransaction::create([
                    'batchId' => $batch->id,
                    'type' => 'Debit',
                    'accountId' => $request->debitId,
                    'amount' => $request->amount,
                ]);

                // **********************************************
                // Credit
                // **********************************************
                AccountTransaction::create([
                    'batchId' => $batch->id,
                    'type' => 'Credit',
                    'accountId' => $request->creditId,
                    'amount' => $request->amount,
                ]);

                // ?????????? return json_encode($record);
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

    public function destroy(Request $request)
    {
        $returnData = new \stdClass();

        $newRequest = new Request;
        $newRequest->id = $request->id;
        $newRequest->dataFormat = 'get';
        $account = $this->get($newRequest);

        if ($account->systemFlag == 1) {
            $returnData->error = 'This account cannot be deleted. It is a system level account';

            return json_encode($returnData);
        } elseif ($account->debits > 0 || $account->credits > 0) {
            $returnData->error = 'This account cannot be deleted. It has account_transactions associated with it.';

            return json_encode($returnData);
        } elseif (! empty($account->children)) {
            $returnData->error = 'This account cannot be deleted. It has sub accounts linked to it.';

            return json_encode($returnData);
        }

        return DataTablesHelper::destroy($request, Account::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('accounts')
        ->where('code', '<', $request->code)
        ->whereNull('accounts.parentId')
        ->orderBy('code')
        ->count();
    }

    protected function getNextAccountCode(Request $request)
    {
        if ($request->parentId) {
            $code = Account::where('id', $request->parentId)->pluck('code')->first();

            $newCode = $this->generatetNextAccountCode($code, $request->parentId);

            return json_encode($newCode);
        } elseif ($request->category && $request->type) {
            $code = Account::where('category', $request->category)
            ->where('type', $request->type)
            ->whereNull('parentId')
            ->orderBy('code', 'desc')
            ->pluck('code')
            ->first();

            $newCode = $this->generatetNextAccountCode($code);

            return json_encode($newCode);
        }
    }

    protected function generatetNextAccountCode($code, $parentId = null)
    {
        $counter = 1;

        if ($parentId) {
            $newCode = $code.'-'.$counter;
        } else {
            if (is_numeric($code)) {
                $newCode = strval((int) $code + ($counter * 10));
            } else {
                $newCode = $code.'-'.$counter;
            }
        }

        $query = Account::where('code', $newCode);

        if (! $parentId) {
            $query->whereNull('parentId');
        }

        $codeAvailable = $query->count();

        if (! $codeAvailable) {
            return $newCode;
        } else {
            $counter++;

            while ($counter <= 5000) {
                if ($parentId) {
                    $newCode = $code.'-'.$counter;
                } else {
                    if (is_numeric($code)) {
                        $newCode = strval((int) $code + ($counter * 10));
                    } else {
                        $newCode = $code.'-'.$counter;
                    }
                }

                $query = Account::where('code', $newCode);

                if (! $parentId) {
                    $query->whereNull('parentId');
                }

                $codeAvailable = $query->count();

                if (! $codeAvailable) {
                    break;
                }

                $counter++;
            }

            return $newCode;
        }
    }
}
