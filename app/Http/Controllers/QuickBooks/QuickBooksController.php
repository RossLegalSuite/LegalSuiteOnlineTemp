<?php

namespace App\Http\Controllers\QuickBooks;

use Cookie;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use LifeOnScreen\LaravelQuickBooks\QuickBooksAuthenticator;
use LifeOnScreen\LaravelQuickBooks\QuickBooksConnection;
use LifeOnScreen\LaravelQuickBooks\Resources\Account;

class QuickBooksController extends Controller
{
    public function getCompanyInfo(Request $request)
    {
        $companyInfo = App::make(QuickBooksConnection::class)->getDataService()->getCompanyInfo();

        return json_encode($companyInfo);
    }

    public function connect()
    {
        return redirect(QuickBooksAuthenticator::getAuthorizationUrl())->withCookies(Cookie::getQueuedCookies());
    }

    public function refreshTokens()
    {
        if (QuickBooksAuthenticator::processHook()) {

            // $account = new Account;

            // $account->query($request->id) );

            return redirect('/settings?tab=QuickBooks');
        } else {
            return redirect('/settings?tab=QuickBooks&error=An error was encountered connecting to Quick Books');
        }
    }

    public function disconnect()
    {

        // 7 Oct 2019 - Getting Error: Cannot access protected property QuickBooksOnline\API\Exception\ServiceException

        if (QuickBooksAuthenticator::revokeAccess()) {
            return redirect('/settings?tab=QuickBooks');
        } else {
            return redirect('/settings?tab=QuickBooks&error=An error was encountered disconnecting from Quick Books');
        }
    }
}
