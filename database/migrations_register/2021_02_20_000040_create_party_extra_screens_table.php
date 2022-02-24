<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePartyExtraScreensTable extends Migration
{

    public function up()
    {
        Schema::create('party_extra_screens', function (Blueprint $table) {

            $table->increments('id');

            $table->unsignedInteger('partyId');
            $table->unsignedInteger('extraScreenId');
            $table->string('name');
            $table->string('value');

            $table->index(['partyId','extraScreenId','name']);

            $table->foreign('partyId')->references('id')->on('parties');
            $table->foreign('extraScreenId')->references('id')->on('extra_screens');

        });    
    }

    public function down()
    {
        Schema::dropIfExists('party_extra_screens');
    }
}
