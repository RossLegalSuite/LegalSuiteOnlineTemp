<?php

namespace App\Models;

//See: https://www.5balloons.info/changing-authentication-table-laravel/

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class Employee extends Authenticatable
{
    use Notifiable;

    protected $guarded = ['id'];

    protected $connection = 'user';

    protected $hidden = [
        'password', 'remember_token',
    ];
}
