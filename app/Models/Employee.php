<?php

namespace App\Models;

//See: https://www.5balloons.info/changing-authentication-table-laravel/

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;


class Employee extends Authenticatable
{

    use Notifiable;

    protected $guarded = ['id'];
    protected $connection = 'user';

    protected $hidden = [
        'password', 'remember_token',
    ];


}
