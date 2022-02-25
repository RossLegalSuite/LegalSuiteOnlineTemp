<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTaxRateComponentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('tax_rate_components', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('taxRateId');
            $table->unsignedInteger('taxComponentId');

            $table->timestamps();

            $table->foreign('taxRateId')
            ->references('id')->on('tax_rates')
            ->onDelete('restrict');

            $table->foreign('taxComponentId')
            ->references('id')->on('tax_components')
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
        Schema::dropIfExists('tax_rate_components');
    }
}
