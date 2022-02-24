<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PaymentTransaction extends Model
{
    protected $guarded = ['id'];
    protected $connection = 'user';
    public $timestamps = false;
    protected $table = 'payment_transactions';

}
