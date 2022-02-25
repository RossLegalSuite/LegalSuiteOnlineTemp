<?php

use Illuminate\Database\Migrations\Migration;

class CreateBillBalancesView extends Migration
{
    public function up()
    {
        DB::statement("
        CREATE OR REPLACE VIEW bill_balances AS 
            SELECT
                bills.id as billId, 
                bills.date as billDate, 
                DATEDIFF( NOW(), bills.date ) as days,
                COALESCE(SUM(CASE WHEN bill_transactions.type='Debit' THEN bill_transactions.totalAmount WHEN bill_transactions.type='Credit' THEN -bill_transactions.totalAmount END),0) AS balance
            FROM bill_transactions
            JOIN bills on bills.id = bill_transactions.billId
            WHERE bills.posted = 1
            GROUP BY bills.id
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS bill_balances');
    }
}
