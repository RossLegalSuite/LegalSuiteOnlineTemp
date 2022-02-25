<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFileNotesTable extends Migration
{
    public function up()
    {
        Schema::create('file_notes', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('createdById');

            $table->enum('parentType', ['Matter', 'Party', 'Employee'])->default('Matter');
            $table->unsignedInteger('matterId')->nullable();
            $table->unsignedInteger('partyId')->nullable();
            $table->unsignedInteger('employeeId')->nullable();

            $table->dateTime('date');
            $table->text('description');

            $table->index(['date']);
            $table->index(['parentType']);

            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');

            $table->foreign('partyId')
            ->references('id')->on('parties')
            ->onDelete('restrict');

            $table->foreign('employeeId')
            ->references('id')->on('employees')
            ->onDelete('restrict');
        });
    }

    public function down()
    {
        Schema::dropIfExists('file_notes');
    }
}
