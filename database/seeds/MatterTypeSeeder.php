<?php

use Illuminate\Database\Seeder;

class MatterTypeSeeder extends Seeder
{
    public function run()
    {
        DB::table('matter_types')->insert(['code' => 'general', 'description' => 'General']);
        DB::table('matter_types')->insert(['code' => 'conveyancing', 'description' => 'Conveyancing']);
        DB::table('matter_types')->insert(['code' => 'litigation', 'description' => 'Litigation']);
        DB::table('matter_types')->insert(['code' => 'commercial', 'description' => 'Commercial']);
    }
}
