<?php

use Illuminate\Database\Migrations\Migration;

class CreateMatterTrustBalancesView extends Migration
{
    public function up()
    {
        DB::statement("
        CREATE OR REPLACE VIEW matter_trust_balances AS
        select matters.id as matterId, 
        COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount WHEN account_transactions.type='Credit' THEN -account_transactions.amount END),0) AS balance,
        COALESCE(SUM(CASE WHEN account_transactions.type='Debit' and account_transactions.reservedFlag = 1 THEN account_transactions.amount WHEN account_transactions.type='Credit'  and account_transactions.reservedFlag = 1 THEN -account_transactions.amount END),0) AS reservedBalance,
        COALESCE(SUM(CASE WHEN account_transactions.type='Debit' and account_transactions.reservedFlag = 0 THEN account_transactions.amount WHEN account_transactions.type='Credit'  and account_transactions.reservedFlag = 0 THEN -account_transactions.amount END),0) AS unreservedBalance
        from account_transactions 
        LEFT JOIN  accounts on account_transactions.accountId = accounts.id 
        RIGHT JOIN matters ON matters.id  = accounts.matterId 
        where accounts.parentId = (select trustControlAccountId from company limit 1)
        GROUP BY matters.id;
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS matter_trust_balances');
    }
}
