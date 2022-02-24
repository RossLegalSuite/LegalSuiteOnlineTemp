<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class JournalTransaction extends Model
{
    protected $guarded = ['id'];
    protected $connection = 'user';
    public $timestamps = false;
    protected $table = 'journal_transactions';

}
