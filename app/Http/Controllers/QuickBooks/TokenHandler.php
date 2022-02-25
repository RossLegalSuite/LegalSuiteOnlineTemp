<?php

namespace App\Http\Controllers\QuickBooks;

use App\Models\Company;
use LifeOnScreen\LaravelQuickBooks\QuickBooksTokenHandler;

class TokenHandler extends QuickBooksTokenHandler
{
    public function set($key, $value)
    {
        $company = Company::first();

        $company[$key] = $value;

        $company->save();

        //logger('Setting TokenHandler',[$key,$value]);
    }

    public function get($key)
    {

        //logger("TokenHandler Get session('companyId')",[session('companyId')]);

        $company = Company::first();

        //logger('Getting TokenHandler',[$key,$company[$key],session('companyId')]);

        return $company[$key];
    }
}
