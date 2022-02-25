<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMatterTypesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('matter_types', function (Blueprint $table) {
            $table->increments('id');
            $table->string('description')->unique();
            $table->string('code')->unique();
            $table->string('textColor')->default('#000');
            $table->string('backgroundColor')->default('#FFF');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('matter_types');
    }
}
