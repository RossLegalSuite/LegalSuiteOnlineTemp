<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;


class User extends Authenticatable
{
    use Notifiable;
    

    protected $connection = 'backend';

    protected $fillable = [
        'name', 'email', 'password','company_code','company_name','country_code',
    ];

    /**
     * The attributes that should be hidden for arrays.
     */

    protected $hidden = [
        'password', 'remember_token',
    ];


    /**
     * The attributes that should be cast to native types.
     */

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
}
