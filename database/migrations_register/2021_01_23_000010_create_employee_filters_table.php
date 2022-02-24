<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEmployeeFiltersTable extends Migration
{
    public function up()
    {
        Schema::create('employee_filters', function (Blueprint $table) {

            $table->string('tableId');
            $table->unsignedInteger('employeeId');
            $table->unsignedInteger('index');
            $table->unsignedInteger('targets');
            $table->string('key');
            $table->string('join');
            $table->string('method');
            $table->string('title');
            $table->string('name');
            $table->string('filterTitle');
            $table->string('filterType');
            $table->string('fromAmount');
            $table->string('toAmount');
            $table->string('fromDate');
            $table->string('toDate');
            $table->string('period');
            $table->string('value');
            $table->boolean('calculatedColumn')->default(0);

            $table->index(['tableId']);

            $table->foreign('employeeId')
            ->references('id')->on('employees')
            ->onDelete('restrict');            

        });
    }

    public function down()
    {
        Schema::dropIfExists('employee_filters');
    }
}
