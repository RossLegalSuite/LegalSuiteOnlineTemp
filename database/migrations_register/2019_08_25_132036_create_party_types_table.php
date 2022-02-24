<?php



use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePartyTypesTable extends Migration
{

    public function up()
    {
        Schema::create('party_types', function (Blueprint $table) {
            $table->increments('id');
            $table->enum('type', ['J', 'N']);
            $table->string('code')->unique();
            $table->string('description')->unique();

            $table->index(['type','description']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('party_types');
    }
}
