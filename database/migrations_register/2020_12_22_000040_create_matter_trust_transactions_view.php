<?php

use Illuminate\Database\Migrations\Migration;

class CreateMatterTrustTransactionsView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW matter_trust_transactions AS
        SELECT
            batches.date,
            batches.reference,
            batches.type,
            account_transactions.batchId,
            account_transactions.reservedFlag,
            matters.id AS matterId, 
            account_transactions.invoiceId,

            CASE WHEN account_transactions.invoiceId IS NOT NULL THEN
                CASE WHEN account_transactions.invoiceId < 10000 THEN CONCAT('Invoice: ',LPAD(account_transactions.invoiceId,5,'0')) ELSE CONCAT('Invoice: ',account_transactions.invoiceId) END
            ELSE null 
            END AS invoiceNumber,

            account_transactions.receiptId, 
            CASE WHEN account_transactions.receiptId IS NOT NULL THEN
                CASE WHEN account_transactions.receiptId < 10000 THEN CONCAT('Receipt: ',LPAD(account_transactions.receiptId,5,'0')) ELSE CONCAT('Receipt: ',account_transactions.receiptId) END
            ELSE null 
            END AS receiptNumber,
            
            accounts.id AS accountId, 
            accounts.description AS accountDescription, 
            CONCAT(accounts.code, ' - ', accounts.description) AS account, 
            CONCAT(matters.fileRef, ' - ', matters.description) AS matter, 
            CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount ELSE null END AS debit,
            CASE WHEN account_transactions.type='Credit' THEN account_transactions.amount ELSE null END AS credit,
            CASE WHEN account_transactions.type='Debit' THEN account_transactions.amount WHEN account_transactions.type='Credit' THEN -account_transactions.amount END AS amount
        FROM account_transactions 
        LEFT JOIN accounts ON account_transactions.accountId = accounts.id 
        LEFT JOIN batches ON account_transactions.batchId = batches.id 
        RIGHT JOIN matters ON matters.id  = accounts.matterId 
        WHERE accounts.parentId = (select trustControlAccountId FROM company LIMIT 1)
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS matter_trust_transactions');
    }
    
}
