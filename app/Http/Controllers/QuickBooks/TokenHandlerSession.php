<?php

namespace App\Http\Controllers\QuickBooks;

use App\Employee;
use LifeOnScreen\LaravelQuickBooks\QuickBooksTokenHandler;

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
