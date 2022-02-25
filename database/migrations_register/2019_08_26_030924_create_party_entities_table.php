<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePartyEntitiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('party_entities', function (Blueprint $table) {
            $table->increments('id');
            $table->enum('type', ['J', 'N']);
            $table->string('code')->unique();
            $table->string('description')->unique();
            $table->string('textColor')->default('#000');
            $table->string('backgroundColor')->default('#FFF');

            $table->index(['type', 'description']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('party_entities');
    }
}
