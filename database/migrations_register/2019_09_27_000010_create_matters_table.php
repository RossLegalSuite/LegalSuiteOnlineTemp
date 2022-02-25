<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMattersTable extends Migration
{
    public function up()
    {
        Schema::create('matters', function (Blueprint $table) {
            $table->increments('id');

            $table->string('fileRef')->unique();
            $table->string('description');
            $table->date('instructed');
            $table->decimal('quantum', 15, 2)->nullable();

            $table->unsignedInteger('feeSheetId');
            $table->unsignedInteger('matterTypeId');
            $table->unsignedInteger('documentSetId');
            $table->unsignedInteger('branchId');
            $table->unsignedInteger('incomeAccountId');
            $table->unsignedInteger('trustBankAccountId');

            $table->index(['description']);
            $table->index(['instructed']);

            $table->foreign('feeSheetId')->references('id')->on('fee_sheets');

            $table->foreign('branchId')->references('id')->on('branches');

            $table->foreign('documentSetId')->references('id')->on('document_sets');

            $table->foreign('matterTypeId')->references('id')->on('matter_types');

            $table->foreign('incomeAccountId')->references('id')->on('accounts');

            $table->foreign('trustBankAccountId')->references('id')->on('accounts');
        });
    }

    public function down()
    {
        Schema::dropIfExists('matters');
    }
}
