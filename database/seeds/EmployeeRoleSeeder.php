<?php

use Illuminate\Database\Seeder;

class EmployeeRoleSeeder extends Seeder
{
    public function run()
    {
        DB::table('employee_roles')->insert(['code' => 'owner', 'description' => 'Owner']);
        DB::table('employee_roles')->insert(['code' => 'assistant', 'description' => 'Assistant']);
        DB::table('employee_roles')->insert(['code' => 'clerk', 'description' => 'Clerk']);
        DB::table('employee_roles')->insert(['code' => 'secretary', 'description' => 'Secretary']);
        DB::table('employee_roles')->insert(['code' => 'dataCapturer', 'description' => 'Data Capturer']);
        DB::table('employee_roles')->insert(['code' => 'advisor', 'description' => 'Advisor']);
        DB::table('employee_roles')->insert(['code' => 'complianceOfficer', 'description' => 'Compliance Officer']);
        DB::table('employee_roles')->insert(['code' => 'manager', 'description' => 'Manager']);
        DB::table('employee_roles')->insert(['code' => 'other', 'description' => 'Other']);
    }
}
