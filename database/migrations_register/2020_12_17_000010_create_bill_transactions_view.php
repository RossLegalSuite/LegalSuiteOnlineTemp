<?php

use Illuminate\Database\Migrations\Migration;

class CreateBillTransactionsView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW bill_transactions AS 
        SELECT 
            CONCAT('Debit-', bill_debits.id) as id,
            bills.id as billId,
            bill_debits.id as parentId,
            'Debit' COLLATE utf8mb4_unicode_ci as type,
            bill_debits.type as subType,
            bill_debits.date,
            bill_debits.description,
            bill_debits.matterId,
            bill_debits.expenseAccountId,
            null as paymentId,
            bill_debits.amount,
            bill_debits.taxAmount,
            bill_debits.totalAmount
        FROM bill_debits
        JOIN bills ON bills.id = bill_debits.billId
        UNION ALL
        SELECT 
            CONCAT('Credit-', bill_credits.id) as id,
            bill_credits.billId,
            bill_credits.id as parentId,
            'Credit' COLLATE utf8mb4_unicode_ci as type,
            'Payment' as subType,
            bill_credits.date,
            'Payment' as description,
            null as matterId,
            null as expenseAccountId,
            payments.id as paymentId,
            bill_credits.amount, 
            0 as taxAmount,
            bill_credits.amount as totalAmount
        FROM bill_credits 
        JOIN payments ON payments.id = bill_credits.paymentId
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS bill_transactions');
    }
    
}
