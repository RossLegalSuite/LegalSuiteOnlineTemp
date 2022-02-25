<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExtraScreensTable extends Migration
{
    public function up()
    {
        Schema::create('extra_screens', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('createdById');
            $table->string('title')->unique();
            $table->string('prefix')->unique();
            $table->string('description');

            $table->enum('position', [
                'Tab',
                'Form',
            ])->default('Tab');

            $table->enum('location', [
                'Matter',
                'Party',
                'Matter Type',
                'Document Set',
                'Party Role',
                'Party Entity',
                'Party Type',
            ])->default('Matter');

            $table->unsignedInteger('matterTypeId')->nullable();
            $table->unsignedInteger('documentSetId')->nullable();
            $table->unsignedInteger('partyRoleId')->nullable();
            $table->unsignedInteger('partyEntityId')->nullable();
            $table->unsignedInteger('partyTypeId')->nullable();

            $table->index(['location']);
            $table->index(['position']);

            $table->foreign('createdById')->references('id')->on('employees');

            $table->foreign('matterTypeId')->references('id')->on('matter_types');

            $table->foreign('documentSetId')->references('id')->on('document_sets');

            $table->foreign('partyRoleId')->references('id')->on('party_roles');

            $table->foreign('partyEntityId')->references('id')->on('party_entities');

            $table->foreign('partyTypeId')->references('id')->on('party_types');
        });
    }

    public function down()
    {
        Schema::dropIfExists('extra_screens');
    }
}
