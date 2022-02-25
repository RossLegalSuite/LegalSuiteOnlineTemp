<?php

use Illuminate\Database\Migrations\Migration;

class CreateClientBusinessBalancesView extends Migration
{
    public function up()
    {
        DB::statement('
        CREATE OR REPLACE VIEW client_business_balances AS
            select 
            clientParty.partyId as partyId,
            invoices.id as invoiceId, 
            invoices.matterId, 
            invoices.date as invoiceDate, 
            DATEDIFF( NOW(), invoices.date ) as days,
            sum(amount) as balance 
            from invoice_totals
            join invoices on invoices.id = invoice_totals.invoiceId
            join matter_parties AS clientParty ON invoices.matterId = clientParty.matterId and clientParty.roleId = 1 and clientParty.rank = 1 
            where invoices.posted = 1
            group by invoices.id, clientParty.partyId
        ');
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS client_business_balances');
    }
}
