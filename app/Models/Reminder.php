<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Reminder extends Model
{
    protected $guarded = ['id'];
    public $timestamps = false;
    protected $connection = 'user';

}
