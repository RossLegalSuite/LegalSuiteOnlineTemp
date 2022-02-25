<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EmployeeGroup extends Model
{
    protected $guarded = ['id'];

    public $timestamps = false;

    protected $connection = 'user';
}
