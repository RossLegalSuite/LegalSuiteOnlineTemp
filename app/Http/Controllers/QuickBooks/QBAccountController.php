<?php

namespace App\Http\Controllers\QuickBooks;

use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use LifeOnScreen\LaravelQuickBooks\Resources\Account;

class QBAccountController extends Controller
{
    private $account = null;

    public function __construct()
    {
        $this->account = new Account;
    }

    public function query(Request $request)
    {
        /*

        TINKERING EXAMPLE:
        ------------------
        $account = new LifeOnScreen\LaravelQuickBooks\Resources\Account;
        $whereClause = " WHERE AccountType = 'Other Current Liability' AND AccountSubType = 'TrustAccountsLiabilities'";
        $whereClause = " WHERE AccountType like 'Other Current Liability'";
        $whereClause = " WHERE Metadata.CreateTime > '2014-12-31'";
        $records = $account->query($whereClause);

        FILTERING:
        ---------
        You can do more filtering this way - because it is a Collection!!!

        foreach ($records as $record) {
            Filter here
        }

        */

        $records = $this->account->query();

        return datatables()->collection($records)->toJson();
    }
}
