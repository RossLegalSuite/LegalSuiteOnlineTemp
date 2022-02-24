<?php

namespace App\Http\Middleware;

use App\Custom\Utils;
use Closure;

class LoggedIn
{
    public function handle($request, Closure $next)
    {

        if ( !session()->has('companyCode') ) {

            if ( $request->isMethod('post') ) {

                return response()->json(['message' => 'Session expired'], 403);

            } else {

                return redirect( route('welcome') );

            }

        } 

        Utils::SetConnection(session('companyCode')); 

        return $next($request);

    }
}
