<?php

use Illuminate\Database\Seeder;

class PartyTypeSeeder extends Seeder
{
    public function run()
    {
        DB::table('party_types')->insert(['type' => 'N', 'code' => 'male', 'description' => 'Male']);
        DB::table('party_types')->insert(['type' => 'N', 'code' => 'female', 'description' => 'Female']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'business', 'description' => 'Business']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'estateAgent', 'description' => 'Estate Agent']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'mortgageOriginator', 'description' => 'Mortgage Originator']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'financialInstitution', 'description' => 'Financial Institution']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'insuranceCompany', 'description' => 'Insurance Company']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'medicalAid', 'description' => 'Medical Aid']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'pensionFund', 'description' => 'Pension Fund']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'hotel', 'description' => 'Hotel']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'advocate', 'description' => 'Advocate']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'attorney', 'description' => 'Attorney']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'hospital', 'description' => 'Hospital']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'developer', 'description' => 'Developer']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'otherBusiness', 'description' => 'Other Business']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'deceasedEstate', 'description' => 'Deceased Estate']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'insolventEstate', 'description' => 'Insolvent Estate']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'otherEstate', 'description' => 'Other Estate']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'localAuthority', 'description' => 'Local Authority']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'provincialAuthority', 'description' => 'Provincial Authority']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'stateAuthority', 'description' => 'State Authority']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'federalAuthourity', 'description' => 'Federal Authourity']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'nationalAuthority', 'description' => 'National Authority']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'internationalAuthority', 'description' => 'International Authority']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'statutoryBody', 'description' => 'Statutory Body']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'religousBody', 'description' => 'Religous Body']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'charity', 'description' => 'Charity']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'politicalParty', 'description' => 'Political Party']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'school', 'description' => 'School']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'tradeUnion', 'description' => 'Trade Union']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'club', 'description' => 'Club']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'nonGovernmentOrganisation', 'description' => 'Non Government Organisation']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'nonProfitOrganisation', 'description' => 'Non Profit Organisation']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'bodyCorporate', 'description' => 'Body Corporate']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'university', 'description' => 'University']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'college', 'description' => 'College']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'coOp ', 'description' => 'Co op']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'farm', 'description' => 'Farm']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'judge', 'description' => 'Judge']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'sheriff', 'description' => 'Sheriff']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'bailiff', 'description' => 'Bailiff']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'registrar', 'description' => 'Registrar']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'clerk', 'description' => 'Clerk']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'courtOfficial', 'description' => 'Court Official']);
        DB::table('party_types')->insert(['type' => 'N', 'code' => 'unknownPerson', 'description' => 'Unknown (Person)']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'unknownJuristic', 'description' => 'Unknown (Juristic)']);
        DB::table('party_types')->insert(['type' => 'N', 'code' => 'otherPerson', 'description' => 'Other (Person)']);
        DB::table('party_types')->insert(['type' => 'J', 'code' => 'otherJuristic', 'description' => 'Other (Juristic)']);
    }
}
