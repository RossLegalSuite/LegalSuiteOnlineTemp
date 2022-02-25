<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePermissionsTable extends Migration
{
    public function up()
    {
        Schema::create('permissions', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('resourceId');
            $table->unsignedInteger('employeeGroupId');

            $table->boolean('viewFlag')->default(1);
            $table->boolean('insertFlag')->default(1);
            $table->boolean('changeFlag')->default(1);
            $table->boolean('deleteFlag')->default(1);

            $table->foreign('resourceId')
            ->references('id')->on('resources')
            ->onDelete('restrict');

            $table->foreign('employeeGroupId')
            ->references('id')->on('employee_groups')
            ->onDelete('restrict');
        });
    }

    public function down()
    {
        Schema::dropIfExists('permissions');
    }
}
