<?php

use Illuminate\Database\Migrations\Migration;

class CreateContactNumbersView extends Migration
{
    public function up()
    {
        DB::statement("
        CREATE OR REPLACE VIEW contact_numbers AS 
        SELECT 
            CONCAT('Party-', party_numbers.id) as id,
            parties.id as entityId,
            'Party' as entity,
            parties.code,
            parties.name,
            party_numbers.description,
            contact_methods.type
            FROM party_numbers
            JOIN parties ON parties.id = party_numbers.partyId
            JOIN contact_methods ON contact_methods.id = party_numbers.methodId
            UNION ALL
            SELECT 
            creditor_numbers.id,
            creditors.id as entityId,
            'Creditor' as entity,
            creditors.code,
            creditors.name,
            creditor_numbers.description,
            contact_methods.type
        FROM creditor_numbers
        JOIN creditors ON creditors.id = creditor_numbers.creditorId
        JOIN contact_methods ON contact_methods.id = creditor_numbers.methodId
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS contact_numbers');
    }
}
