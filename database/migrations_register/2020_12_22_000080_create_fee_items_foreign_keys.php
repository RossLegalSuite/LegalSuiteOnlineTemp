<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateFeeItemsForeignKeys extends Migration
{
    public function up()
    {
        Schema::table('fee_items', function (Blueprint $table) {
            
            $table->foreign('taxRateId')
            ->references('id')->on('tax_rates')
            ->onDelete('restrict');

        });    
    }

}
