<?php

use Illuminate\Database\Migrations\Migration;

class CreateMatterOwnerTrigger extends Migration
{
    public function up()
    {
        DB::unprepared('
            CREATE TRIGGER Matter_Owner_Prevent_Deletion
            BEFORE DELETE ON matter_employees
            FOR EACH ROW
            BEGIN
                SET @ownerRoleId = (SELECT id FROM employee_roles WHERE code = \'OWNER\');

                IF old.rank = 1 AND old.roleId = @ownerRoleId THEN 

                    SIGNAL SQLSTATE "45000"
                    SET MESSAGE_TEXT = "You cannot delete the Owner of the Matter. A Matter must have a Owner.";

                END IF;
            END;
        ');
    }

    public function down()
    {
        DB::unprepared('DROP TRIGGER `Matter_Owner_Prevent_Deletion`');
    }
}
