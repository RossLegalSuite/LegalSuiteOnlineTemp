<?php

use Illuminate\Database\Migrations\Migration;

class CreateGetNextFilerefFunction extends Migration
{
    public function up()
    {
        DB::unprepared('
        CREATE PROCEDURE getNextFileRef(
            IN code VARCHAR(255) 
        ) 
        BEGIN
            DECLARE paddedNumber VARCHAR(255) DEFAULT "0001";

            SET @query1 = "SELECT COUNT(*) INTO @counter FROM matters WHERE fileRef LIKE ?";
            SET @code = CONCAT(code,"%");

            PREPARE stmt FROM @query1;
            EXECUTE stmt USING @code;
            DEALLOCATE PREPARE stmt;
            

            IF @counter > 0 THEN

                checking: LOOP
                
                    SELECT CASE 
                        WHEN @counter < 1000 THEN LPAD(@counter,4,"0")
                        ELSE @counter
                    END
                    INTO paddedNumber;


                    SET @query2 = "SELECT COUNT(*) INTO @checkFileRef FROM matters WHERE fileRef LIKE ?";
                    SET @thisCode = CONCAT(code,"/",paddedNumber);

                    PREPARE stmt2 FROM @query2;
                    EXECUTE stmt2 USING @thisCode;
                    DEALLOCATE PREPARE stmt2;


                    IF @checkFileRef = 0 THEN
                        LEAVE checking;
                    END IF;

                    SET @counter = @counter + 1;

                END LOOP;

            END IF;

            select CONCAT(code,"/",paddedNumber) as fileRef;

        END
        ');
    }

    public function down()
    {
        DB::unprepared('DROP FUNCTION `nextFileRef`');
    }
}
