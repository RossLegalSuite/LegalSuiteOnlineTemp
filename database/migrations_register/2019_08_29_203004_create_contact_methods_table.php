<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateContactMethodsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('contact_methods', function (Blueprint $table) {
            $table->increments('id');
            $table->enum('type', ['Email', 'Work', 'Home', 'Mobile', 'Twitter', 'FaceBook', 'Whatsapp', 'Google', 'Instagram', 'Fax', 'Other']);
            $table->string('description')->unique();
            $table->timestamps();

            $table->index('type', 'description');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('contact_methods');
    }
}
