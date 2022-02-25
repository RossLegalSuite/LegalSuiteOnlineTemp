<?php

use Illuminate\Database\Migrations\Migration;

class CreateSupervisorGroupTrigger extends Migration
{
    public function up()
    {
        DB::unprepared('
            CREATE TRIGGER Supervisor_Group_Prevent_Deletion
            BEFORE DELETE ON employee_groups
            FOR EACH ROW
            BEGIN
                IF old.code = "SUPER" THEN 
                    SIGNAL SQLSTATE "45000" 
                    SET MESSAGE_TEXT = "You cannot delete this Group. It is used by the system to identify the Supervisor.";
                END IF;
            END
        ');
    }

    public function down()
    {
        DB::unprepared('DROP TRIGGER `Supervisor_Group_Prevent_Deletion`');
    }
}
