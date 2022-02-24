<?php



use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMatterPartiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('matter_parties', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('matterId');
            $table->unsignedInteger('partyId');
            $table->unsignedInteger('roleId');
            $table->unsignedInteger('rank');
            $table->string('reference')->nullable();

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('cascade');
            
            $table->foreign('partyId')
            ->references('id')->on('parties')
            ->onDelete('restrict');

            $table->foreign('roleId')
            ->references('id')->on('party_roles')
            ->onDelete('restrict');

            $table->unique(['matterId', 'partyId', 'roleId']);
            
            $table->index(['matterId', 'partyId', 'roleId', 'rank']);



        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('matter_parties');
    }
}
