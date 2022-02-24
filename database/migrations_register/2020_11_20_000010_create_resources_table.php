<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateResourcesTable extends Migration
{

    public function up()
    {
        Schema::create('resources', function (Blueprint $table) {

            $table->increments('id');

            $table->string('description')->unique();
            
        });    
    }

    public function down()
    {
        Schema::dropIfExists('resources');
    }
}
