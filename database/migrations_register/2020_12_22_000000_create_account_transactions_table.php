<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAccountTransactionsTable extends Migration
{
    public function up()
    {
        Schema::create('account_transactions', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('accountId');
            $table->unsignedInteger('batchId');
            $table->unsignedInteger('disbursementId')->nullable();
            $table->unsignedInteger('journalId')->nullable();
            $table->unsignedInteger('billId')->nullable();
            $table->unsignedInteger('invoiceId')->nullable();
            $table->unsignedInteger('receiptId')->nullable();
            $table->unsignedInteger('paymentId')->nullable();

            $table->boolean('reservedFlag')->default(0);

            $table->enum('type', ['Debit', 'Credit']);
            $table->decimal('amount', 15, 2);

            $table->index(['type']);
            $table->index(['amount']);

            $table->index(['accountId', 'type']);

            $table->foreign('batchId')->references('id')->on('batches');

            $table->foreign('accountId')->references('id')->on('accounts');

            $table->foreign('invoiceId')->references('id')->on('invoices');

            $table->foreign('disbursementId')->references('id')->on('disbursements');

            $table->foreign('billId')->references('id')->on('bills');

            $table->foreign('journalId')->references('id')->on('journals');

            $table->foreign('receiptId')->references('id')->on('receipts');

            $table->foreign('paymentId')->references('id')->on('payments');
        });
    }

    public function down()
    {
        Schema::dropIfExists('account_transactions');
    }
}
