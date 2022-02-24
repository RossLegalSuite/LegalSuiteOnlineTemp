<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TemplateField extends Model
{
    protected $guarded = ['id'];
    protected $connection = 'user';

}
