<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCreditorNumbersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('creditor_numbers', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('creditorId');
            $table->unsignedInteger('methodId');
            $table->string('description');
            $table->boolean('defaultFlag')->default(0);

            $table->index(['creditorId','description']);
            $table->index(['creditorId','methodId']);
            
            $table->foreign('methodId')
            ->references('id')->on('contact_methods')
            ->onDelete('restrict');

            $table->foreign('creditorId')
            ->references('id')->on('creditors')
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
        Schema::dropIfExists('creditor_numbers');
    }
}
