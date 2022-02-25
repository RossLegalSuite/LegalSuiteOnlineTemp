<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFeeItemsTable extends Migration
{
    public function up()
    {
        Schema::create('fee_items', function (Blueprint $table) {
            $table->increments('id');
            $table->string('description');
            $table->unsignedInteger('feeCodeId');

            $table->enum('type', ['Fee', 'Disbursement']);
            $table->unsignedInteger('sorter');

            $table->unsignedInteger('taxRateId');
            $table->decimal('taxAmount', 15, 2);
            $table->decimal('amount', 15, 2);
            $table->decimal('totalAmount', 15, 2)->storedAs('taxAmount + amount');

            $table->date('fromDate')->nullable();
            $table->date('toDate')->nullable();
            $table->decimal('fromAmount', 15, 2)->nullable();
            $table->decimal('toAmount', 15, 2)->nullable();
            $table->decimal('maximumAmount', 15, 2)->nullable();
            $table->boolean('unitsFlag')->default(0);
            $table->unsignedInteger('unitsId')->nullable();
            $table->decimal('unitsFactor', 15, 2)->nullable();

            $table->index(['feeCodeId', 'sorter']);

            $table->foreign('feeCodeId')->references('id')->on('fee_codes')->onDelete('cascade');
            $table->foreign('unitsId')->references('id')->on('fee_units');

            // Additional Foreign Keys are added after all parent tables have been created in a separate migration
        });
    }

    public function down()
    {
        Schema::dropIfExists('fee_items');
    }
}
