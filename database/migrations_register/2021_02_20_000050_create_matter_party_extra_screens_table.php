<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMatterPartyExtraScreensTable extends Migration
{
    public function up()
    {
        Schema::create('matter_party_extra_screens', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('matterPartyId');
            $table->unsignedInteger('extraScreenId');
            $table->string('name');
            $table->string('value');

            $table->index(['matterPartyId', 'extraScreenId', 'name'], 'matter_party_extra_screens_index');

            $table->foreign('matterPartyId')->references('id')->on('matter_parties');
            $table->foreign('extraScreenId')->references('id')->on('extra_screens');
        });
    }

    public function down()
    {
        Schema::dropIfExists('matter_party_extra_screens');
    }
}
