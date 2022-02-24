<?php

use Illuminate\Database\Seeder;
use App\Models\Component;


class ComponentSeeder extends Seeder
{

    public function run()
    {

        $templatePath = base_path() . '/resources/js/pages/components/default/';

        $contents = file_get_contents($templatePath . 'letterhead.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'letterhead';
        $component->description = 'The company letterhead';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();

        // $contents = file_get_contents($templatePath . 'invoice.html');
        // $component = new Component;
        // $component->employeeId = 1;
        // $component->title = 'invoice';
        // $component->description = 'Invoice and Quotation layout';
        // $component->source = 'Invoice';
        // $component->contents = $contents;

        // $component->save();

        $contents = file_get_contents($templatePath . 'companyLogo.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'companyLogo';
        $component->description = 'Company Logo (or name)';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();
        
        $contents = file_get_contents($templatePath . 'companyAddress.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'companyAddress';
        $component->description = 'Company Address details';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();
        
        $contents = file_get_contents($templatePath . 'bankDetailsBlock.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'bankDetailsBlock';
        $component->description = 'The company\'s banking details in a block format';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();

        $contents = file_get_contents($templatePath . 'bankDetailsLine.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'bankDetailsLine';
        $component->description = 'The company\'s banking details on a single line';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();

        $contents = file_get_contents($templatePath . 'companyPostalLine.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'companyPostalLine';
        $component->description = 'The company\'s banking details in a horizontal line';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();
        
        $contents = file_get_contents($templatePath . 'companyPostalBlock.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'companyPostalBlock';
        $component->description = 'The company\'s banking details in a block format';
        $component->source = 'Company';
        $component->contents = $contents;

        $component->save();
        
        $contents = file_get_contents($templatePath . 'valediction.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'valediction';
        $component->description = 'The ending of the letter';
        $component->source = 'Employee';
        $component->contents = $contents;

        $component->save();

        $contents = file_get_contents($templatePath . 'salutation.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'salutation';
        $component->description = 'The salutation at the beginning of a letter or email';
        $component->source = 'Party';
        $component->contents = $contents;

        $component->save();

        $contents = file_get_contents($templatePath . 'creditorPostal.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'creditorPostal';
        $component->description = 'The creditor\'s postal address';
        $component->source = 'Creditor';
        $component->contents = $contents;

        $component->save();
        
        $contents = file_get_contents($templatePath . 'partyPostal.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'partyPostal';
        $component->description = 'The party\'s postal address';
        $component->source = 'Party';
        $component->contents = $contents;

        $component->save();
        

        $contents = file_get_contents($templatePath . 'partyPhysical.html');
        $component = new Component;
        $component->employeeId = 1;
        $component->title = 'partyPhysical';
        $component->description = 'The party\'s physical address';
        $component->source = 'Party';
        $component->contents = $contents;

        $component->save();




        
    }
}
