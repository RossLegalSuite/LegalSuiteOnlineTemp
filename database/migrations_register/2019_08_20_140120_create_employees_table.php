<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEmployeesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('employees', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name',50);
            $table->string('email',50)->unique();
            $table->string('password');
            $table->unsignedInteger('employeeGroupId');
            $table->unsignedInteger('allocateToId');

            $table->string('smtpUserName')->nullable();
            $table->string('smtpPassword')->nullable();

            $table->rememberToken();
            $table->timestamps();

            $table->index(['name']);

            $table->foreign('employeeGroupId')->references('id')->on('employee_groups');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('employees');
    }
}
