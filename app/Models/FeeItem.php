<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FeeItem extends Model
{
    protected $guarded = ['id'];

    public $timestamps = false;

    protected $table = 'fee_items';

    protected $connection = 'user';
}
