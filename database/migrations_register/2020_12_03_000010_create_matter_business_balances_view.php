<?php

use Illuminate\Database\Migrations\Migration;

class CreateMatterBusinessBalancesView extends Migration
{
    public function up()
    {
        // Note: Using RIGHT JOIN matter_parties in case there is a Matter with no Client

        DB::statement('
        CREATE VIEW matter_business_balances AS
        (
            SELECT client.id as clientId, client.code as clientCode, client.name as clientName,
            matters.id as matterId, matters.fileRef as matterFileRef,
            IFNULL(
            (SELECT SUM(matter_debits.amount + matter_debits.taxAmount) FROM matter_debits 
            JOIN invoices ON matter_debits.invoiceId = invoices.id 
            WHERE invoices.matterId = matters.id AND invoices.posted = 1)
            , 0.00) AS debits, 
            IFNULL(
            (SELECT SUM(amount) FROM receipt_transactions 
            JOIN invoices ON receipt_transactions.invoiceId = invoices.id 
            WHERE invoices.matterId = matters.id AND invoices.posted = 1)
            , 0.00)  AS credits
            FROM matters 
            RIGHT JOIN matter_parties AS clientParty ON matters.id = clientParty.matterId and clientParty.roleId = 1 and clientParty.rank = 1 
            LEFT JOIN parties AS client ON clientParty.partyId = client.id  
            
            )');
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS matter_business_balances');
    }
}
