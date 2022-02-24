<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ReceiptTransaction extends Model
{
    protected $guarded = ['id'];
    protected $connection = 'user';
    public $timestamps = false;
    protected $table = 'receipt_transactions';

}
