<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDisbursementsTable extends Migration
{
    public function up()
    {
        Schema::create('disbursements', function (Blueprint $table) {
            $table->increments('id');
            $table->dateTime('date');
            $table->unsignedInteger('createdById');
            $table->text('description');
            $table->unsignedInteger('matterId');
            $table->unsignedInteger('invoiceId')->nullable();
            $table->unsignedInteger('batchId')->nullable();
            $table->unsignedInteger('paymentId')->nullable();
            //$table->unsignedInteger('creditorId')->nullable();
            $table->unsignedInteger('bankAccountId')->nullable();
            $table->enum('method', ['EFT', 'Credit Card', 'Direct Deposit', 'Cash', 'Debit Card', 'Cheque', 'Money Transfer', 'Other']);
            $table->unsignedInteger('taxRateId');
            $table->decimal('taxAmount', 15, 2);
            $table->decimal('amount', 15, 2);
            $table->decimal('totalAmount', 15, 2)->storedAs('taxAmount + amount');

            $table->index(['date']);

            // Forign Keys are added after all parent tables have been created in a separate migration
        });
    }

    public function down()
    {
        Schema::dropIfExists('disbursements');
    }
}
