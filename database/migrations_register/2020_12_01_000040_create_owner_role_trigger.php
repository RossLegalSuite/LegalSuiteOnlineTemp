<?php

use Illuminate\Database\Migrations\Migration;

class CreateOwnerRoleTrigger extends Migration
{

    public function up()
    {
        DB::unprepared('
            CREATE TRIGGER Owner_Role_Prevent_Deletion
            BEFORE DELETE ON employee_roles
            FOR EACH ROW
            BEGIN
                IF old.code = "OWNER" THEN 
                    SIGNAL SQLSTATE "45000" 
                    SET MESSAGE_TEXT = "You cannot delete this Employee Role. It is used by the system to identify the Owner of a Matter.";
                END IF;
            END
        ');

    }

    public function down()
    {

        DB::unprepared('DROP TRIGGER `Owner_Role_Prevent_Deletion`');

    }
}
