<?php

use Illuminate\Database\Seeder;


class MarriageTypeSeeder extends Seeder
{

    public function run()
    {
        DB::table('marriage_types')->insert(['code' => 'unmarried', 'description' => 'Unmarried']);
        DB::table('marriage_types')->insert(['code' => 'outOfCommunity', 'description' => 'Out Of Community']);
        DB::table('marriage_types')->insert(['code' => 'inCommunity', 'description' => 'In Community']);
        DB::table('marriage_types')->insert(['code' => 'civilUnionInCommunity', 'description' => 'Civil Union In Community']);
        DB::table('marriage_types')->insert(['code' => 'civilUnionOutOfCommunity', 'description' => 'Civil Union Out Of Community']);
        DB::table('marriage_types')->insert(['code' => 'traditional', 'description' => 'Traditional']);
        DB::table('marriage_types')->insert(['code' => 'religiousCeremony', 'description' => 'Religious Ceremony']);
        DB::table('marriage_types')->insert(['code' => 'other', 'description' => 'Other']);
        DB::table('marriage_types')->insert(['code' => 'unknown', 'description' => 'Unknown']);

    }
}
