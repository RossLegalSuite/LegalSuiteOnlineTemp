<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCompanyNumbersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('company_numbers', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('methodId');
            $table->string('description');
            $table->boolean('defaultFlag')->default(0);
            $table->timestamps();

            $table->index(['description']);
            $table->index(['methodId']);

            $table->foreign('methodId')
            ->references('id')->on('contact_methods')
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
        Schema::dropIfExists('company_numbers');
    }
}
