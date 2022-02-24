<?php

namespace App\Http\Controllers\QuickBooks;

use LifeOnScreen\LaravelQuickBooks\QuickBooksTokenHandler;
use App\Employee;

class TokenHandlerSession extends QuickBooksTokenHandler
{
    public function set($key, $value)
    {

        session([$key => $value]);


    }

    public function get($key)
    {

        return session($key);
        
    }
}