<?php

use Illuminate\Database\Migrations\Migration;

class CreateInvoiceTotalsView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW invoice_totals AS 
        SELECT 
            invoiceId,
            'Debits' COLLATE utf8mb4_unicode_ci as type, 
            SUM(totalAmount) AS amount
        FROM matter_debits
        WHERE matter_debits.invoiceId IS NOT NULL
        GROUP BY invoiceId
        UNION ALL
        SELECT 
            invoices.id,
            'Credits' COLLATE utf8mb4_unicode_ci as type, 
            SUM(-receipt_transactions.amount) AS amount 
        FROM receipt_transactions 
        JOIN invoices ON invoices.id = receipt_transactions.invoiceId
        GROUP BY invoices.id  
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS invoice_totals');
    }
    
}
