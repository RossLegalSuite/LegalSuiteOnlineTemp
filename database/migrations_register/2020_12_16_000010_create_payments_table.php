<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePaymentsTable extends Migration
{
    public function up()
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('createdById');
            $table->dateTime('date');
            $table->enum('method', ['EFT', 'Credit Card', 'Direct Deposit', 'Cash', 'Debit Card', 'Cheque', 'Money Transfer', 'Other']);
            $table->string('reference')->nullable();
            $table->string('description')->nullable(); // Need it nullable for first save

            $table->enum('type', ['Disbursement', 'Expense', 'Creditor', 'Asset']);

            $table->unsignedInteger('creditorId')->nullable(); // Creditor
            $table->unsignedInteger('ledgerAccountId')->nullable(); // Assets & Expenses
            $table->unsignedInteger('matterId')->nullable(); // Disbursements
            $table->unsignedInteger('disbursementId')->nullable(); // Disbursements

            $table->unsignedInteger('bankAccountId')->nullable(); // Paid From

            $table->unsignedInteger('taxRateId')->nullable(); // Nullable for Creditors

            $table->decimal('taxAmount', 15, 2)->default(0); // Nullable for Creditors
            $table->decimal('amount', 15, 2);
            $table->decimal('totalAmount', 15, 2)->storedAs('taxAmount + amount');

            $table->boolean('posted')->default(0);

            $table->index(['date']);

            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('creditorId')
            ->references('id')->on('creditors')
            ->onDelete('restrict');

            $table->foreign('bankAccountId')
            ->references('id')->on('accounts')
            ->onDelete('restrict');

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');

            $table->foreign('disbursementId')
            ->references('id')->on('disbursements')
            ->onDelete('restrict');

            $table->foreign('ledgerAccountId')
            ->references('id')->on('accounts')
            ->onDelete('restrict');

            $table->foreign('taxRateId')
            ->references('id')->on('tax_rates')
            ->onDelete('restrict');
        });
    }

    public function down()
    {
        Schema::dropIfExists('payments');
    }
}
