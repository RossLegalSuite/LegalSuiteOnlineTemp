<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateReceiptsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('receipts', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('createdById');
            $table->unsignedInteger('clientId');

            $table->dateTime('date');
            $table->enum('method', ['EFT', 'Credit Card', 'Direct Deposit', 'Cash', 'Debit Card', 'Cheque', 'Money Transfer', 'Other']);
            $table->string('reference')->nullable();

            $table->enum('type', ['Payment', 'Retainer', 'Deposit']);

            $table->enum('postTo', ['Business', 'Trust']);
            $table->unsignedInteger('businessBankAccountId')->nullable();
            $table->unsignedInteger('trustBankAccountId')->nullable();

            $table->boolean('posted')->default(0);

            $table->index(['date']);

            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('clientId')
            ->references('id')->on('parties')
            ->onDelete('restrict');

            $table->foreign('businessBankAccountId')
            ->references('id')->on('accounts')
            ->onDelete('restrict');

            $table->foreign('trustBankAccountId')
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
        Schema::dropIfExists('receipts');
    }
}
