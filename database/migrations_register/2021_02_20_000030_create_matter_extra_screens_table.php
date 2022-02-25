<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMatterExtraScreensTable extends Migration
{
    public function up()
    {
        Schema::create('matter_extra_screens', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('matterId');
            $table->unsignedInteger('extraScreenId');
            $table->string('name');
            $table->string('value');

            $table->index(['matterId', 'extraScreenId', 'name']);

            $table->foreign('matterId')->references('id')->on('matters');
            $table->foreign('extraScreenId')->references('id')->on('extra_screens');
        });
    }

    public function down()
    {
        Schema::dropIfExists('matter_extra_screens');
    }
}
