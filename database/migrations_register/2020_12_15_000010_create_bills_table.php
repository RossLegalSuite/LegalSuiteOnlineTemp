<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBillsTable extends Migration
{
    public function up()
    {
        Schema::create('bills', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('createdById');
            $table->unsignedInteger('creditorId');
            $table->dateTime('date');
            $table->string('reference')->nullable();
            $table->boolean('posted')->default(0);

            $table->index(['date']);

            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('creditorId')
            ->references('id')->on('creditors')
            ->onDelete('restrict');
        });
    }

    public function down()
    {
        Schema::dropIfExists('bills');
    }
}
