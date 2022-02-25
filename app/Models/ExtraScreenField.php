<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExtraScreenField extends Model
{
    protected $guarded = ['id'];

    public $timestamps = false;

    protected $connection = 'user';

    protected $casts = [
        'values' => 'array',
    ];
}
