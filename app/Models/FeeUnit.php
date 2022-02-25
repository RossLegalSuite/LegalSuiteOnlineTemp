<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FeeUnit extends Model
{
    protected $guarded = ['id'];

    public $timestamps = false;

    protected $table = 'fee_units';

    protected $connection = 'user';
}
