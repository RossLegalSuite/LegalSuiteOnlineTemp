<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContactMethod extends Model
{
    protected $guarded = ['id'];

    protected $connection = 'user';
}
