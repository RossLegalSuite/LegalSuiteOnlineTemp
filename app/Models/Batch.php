<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Batch extends Model
{
    protected $guarded = ['id'];
    protected $table = 'batches';
    public $timestamps = false;
    protected $connection = 'user';

}
