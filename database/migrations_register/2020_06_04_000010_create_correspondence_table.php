<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;


class CreateCorrespondenceTable extends Migration
{
    
    public function up()
    {
        Schema::create('correspondence', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('createdById');
            $table->unsignedInteger('matterId')->nullable();
            $table->unsignedInteger('partyId')->nullable();
            $table->unsignedInteger('employeeId')->nullable();

            $table->dateTime('date');
            $table->string('batchId')->nullable();
            $table->string('description');
            $table->enum('parentType', ['General','Matter','Party','Employee']);
            $table->enum('type', ['Document', 'Email', 'Image', 'Video', 'Audio', 'Message', 'Other']);
            $table->string('path');
            $table->string('url');
            $table->string('fileName');
            $table->string('fileType')->default('application/pdf');
            $table->string('docxFile')->nullable();

            $table->index(['batchId']);
            $table->index(['date']);
            $table->index(['parentType']);
            $table->index(['type']);

            $table->foreign('createdById')->references('id')->on('employees');

            $table->foreign('employeeId')->references('id')->on('employees');

            $table->foreign('matterId')->references('id')->on('matters');

            $table->foreign('partyId')->references('id')->on('parties');

            
        });    
    }

    public function down()
    {
        Schema::dropIfExists('correspondence');
    }
}
