<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateBillDebitsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('bill_debits', function (Blueprint $table) {

            $table->increments('id');
            $table->unsignedInteger('createdById');
            $table->unsignedInteger('billId');
            $table->unsignedInteger('matterId')->nullable();
            $table->unsignedInteger('expenseAccountId')->nullable();

            $table->dateTime('date');
            $table->enum('type', ['Expense', 'Disbursement']);
            $table->text('description');
            
            $table->unsignedInteger('taxRateId');
            $table->decimal('taxAmount', 15, 2);
            $table->decimal('amount', 15, 2);
            $table->decimal('totalAmount', 15, 2)->storedAs('taxAmount + amount');

            $table->index(['type']);
            $table->index(['billId','type']);

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');
            
            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('billId')
            ->references('id')->on('bills')
            ->onDelete('restrict');

            $table->foreign('taxRateId')
            ->references('id')->on('tax_rates')
            ->onDelete('restrict');

            $table->foreign('expenseAccountId')
            ->references('id')->on('accounts')
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
        Schema::dropIfExists('receipt_debits');
    }
}
