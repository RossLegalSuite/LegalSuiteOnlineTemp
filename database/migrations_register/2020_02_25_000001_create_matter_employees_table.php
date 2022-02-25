<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMatterEmployeesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('matter_employees', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('matterId');
            $table->unsignedInteger('employeeId');
            $table->unsignedInteger('roleId');
            $table->unsignedInteger('rank');

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('cascade');

            $table->foreign('employeeId')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('roleId')
            ->references('id')->on('employee_roles')
            ->onDelete('restrict');

            $table->unique(['matterId', 'employeeId', 'roleId']);

            $table->index(['matterId', 'employeeId', 'roleId', 'rank']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('matter_employees');
    }
}
