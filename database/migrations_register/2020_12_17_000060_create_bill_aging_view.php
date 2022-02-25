<?php

use Illuminate\Database\Migrations\Migration;

class CreateBillAgingView extends Migration
{
    public function up()
    {
        DB::statement('
        CREATE OR REPLACE VIEW bill_aging AS
            select 
            billId,
            sum(case when days <= 30 then balance else 0 end) as current,
            sum(case when days > 30 and days <= 60 then balance else 0 end) as days30,
            sum(case when days > 60 and days <= 90 then balance else 0 end) as days60,
            sum(case when days > 90 and days <= 120 then balance else 0 end) as days90,
            sum(case when days > 120 then balance else 0 end) as days120
            from bill_balances
            group by billId
        ');
    }

    public function down()
    {
        DB::statement('DROP VIEW IF EXISTS bill_aging');
    }
}
