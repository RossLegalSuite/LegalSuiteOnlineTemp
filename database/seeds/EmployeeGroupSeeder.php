<?php

use Illuminate\Database\Seeder;

class EmployeeGroupSeeder extends Seeder
{
    public function run()
    {
        DB::table('employee_groups')->insert(['code' => 'supervisor', 'description' => 'Supervisor']);
        DB::table('employee_groups')->insert(['code' => 'manager', 'description' => 'Manager']);
        DB::table('employee_groups')->insert(['code' => 'accountant', 'description' => 'Accountant']);
        DB::table('employee_groups')->insert(['code' => 'user', 'description' => 'User']);

        DB::table('resources')->insert(['description' => 'Matters']);
        DB::table('resources')->insert(['description' => 'Matter Parties']);
        DB::table('resources')->insert(['description' => 'Matter Employees']);
        DB::table('resources')->insert(['description' => 'Parties']);
        DB::table('resources')->insert(['description' => 'Employees']);
        DB::table('resources')->insert(['description' => 'Assemble']);
        DB::table('resources')->insert(['description' => 'Calendar']);
        DB::table('resources')->insert(['description' => 'Email']);

        DB::table('resources')->insert(['description' => 'Fee Sheets']);
        DB::table('resources')->insert(['description' => 'Fee Codes']);
        DB::table('resources')->insert(['description' => 'Fee Items']);
        DB::table('resources')->insert(['description' => 'Fee Units']);

        DB::table('resources')->insert(['description' => 'Fee Notes']);
        DB::table('resources')->insert(['description' => 'Disbursements']);
        DB::table('resources')->insert(['description' => 'File Notes']);
        DB::table('resources')->insert(['description' => 'Reminders']);
        DB::table('resources')->insert(['description' => 'Correspondence']);

        DB::table('resources')->insert(['description' => 'Creditors']);
        DB::table('resources')->insert(['description' => 'Bills']);
        DB::table('resources')->insert(['description' => 'Expenses']);
        DB::table('resources')->insert(['description' => 'Payments']);

        DB::table('resources')->insert(['description' => 'Invoices']);
        DB::table('resources')->insert(['description' => 'Receipts']);
        DB::table('resources')->insert(['description' => 'Credit Notes']);
        DB::table('resources')->insert(['description' => 'Statements']);
        DB::table('resources')->insert(['description' => 'Trust Accounts']);

        DB::table('resources')->insert(['description' => 'General Ledger']);
        DB::table('resources')->insert(['description' => 'Journals']);
        DB::table('resources')->insert(['description' => 'Audit Trail']);

        DB::table('resources')->insert(['description' => 'Settings']);
        DB::table('resources')->insert(['description' => 'Company']);
        DB::table('resources')->insert(['description' => 'Employee Roles']);
        DB::table('resources')->insert(['description' => 'Party Entities']);
        DB::table('resources')->insert(['description' => 'Party Types']);
        DB::table('resources')->insert(['description' => 'Party Roles']);
        DB::table('resources')->insert(['description' => 'Marriage Types']);
        DB::table('resources')->insert(['description' => 'Matter Types']);
        DB::table('resources')->insert(['description' => 'Document Sets']);
        DB::table('resources')->insert(['description' => 'Branches']);
        DB::table('resources')->insert(['description' => 'Chart of Accounts']);
        DB::table('resources')->insert(['description' => 'Tax Rates']);
        DB::table('resources')->insert(['description' => 'Reports']);
        DB::table('resources')->insert(['description' => 'Document Templates']);
        DB::table('resources')->insert(['description' => 'System Templates']);
        DB::table('resources')->insert(['description' => 'Employee Groups']);
        DB::table('resources')->insert(['description' => 'Template Components']);
        DB::table('resources')->insert(['description' => 'Extra Screens']);

        $query = DB::table('employee_groups')->where('code', '<>', 'supervisor');

        foreach ($query->cursor() as $employeeGroup) {
            $childQuery = DB::table('resources');

            foreach ($childQuery->cursor() as $resource) {
                if (
                    $resource->description === 'Import Data' ||
                    $resource->description === 'Employee Groups'
                ) {
                    $viewFlag = 0;
                    $insertFlag = 0;
                    $changeFlag = 0;
                    $deleteFlag = 0;
                } elseif ($resource->description === 'Settings' ||
                    $resource->description === 'General Ledger' ||
                    $resource->description === 'Bank Recon' ||
                    $resource->description === 'Trust Accounts'
                    ) {
                    if ($employeeGroup->code === 'manager' || $employeeGroup->code === 'accountant') {
                        $viewFlag = 1;
                        $insertFlag = 1;
                        $changeFlag = 1;
                        $deleteFlag = 1;
                    } else {
                        $viewFlag = 0;
                        $insertFlag = 0;
                        $changeFlag = 0;
                        $deleteFlag = 0;
                    }
                } elseif ($resource->description === 'Journals' ||
                            $resource->description === 'Chart of Accounts' ||
                            $resource->description === 'Trust Accounts' ||
                            $resource->description === 'Tax Rates') {
                    if ($employeeGroup->code === 'accountant') {
                        $viewFlag = 1;
                        $insertFlag = 1;
                        $changeFlag = 1;
                        $deleteFlag = 1;
                    } else {
                        $viewFlag = 0;
                        $insertFlag = 0;
                        $changeFlag = 0;
                        $deleteFlag = 0;
                    }
                } else {
                    $viewFlag = 1;
                    $insertFlag = 1;
                    $changeFlag = 1;
                    $deleteFlag = 1;
                }

                DB::table('permissions')->insert([
                    'employeeGroupId' => $employeeGroup->id,
                    'resourceId' => $resource->id,
                    'viewFlag' => $viewFlag,
                    'insertFlag' => $insertFlag,
                    'changeFlag' => $changeFlag,
                    'deleteFlag' => $deleteFlag,
                ]);
            }
        }
    }
}
