<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateExtraScreenFieldsTable extends Migration
{

    public function up()
    {
        Schema::create('extra_screen_fields', function (Blueprint $table) {

            $table->increments('id');

            $table->unsignedInteger('extraScreenId');
            $table->string('type');
            $table->string('label');
            $table->string('subtype')->nullable();
            $table->string('name')->nullable();
            $table->string('className')->nullable();
            $table->string('description')->nullable();
            $table->string('placeholder')->nullable();
            $table->unsignedInteger('maxlength')->nullable();
            $table->unsignedInteger('min')->nullable();
            $table->unsignedInteger('max')->nullable();
            $table->unsignedInteger('step')->nullable();
            $table->boolean('required')->default(0);
            $table->json('values')->nullable();

            $table->foreign('extraScreenId')->references('id')->on('extra_screens');

        });    
    }

    public function down()
    {
        Schema::dropIfExists('extra_screen_fields');
    }
}
