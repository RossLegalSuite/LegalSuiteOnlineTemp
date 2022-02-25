<?php

use Illuminate\Database\Seeder;

class BranchSeeder extends Seeder
{
    public function run()
    {
        DB::table('branches')->insert(['code' => 'headOffice', 'description' => 'Head Office']);
    }
}
