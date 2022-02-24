<?php

use Illuminate\Database\Seeder;

class PartyEntitySeeder extends Seeder
{
    public function run()
    {
        DB::table('party_entities')->insert(['type' => 'N', 'code' => 'adult', 'description' => 'Adult']);
        DB::table('party_entities')->insert(['type' => 'N', 'code' => 'minor', 'description' => 'Minor']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'soleProprietor', 'description' => 'Sole Proprietor']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'partnership', 'description' => 'Partnership']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'closeCorporation', 'description' => 'Close Corporation']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'privateCompany', 'description' => 'Private Company']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'publicCompany', 'description' => 'Public Company']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'incorporation', 'description' => 'Incorporation']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'trust', 'description' => 'Trust']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'estate', 'description' => 'Estate']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'governmentBody', 'description' => 'Government Body']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'nonProfitOrganisation', 'description' => 'Non Profit Organisation']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'nonGovernmentOrganisation', 'description' => 'Non Government Organisation']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'statutoryBody', 'description' => 'Statutory Body']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'internationalOrganization', 'description' => 'International Organization']);
        DB::table('party_entities')->insert(['type' => 'N', 'code' => 'unknownPerson', 'description' => 'Unknown (Person)']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'unknownJuristic', 'description' => 'Unknown (Juristic)']);
        DB::table('party_entities')->insert(['type' => 'N', 'code' => 'otherPerson', 'description' => 'Other (Person)']);
        DB::table('party_entities')->insert(['type' => 'J', 'code' => 'otherJuristic', 'description' => 'Other (Juristic)']);
    }
}
