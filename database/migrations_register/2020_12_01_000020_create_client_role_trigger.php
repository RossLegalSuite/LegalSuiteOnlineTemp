<?php

use Illuminate\Database\Migrations\Migration;

class CreateClientRoleTrigger extends Migration
{

    public function up()
    {
        DB::unprepared('
            CREATE TRIGGER Client_Role_Prevent_Deletion
            BEFORE DELETE ON party_roles
            FOR EACH ROW
            BEGIN
                IF old.code = "CLIENT" THEN 
                    SIGNAL SQLSTATE "45000" 
                    SET MESSAGE_TEXT = "You cannot delete this Party Role. It is used by the system to identify the Client for a Matter.";
                END IF;
            END
        ');

    }

    public function down()
    {

        DB::unprepared('DROP TRIGGER `Client_Role_Prevent_Deletion`');

    }
}
