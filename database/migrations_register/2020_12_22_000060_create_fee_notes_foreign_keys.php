<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateFeeNotesForeignKeys extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('fee_notes', function (Blueprint $table) {
            
            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('allocatedToId')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');

            $table->foreign('invoiceId')
            ->references('id')->on('invoices')
            ->onDelete('restrict');

            $table->foreign('taxRateId')
            ->references('id')->on('tax_rates')
            ->onDelete('restrict');

        });    
    }

}
