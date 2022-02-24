<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        $this->call(PartyTypeSeeder::class);
        $this->call(PartyRoleSeeder::class);
        $this->call(PartyEntitySeeder::class);
        $this->call(FeeUnitSeeder::class);
        $this->call(FeeSheetSeeder::class);
        $this->call(MarriageTypeSeeder::class);
        $this->call(CountrySeeder::class);
        $this->call(ProvinceSeeder::class);
        $this->call(ContactMethodSeeder::class);
        $this->call(BranchSeeder::class);
        $this->call(DocumentSetSeeder::class);
        $this->call(DocumentTemplateSeeder::class);
        $this->call(EmployeeRoleSeeder::class);
        $this->call(MatterTypeSeeder::class);
        $this->call(TemplateSeeder::class);
        $this->call(TemplateFieldSeeder::class);
        $this->call(ComponentSeeder::class);
        $this->call(ReportSeeder::class);

        //Done in RegisterController
        //$this->call(EmployeeGroupSeeder::class); 

        if (App::environment('local')) {
            $this->call(TestDataSeeder::class);
            //$this->call(PartiesTestSeeder::class);
            //$this->call(MatterTestSeeder::class);
        }
    }
}
