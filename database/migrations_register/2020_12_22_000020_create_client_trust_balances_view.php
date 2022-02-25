<?php

use Illuminate\Database\Migrations\Migration;

class CreateClientTrustBalancesView extends Migration
{
    public function up()
    {
        DB::statement("
        CREATE OR REPLACE VIEW client_trust_balances AS
        select clientParty.partyId, 
        COALESCE(SUM(CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount WHEN account_transactions.type='Credit' THEN -account_transactions.amount END),0) AS balance,
        COALESCE(SUM(CASE WHEN account_transactions.type='Debit' and account_transactions.reservedFlag = 1 THEN account_transactions.amount WHEN account_transactions.type='Credit'  and account_transactions.reservedFlag = 1 THEN -account_transactions.amount END),0) AS reservedBalance,
        COALESCE(SUM(CASE WHEN account_transactions.type='Debit' and account_transactions.reservedFlag = 0 THEN account_transactions.amount WHEN account_transactions.type='Credit'  and account_transactions.reservedFlag = 0 THEN -account_transactions.amount END),0) AS unreservedBalance
        from account_transactions 
        LEFT JOIN  accounts on account_transactions.accountId = accounts.id 
        RIGHT JOIN matter_parties AS clientParty ON clientParty.matterId  = accounts.matterId 
        and clientParty.roleId = 1 and clientParty.rank = 1 
        where accounts.parentId = (select trustControlAccountId from company limit 1)
        GROUP BY clientParty.partyId;
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS client_trust_balances');
    }
}
