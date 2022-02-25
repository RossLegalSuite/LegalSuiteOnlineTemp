<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFeeNotesTable extends Migration
{
    public function up()
    {
        Schema::create('fee_notes', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('matterId');
            $table->unsignedInteger('createdById');
            $table->unsignedInteger('allocatedToId');
            $table->unsignedInteger('invoiceId')->nullable();

            $table->dateTime('date');
            $table->text('description');
            $table->unsignedInteger('taxRateId');
            $table->decimal('taxAmount', 15, 2);
            $table->decimal('amount', 15, 2);
            $table->decimal('totalAmount', 15, 2)->storedAs('taxAmount + amount');

            $table->index(['date']);

            // Foreign Keys are added after all parent tables have been created in a separate migration
        });
    }

    public function down()
    {
        Schema::dropIfExists('fee_notes');
    }
}
