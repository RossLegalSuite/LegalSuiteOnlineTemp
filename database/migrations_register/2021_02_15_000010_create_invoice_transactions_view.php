<?php

use Illuminate\Database\Migrations\Migration;

class CreateInvoiceTransactionsView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW invoice_transactions AS 
        SELECT 
            CONCAT('Debit-', matter_debits.id) as id,
            matter_debits.invoiceId,
            matter_debits.matterId,
            null as receiptId,
            matter_debits.id as parentId,
            'Debit' COLLATE utf8mb4_unicode_ci as type,
            matter_debits.type as subType,
            matter_debits.date,
            matter_debits.description,
            matter_debits.amount,
            matter_debits.taxAmount,
            matter_debits.totalAmount
        FROM matter_debits
        JOIN invoices ON invoices.id = matter_debits.invoiceId
        UNION ALL
        SELECT 
            CONCAT('Credit-', receipt_transactions.id) as id,
            receipt_transactions.invoiceId,
            receipt_transactions.matterId,
            receipts.id as receiptId,
            receipt_transactions.id as parentId,
            'Credit' COLLATE utf8mb4_unicode_ci as type,
            'Receipt' as subType,
            receipts.date,
            'Receipt' as description,
            receipt_transactions.amount, 
            0 as taxAmount,
            receipt_transactions.amount as totalAmount
        FROM receipt_transactions 
        JOIN invoices ON invoices.id = receipt_transactions.invoiceId
        JOIN receipts ON receipts.id = receipt_transactions.receiptId
        JOIN matters ON matters.id = receipt_transactions.matterId
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS invoice_transactions');
    }
    
}
