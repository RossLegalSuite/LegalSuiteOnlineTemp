<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFeeSheetsTable extends Migration
{
    public function up()
    {
        Schema::create('fee_sheets', function (Blueprint $table) {
            $table->increments('id');
            $table->string('code')->unique();
            $table->string('description');

            $table->index(['description']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('fee_sheets');
    }
}
