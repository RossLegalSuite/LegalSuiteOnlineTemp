<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateReportsTable extends Migration
{
    public function up()
    {
        Schema::create('reports', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('employeeId');
            $table->string('title')->unique();
            $table->string('description');
            $table->text('contents')->nullable();
            $table->unsignedInteger('employeeGroupId');
            $table->enum('source', ['General', 'Matters', 'Parties', 'Employees', 'Party Roles']);

            $table->index(['source']);
            $table->index(['description']);

            $table->foreign('employeeId')->references('id')->on('employees');
            $table->foreign('employeeGroupId')->references('id')->on('employee_groups');
        });
    }

    public function down()
    {
        Schema::dropIfExists('reports');
    }
}
