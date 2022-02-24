<?php

use Illuminate\Database\Migrations\Migration;

class CreateLedgerView extends Migration
{
    public function up()
    {


        //,ABS(COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount WHEN account_transactions.type='Credit' THEN -account_transactions.amount END),0)) AS total

        DB::statement("
        CREATE OR REPLACE VIEW ledger_view AS
        (
            SELECT 
            COALESCE(accounts.parentId,accounts.id) AS id
            ,COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount END),0) AS debits
            ,COALESCE(SUM(CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount END),0) AS credits
            ,COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount WHEN account_transactions.type='Credit' THEN -account_transactions.amount END),0) AS balance
            FROM account_transactions
            RIGHT JOIN accounts ON accounts.id = account_transactions.accountId
            GROUP BY id
        )");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS ledger_view');
    }

}
