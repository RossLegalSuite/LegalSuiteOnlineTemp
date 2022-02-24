<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CorrespondenceAttachment extends Model
{
    protected $guarded = ['id'];
    protected $table = 'correspondence_attachments';
    public $timestamps = false;
    protected $connection = 'user';

}
