<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateJournalTransactionsTable extends Migration
{
    public function up()
    {
        Schema::create('journal_transactions', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('journalId');
            $table->unsignedInteger('accountId');
            $table->enum('type', ['Debit', 'Credit']);
            $table->decimal('amount', 15, 2);

            $table->foreign('journalId')->references('id')->on('journals');

            $table->foreign('accountId')->references('id')->on('accounts');
        });
    }

    public function down()
    {
        Schema::dropIfExists('journal_transactions');
    }
}
