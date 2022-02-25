<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateReceiptTransactionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('receipt_transactions', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('receiptId');
            $table->unsignedInteger('invoiceId')->nullable();
            $table->unsignedInteger('matterId')->nullable();
            $table->decimal('amount', 15, 2);

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');

            $table->foreign('invoiceId')
            ->references('id')->on('invoices')
            ->onDelete('restrict');

            $table->foreign('receiptId')
            ->references('id')->on('receipts')
            ->onDelete('restrict');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('receipt_transactions');
    }
}
