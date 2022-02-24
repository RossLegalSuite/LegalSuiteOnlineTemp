<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MatterDocument extends Model
{
    protected $guarded = ['id'];
    public $timestamps = false;
    protected $connection = 'ettorney';

}
