<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProvincesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('provinces', function (Blueprint $table) {
            $table->increments('id');
            $table->string('countryCode',10);
            $table->string('code',10);
            $table->string('description');
            
            $table->unique(['countryCode', 'code']);

            $table->index(['code','description']);
            
            $table->index(['description']);

            $table->foreign('countryCode')
            ->references('code')->on('countries')
            ->onDelete('restrict');


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('provinces');
    }
}
