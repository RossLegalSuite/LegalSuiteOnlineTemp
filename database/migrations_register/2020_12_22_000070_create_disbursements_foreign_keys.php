<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDisbursementsForeignKeys extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('disbursements', function (Blueprint $table) {
            
            $table->foreign('createdById')->references('id')->on('employees');

            //$table->foreign('creditorId')->references('id')->on('creditors');
            
            $table->foreign('bankAccountId')->references('id')->on('accounts');
            
            $table->foreign('matterId')->references('id')->on('matters');
            
            $table->foreign('paymentId')->references('id')->on('payments');

            $table->foreign('invoiceId')->references('id')->on('invoices');

            $table->foreign('batchId')->references('id')->on('batches');

            $table->foreign('taxRateId')->references('id')->on('tax_rates');

        });    
    }

}
