<?php

use Illuminate\Database\Migrations\Migration;

class CreateInvoiceAgingView extends Migration
{
    public function up()
    {

        DB::statement("
        CREATE OR REPLACE VIEW invoice_aging AS
            select 
            invoiceId,
            sum(case when days <= 30 then balance else 0 end) as current,
            sum(case when days > 30 and days <= 60 then balance else 0 end) as days30,
            sum(case when days > 60 and days <= 90 then balance else 0 end) as days60,
            sum(case when days > 90 and days <= 120 then balance else 0 end) as days90,
            sum(case when days > 120 then balance else 0 end) as days120
            from invoice_balances
            group by invoiceId
        ");
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS invoice_aging');
    }
    
}
