<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MatterEmployee extends Model
{
    protected $guarded = ['id'];

    protected $connection = 'user';

    public $timestamps = false;

    protected $table = 'matter_employees';
}
