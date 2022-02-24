<?php

use Illuminate\Database\Seeder;
use App\Models\Report;


class ReportSeeder extends Seeder
{

    public function run()
    {

        $reportPath = base_path() . '/resources/js/pages/reports/examples/';

        $report = new Report;
        $report->employeeId = 1;
        $report->employeeGroupId = 2;
        $report->title = 'Matter Fees Report';
        $report->description = 'Report showing Matters and their Posted & Unposted Fees';
        $report->source = 'Matters';
        $report->contents = file_get_contents($reportPath . 'matter-fees-report.html');

        $report->save();


    }
}
