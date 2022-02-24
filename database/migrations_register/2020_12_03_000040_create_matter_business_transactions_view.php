<?php

use Illuminate\Database\Migrations\Migration;

class CreateMatterBusinessTransactionsView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW matter_business_transactions AS 
        SELECT date, 
        invoiceId as documentId, 
        CASE WHEN invoiceId < 10000 THEN CONCAT(CASE WHEN posted = 1 THEN 'Invoice: ' ELSE 'Proforma: ' END,LPAD(invoiceId,5,'0')) ELSE CONCAT(CASE WHEN posted = 1 THEN 'Invoice: ' ELSE 'Proforma: ' END,invoiceId)  END as documentNumber,
        matterId, 
        description,
        'Invoice' as documentType,
        amount + taxAmount AS amount
        FROM matter_debits
        WHERE matter_debits.invoiceId IS NOT NULL
        UNION ALL
        SELECT receipts.date, 
        receipt_transactions.receiptId as documentId, 
        CASE WHEN receipts.id < 10000 THEN CONCAT('Receipt: ',LPAD(receipts.id,5,'0')) ELSE CONCAT('Receipt: ',receipts.id)  END as documentNumber,
        receipt_transactions.matterId, 
        CASE WHEN receipt_transactions.invoiceId IS NULL THEN 'Trust Receipt (Reserved)' ELSE 'Receipt' END as description,
        'Receipt' as documentType, 
        -receipt_transactions.amount
        FROM receipt_transactions
        JOIN receipts ON receipts.id = receipt_transactions.receiptId
    ");

        // Old one - not being referenced in the program!! May be useful?
        // DB::statement("
        // CREATE VIEW matter_business_transactions AS 
        // SELECT invoiceId, matterId, 'Debits' as type, SUM(amount + taxAmount) AS amount
        // FROM matter_debits
        // WHERE matter_debits.invoiceId IS NOT NULL
        // GROUP BY matter_debits.matterId
        // UNION ALL
        // SELECT invoices.id, invoices.matterId, 'Credits' as type, SUM(-receipt_transactions.amount) AS amount FROM receipt_transactions 
        // JOIN invoices ON invoices.id = receipt_transactions.invoiceId
        // JOIN matters ON matters.id = invoices.matterId
        // GROUP BY invoices.matterId
        // ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS matter_business_transactions');
    }
    
}
