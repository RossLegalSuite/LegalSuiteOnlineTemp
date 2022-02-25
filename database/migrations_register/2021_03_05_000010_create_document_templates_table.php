<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDocumentTemplatesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('document_templates', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('employeeId');
            $table->unsignedInteger('extraScreenId')->nullable();
            $table->unsignedInteger('documentSetId')->nullable();

            $table->enum('type', ['Template', 'Report']);
            $table->enum('source', ['General', 'Matters', 'Parties', 'Employees', 'Party Roles']);

            $table->string('title')->unique();
            $table->string('description');
            $table->string('path');
            $table->string('fileName');
            $table->string('docxFile');
            $table->string('pdfFile');

            $table->index(['source']);
            $table->index(['fileName']);

            $table->foreign('employeeId')->references('id')->on('employees');
            $table->foreign('extraScreenId')->references('id')->on('extra_screens');
            $table->foreign('documentSetId')->references('id')->on('document_sets');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('document_templates');
    }
}
