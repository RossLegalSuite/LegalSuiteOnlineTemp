<?php

use Illuminate\Database\Migrations\Migration;

class CreateInvoiceBalancesView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW invoice_balances AS 
        SELECT
            invoices.id as invoiceId, 
            invoices.matterId, 
            invoices.date as invoiceDate, 
            DATEDIFF( NOW(), invoices.date ) as days,
            SUM(amount) as balance 
        FROM invoice_totals
        JOIN invoices on invoices.id = invoice_totals.invoiceId
        WHERE invoices.posted = 1
        GROUP BY invoices.id
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS invoice_balances');
    }
    
}
