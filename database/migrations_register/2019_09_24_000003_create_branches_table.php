<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBranchesTable extends Migration
{
    public function up()
    {
        Schema::create('branches', function (Blueprint $table) {
            $table->increments('id');
            $table->string('code')->unique();
            $table->string('description')->unique();
        });
    }

    public function down()
    {
        Schema::dropIfExists('branches');
    }
}
