<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FeeCode extends Model
{
    protected $guarded = ['id'];
    public $timestamps = false;
    protected $table = 'fee_codes';
    protected $connection = 'user';
}
