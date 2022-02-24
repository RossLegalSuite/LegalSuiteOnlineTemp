<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Correspondence extends Model
{
    protected $guarded = ['id'];
    protected $table = 'correspondence';
    public $timestamps = false;
    protected $connection = 'user';

}
