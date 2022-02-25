<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBillCreditsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('bill_credits', function (Blueprint $table) {
            $table->increments('id');

            $table->dateTime('date');
            $table->unsignedInteger('paymentId');
            $table->unsignedInteger('billId');
            $table->decimal('amount', 15, 2);

            $table->foreign('paymentId')
            ->references('id')->on('payments')
            ->onDelete('restrict');

            $table->foreign('billId')
            ->references('id')->on('bills')
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
        Schema::dropIfExists('bill_credits');
    }
}
