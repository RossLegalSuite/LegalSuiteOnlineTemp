<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCreditorsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('creditors', function (Blueprint $table) {
            $table->increments('id');
            $table->string('code', 50)->unique();
            $table->enum('type', ['Business', 'Person']);
            $table->unsignedInteger('defaultExpenseId');
            $table->string('name');
            $table->string('firstName')->nullable();
            $table->string('lastName')->nullable();
            $table->string('title', 50)->nullable();
            $table->string('friendlyName')->nullable();
            $table->string('salutation');
            $table->string('physicalLine1')->nullable();
            $table->string('physicalLine2')->nullable();
            $table->string('physicalLine3')->nullable();
            $table->string('physicalCode', 50)->nullable();
            $table->unsignedInteger('physicalProvinceId');
            $table->unsignedInteger('physicalCountryId');
            $table->string('postalLine1')->nullable();
            $table->string('postalLine2')->nullable();
            $table->string('postalLine3')->nullable();
            $table->string('postalCode', 50)->nullable();
            $table->unsignedInteger('postalProvinceId');
            $table->unsignedInteger('postalCountryId');

            $table->boolean('vatVendor')->default(1);
            $table->string('vatNumber')->nullable();

            $table->index(['name']);

            $table->foreign('defaultExpenseId')
            ->references('id')->on('accounts')
            ->onDelete('restrict');

            $table->foreign('physicalCountryId')
            ->references('id')->on('countries')
            ->onDelete('restrict');

            $table->foreign('postalCountryId')
            ->references('id')->on('countries')
            ->onDelete('restrict');

            $table->foreign('physicalProvinceId')
            ->references('id')->on('provinces')
            ->onDelete('restrict');

            $table->foreign('postalProvinceId')
            ->references('id')->on('provinces')
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
        Schema::dropIfExists('creditors');
    }
}
