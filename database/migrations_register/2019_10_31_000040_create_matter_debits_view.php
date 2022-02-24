<?php

use Illuminate\Database\Migrations\Migration;

class CreateMatterDebitsView extends Migration
{
    public function up()
    {

        DB::statement("
            CREATE OR REPLACE VIEW matter_debits AS 
            SELECT 
                fee_notes.id,
                CONCAT('Fee-', fee_notes.id) as uniqueId,
                'Fee' COLLATE utf8mb4_unicode_ci as type, 
                fee_notes.date,
                fee_notes.description,
                fee_notes.matterId,
                fee_notes.invoiceId,
                null as batchId,
                null as bankAccountId,
                null as paymentId,
                fee_notes.taxRateId,
                fee_notes.taxAmount,
                fee_notes.amount,
                fee_notes.totalAmount,
                invoices.posted
            FROM fee_notes
            LEFT JOIN invoices on invoices.id = fee_notes.invoiceId
            UNION ALL
            SELECT 
                disbursements.id,
                CONCAT('Disbursement-', disbursements.id) as uniqueId,
                'Disbursement' COLLATE utf8mb4_unicode_ci as type, 
                disbursements.date,
                disbursements.description,
                disbursements.matterId,
                disbursements.invoiceId,
                disbursements.batchId,
                disbursements.bankAccountId,
                disbursements.paymentId as paymentId,
                disbursements.taxRateId,
                disbursements.taxAmount,
                disbursements.amount,
                disbursements.totalAmount,
                invoices.posted
            FROM disbursements
            LEFT JOIN invoices on invoices.id = disbursements.invoiceId
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS matter_debits');
    }
    
}
