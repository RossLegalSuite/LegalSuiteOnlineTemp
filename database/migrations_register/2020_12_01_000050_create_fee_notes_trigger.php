<?php

use Illuminate\Database\Migrations\Migration;

class CreateFeeNotesTrigger extends Migration
{

    public function up()
    {
        DB::unprepared('
            CREATE TRIGGER FeeNotes_Prevent_Deletion
            BEFORE DELETE ON fee_notes
            FOR EACH ROW
            BEGIN
                IF old.invoiceId THEN 
                    SIGNAL SQLSTATE "45000" 
                    SET MESSAGE_TEXT = "This Fee Note is linked to an Invoice";
                END IF;
            END
        ');

        // DB::unprepared('
        //     CREATE TRIGGER FeeNotes_Prevent_Update
        //     BEFORE UPDATE ON fee_notes
        //     FOR EACH ROW
        //     BEGIN
        //         IF old.invoiceId THEN 
        //             SIGNAL SQLSTATE "45000" 
        //             SET MESSAGE_TEXT = "This Fee Note is linked to an Invoice";
        //         END IF;
        //     END
        // ');

    }

    public function down()
    {

        //DB::unprepared('DROP TRIGGER `FeeNotes_Prevent_Update`');
        DB::unprepared('DROP TRIGGER `FeeNotes_Prevent_Deletion`');

    }
}
