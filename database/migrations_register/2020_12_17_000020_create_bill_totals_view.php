<?php

use Illuminate\Database\Migrations\Migration;

class CreateBillTotalsView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW bill_totals AS 
        SELECT 
            billId,
            'Debits' COLLATE utf8mb4_unicode_ci as type,
            SUM(totalAmount) AS amount
        FROM bill_debits
        WHERE bill_debits.billId IS NOT NULL
        GROUP BY billId
        UNION ALL
        SELECT 
            bills.id,
            'Credits' COLLATE utf8mb4_unicode_ci as type,
            SUM(-bill_credits.amount) AS amount 
        FROM bill_credits 
        JOIN bills ON bills.id = bill_credits.billId
        GROUP BY bills.id  
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS bill_totals');
    }
    
}
