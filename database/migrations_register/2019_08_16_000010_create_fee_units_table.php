<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFeeUnitsTable extends Migration
{
    public function up()
    {
        Schema::create('fee_units', function (Blueprint $table) {
            $table->increments('id');
            $table->string('description')->unique();
            $table->string('code')->unique();
            $table->string('singular');
            $table->string('plural');
            $table->boolean('timeBasedFlag')->default(0);
            $table->unsignedInteger('minutesPerUnit')->nullable();
        });
    }

    public function down()
    {
        Schema::dropIfExists('fee_units');
    }
}
