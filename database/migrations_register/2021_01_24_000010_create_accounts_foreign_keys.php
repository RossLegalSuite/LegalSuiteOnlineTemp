<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAccountsForeignKeys extends Migration
{
    public function up()
    {
        Schema::table('accounts', function (Blueprint $table) {
            $table->foreign('taxRateId')->references('id')->on('tax_rates');

            $table->foreign('parentId')->references('id')->on('accounts');

            $table->foreign('matterId')->references('id')->on('matters');

            $table->foreign('creditorId')->references('id')->on('creditors');

            $table->foreign('disbursementId')->references('id')->on('disbursements');

            // $table->foreign('invoiceId')->references('id')->on('invoices');

            // $table->foreign('paymentId')->references('id')->on('payments');

            // $table->foreign('receiptId')->references('id')->on('receipts');
        });
    }
}
