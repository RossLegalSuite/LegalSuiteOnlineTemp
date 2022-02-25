<?php

use Illuminate\Database\Seeder;

class DocumentSetSeeder extends Seeder
{
    public function run()
    {
        DB::table('document_sets')->insert(['code' => 'general', 'description' => 'General', 'color' => 'black']);
        DB::table('document_sets')->insert(['code' => 'tranfers', 'description' => 'Transfers', 'color' => 'indianred']);
        DB::table('document_sets')->insert(['code' => 'magistratesCourt', 'description' => 'Magistrates Court', 'color' => 'steelblue']);
        DB::table('document_sets')->insert(['code' => 'highCourt', 'description' => 'High Court', 'color' => 'forestgreen']);
    }
}
