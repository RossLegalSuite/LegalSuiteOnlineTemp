<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateInvoicesTable extends Migration
{
    public function up()
    {
        Schema::create('invoices', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('createdById');
            $table->unsignedInteger('matterId');
            $table->unsignedInteger('incomeAccountId');
            $table->dateTime('date');
            $table->boolean('posted')->default(0);

            $table->index(['date']);

            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');            
            
            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');

            $table->foreign('incomeAccountId')
            ->references('id')->on('accounts')
            ->onDelete('restrict');

        });
    }

    public function down()
    {
        Schema::dropIfExists('invoices');
    }
}
