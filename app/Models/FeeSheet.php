<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FeeSheet extends Model
{
    protected $guarded = ['id'];
    public $timestamps = false;
    protected $table = 'fee_sheets';
    protected $connection = 'user';
}
