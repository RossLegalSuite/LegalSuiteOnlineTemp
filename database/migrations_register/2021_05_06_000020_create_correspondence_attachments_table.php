<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCorrespondenceAttachmentsTable extends Migration
{
    public function up()
    {
        Schema::create('correspondence_attachments', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('correspondenceId');
            $table->string('fileName');
            $table->string('url');
            $table->string('path');
            $table->string('mimeType');
            $table->string('imageFileName');

            $table->foreign('correspondenceId')->references('id')->on('correspondence');
        });
    }

    public function down()
    {
        Schema::dropIfExists('correspondence_attachments');
    }
}
