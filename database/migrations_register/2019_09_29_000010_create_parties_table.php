<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePartiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('parties', function (Blueprint $table) {
            $table->increments('id');
            $table->string('code',50)->unique();
            $table->unsignedInteger('entityId');
            $table->unsignedInteger('typeId');
            
            $table->string('name');
            $table->string('firstName')->nullable();
            $table->string('lastName')->nullable();
            $table->string('title',50)->nullable();
            $table->string('friendlyName')->nullable();
            $table->string('salutation');
            $table->string('idNumber',50)->nullable();
            $table->enum('idType', ['I', 'P', 'S', 'D', 'B', 'X', 'A','T', 'O'])->default('I');
            $table->date('birthDate')->nullable();
            $table->unsignedInteger('marriageId')->nullable();
            $table->string('physicalLine1')->nullable();
            $table->string('physicalLine2')->nullable();
            $table->string('physicalLine3')->nullable();
            $table->string('physicalCode',50)->nullable();
            $table->unsignedInteger('physicalProvinceId');
            $table->unsignedInteger('physicalCountryId');
            $table->string('postalLine1')->nullable();
            $table->string('postalLine2')->nullable();
            $table->string('postalLine3')->nullable();
            $table->string('postalCode',50)->nullable();
            $table->unsignedInteger('postalProvinceId');
            $table->unsignedInteger('postalCountryId');

            $table->boolean('vatVendor')->default(1);
            $table->string('vatNumber')->nullable();

            $table->index(['name']);


            $table->foreign('entityId')->references('id')->on('party_entities');

            $table->foreign('typeId')->references('id')->on('party_types');

            $table->foreign('physicalCountryId')->references('id')->on('countries');

            $table->foreign('postalCountryId')->references('id')->on('countries');

            $table->foreign('physicalProvinceId')->references('id')->on('provinces');

            $table->foreign('postalProvinceId')->references('id')->on('provinces');

            $table->foreign('marriageId')->references('id')->on('marriage_types');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('parties');
    }
}


