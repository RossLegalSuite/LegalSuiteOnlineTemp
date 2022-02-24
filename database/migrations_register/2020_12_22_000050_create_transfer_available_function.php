<?php

use Illuminate\Database\Migrations\Migration;

class CreateTransferAvailableFunction extends Migration
{

    public function up()
    {
        DB::unprepared('
            CREATE FUNCTION transferAvailable(
                id INT UNSIGNED
            ) 
            RETURNS DECIMAL(15,2)
            DETERMINISTIC
            BEGIN
                DECLARE tranferAvailable DECIMAL(15,2) DEFAULT 0;
                DECLARE postedTotal DECIMAL(15,2);
                DECLARE unreservedTrustCredits DECIMAL(15,2);
                
                SET postedTotal = (SELECT IFNULL( 
                    (SELECT SUM(debits) FROM matter_business_balances
                    WHERE matterId = id), 0));
            
                SET unreservedTrustCredits = (SELECT IFNULL(
                    (SELECT SUM(CASE WHEN account_transactions.type="Debit" THEN -account_transactions.amount ELSE account_transactions.amount END) from account_transactions
                    join accounts on accounts.id = account_transactions.accountId
                    where accounts.matterId = id
                    and account_transactions.reservedFlag = 0
                    and accounts.parentId = (select trustControlAccountId from company limit 1)), 0));
            
                IF postedTotal > 0 AND unreservedTrustCredits > 0 THEN
                    IF unreservedTrustCredits > postedTotal THEN
                        SET tranferAvailable = postedTotal;
                    ELSE
                        SET tranferAvailable = unreservedTrustCredits;
                    END IF;
                END IF;
            
                RETURN (tranferAvailable);
            END
        ');

        // SET unreservedTrustCredits = (SELECT IFNULL(
        //     (SELECT SUM(amount) FROM receipt_transactions
        //     LEFT JOIN receipts ON receipt_transactions.receiptId = receipts.id
        //     WHERE receipt_transactions.matterId = id AND receipts.type = "Trust" AND receipt_transactions.invoiceId IS NOT NULL
        //     GROUP BY receipt_transactions.matterId), 0));


    }

    public function down()
    {

        DB::unprepared('DROP FUNCTION `transferAvailable`');

    }
}
