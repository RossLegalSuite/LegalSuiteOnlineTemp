<?php

namespace App\Http\Middleware;

use Closure;

class LoggedOut
{
    public function handle($request, Closure $next)
    {

        //The "has method" returns true if the item is present and is not null
        if (session()->has('employeeId')) {

            return redirect('home');

        } 

        return $next($request);
    }
}
