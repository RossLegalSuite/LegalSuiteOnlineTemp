<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePartyNumbersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('party_numbers', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('partyId');
            $table->unsignedInteger('methodId');
            $table->string('description');
            $table->boolean('defaultFlag')->default(0);

            $table->index(['partyId', 'description']);
            $table->index(['partyId', 'methodId']);

            $table->foreign('methodId')
            ->references('id')->on('contact_methods')
            ->onDelete('restrict');

            $table->foreign('partyId')
            ->references('id')->on('parties')
            ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('party_numbers');
    }
}
