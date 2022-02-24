<?php

use Illuminate\Database\Migrations\Migration;

class CreateDisbursementsTrigger extends Migration
{

    public function up()
    {
        DB::unprepared('
            CREATE TRIGGER Disbursements_Prevent_Deletion
            BEFORE DELETE ON disbursements
            FOR EACH ROW
            BEGIN
                IF old.batchId THEN 
                    SIGNAL SQLSTATE "45000" 
                    SET MESSAGE_TEXT = "This Disbursement has been posted";
                ELSEIF old.invoiceId THEN 
                    SIGNAL SQLSTATE "45000" 
                    SET MESSAGE_TEXT = "This Disbursement has been invoiced";
                END IF;
            END
        ');

    }

    public function down()
    {

        DB::unprepared('DROP TRIGGER `Disbursements_Prevent_Deletion`');

    }
}
