<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Query\Expression;

class CreateTemplatesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('templates', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('employeeId');
            
            $table->string('source');

            $table->string('title')->unique();
            $table->string('description');
            $table->text('contents')->nullable();
            $table->text('footer')->nullable();
            $table->text('header')->nullable();
            $table->enum('orientation', ['Portrait', 'Landscape'])->default('Portrait');
            $table->string('paperSize',20)->default('A4');
            $table->string('password')->nullable();
            $table->boolean('allowPrint')->default(1);
            $table->boolean('allowEdit')->default(0);
            $table->boolean('allowCopy')->default(0);
            $table->string('bottomMargin')->default('5');
            $table->string('topMargin')->default('5');
            $table->string('leftMargin')->default('5');
            $table->string('rightMargin')->default('5');

            $table->timestamps();
            
            $table->foreign('employeeId')
            ->references('id')->on('employees')
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
        Schema::dropIfExists('templates');
    }
}
