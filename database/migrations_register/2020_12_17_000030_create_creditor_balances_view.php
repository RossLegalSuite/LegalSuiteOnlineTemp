<?php

use Illuminate\Database\Migrations\Migration;

class CreateCreditorBalancesView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW creditor_balances AS
        SELECT 
            creditors.id as creditorId,
            bills.id as billId, 
            bills.date as billDate, 
            DATEDIFF( NOW(), bills.date ) as days,
            SUM(amount) as balance 
        FROM bill_totals
        JOIN bills on bills.id = bill_totals.billId
        JOIN creditors ON bills.creditorId = creditors.id
        WHERE bills.posted = 1
        GROUP BY bills.id, creditors.id
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS creditor_balances');
    }
    
}
