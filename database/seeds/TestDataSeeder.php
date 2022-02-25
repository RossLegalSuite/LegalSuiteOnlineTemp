<?php

use App\Models\Branch;
use App\Models\Company;
use App\Models\CompanyNumber;
use App\Models\Creditor;
use App\Models\CreditorNumber;
use App\Models\Disbursement;
use App\Models\Employee;
use App\Models\FeeNote;
use App\Models\Matter;
use App\Models\MatterEmployee;
use App\Models\MatterParty;
use App\Models\Party;
use App\Models\PartyNumber;
use Illuminate\Database\Seeder;

class TestDataSeeder extends Seeder
{
    public function run()
    {

        //$faker = new Faker;
        $faker = Faker\Factory::create();

        $company = Company::first();
        $company->physicalLine1 = '29 Commercial City';
        $company->physicalLine2 = '1001 First Ave';
        $company->physicalLine3 = 'Cape Town, South Africa';
        $company->physicalCode = '8001';

        $company->postalLine1 = 'PO Box 12345';
        $company->postalLine2 = 'Cape Town';
        $company->postalLine3 = 'South Africa';
        $company->postalCode = '8000';

        $company->bankAccountName = 'First National Bank';
        $company->bankAccountNumber = '600123456789';
        $company->bankAccountBranchName = 'Durban North';
        $company->bankAccountBranchCode = '22-04-26';
        $company->bankAccountType = 'Current';

        $company->region = 'af-south-1';
        $company->website = 'http://www.acme.com';
        $company->logo = 'https://ettorney.s3.af-south-1.amazonaws.com/setup/Acme+logo.png';
        $company->letterHeadPdfFile = 'https://ettorney.s3.af-south-1.amazonaws.com/setup/Acme+Letterhead.pdf';
        $company->letterHeadFileName = 'https://ettorney.s3.af-south-1.amazonaws.com/setup/Acme+Letterhead.docx';

        $company->save();

        $number = new CompanyNumber;
        $number->methodId = 1;
        $number->defaultFlag = 1;
        $number->description = 'info@acme.com';
        $number->save();

        $number = new CompanyNumber;
        $number->methodId = 3;
        $number->defaultFlag = 1;
        $number->description = '(+27) 31 567 1234';
        $number->save();

        $number = new CompanyNumber;
        $number->methodId = 5;
        $number->defaultFlag = 1;
        $number->description = 'https://twitter.com/acme';
        $number->save();

        $number = new CompanyNumber;
        $number->methodId = 6;
        $number->defaultFlag = 1;
        $number->description = 'https://facebook.com/acme';
        $number->save();

        // Add an employee
        $employee = new Employee;
        $employee->name = 'Michael (Manager)';
        $employee->password = '$2y$10$lqR1rkbbbLlnMec/YZlFJ.3yZzApdJHFaNKS3hkvfB0cTRSlZHYei'; //secret
        $employee->email = 'manager@acme.co.za';
        $employee->employeeGroupId = 2;
        $employee->allocateToId = 1;
        $employee->save();

        // Add an employee
        $employee = new Employee;
        $employee->name = 'Andrew (Accountant)';
        $employee->password = '$2y$10$lqR1rkbbbLlnMec/YZlFJ.3yZzApdJHFaNKS3hkvfB0cTRSlZHYei'; //secret
        $employee->email = 'accountant@acme.co.za';
        $employee->employeeGroupId = 3;
        $employee->allocateToId = 1;
        $employee->save();

        // Add an employee
        $employee = new Employee;
        $employee->name = 'Larry (User)';
        $employee->password = '$2y$10$lqR1rkbbbLlnMec/YZlFJ.3yZzApdJHFaNKS3hkvfB0cTRSlZHYei'; //secret
        $employee->email = 'user@acme.co.za';
        $employee->employeeGroupId = 4;
        $employee->allocateToId = 1;
        $employee->save();

        $creditor = new Creditor;

        $creditor->code = 'ADV1';
        $creditor->type = 'Person';
        $creditor->title = 'Mr';
        $creditor->name = 'Advocate, Joe';
        $creditor->firstName = 'Joe';
        $creditor->lastName = 'Advocate';
        $creditor->friendlyName = 'Joe';
        $creditor->salutation = 'Dear Joe';
        $creditor->vatNumber = '123456-789';
        $creditor->defaultExpenseId = 21;

        $creditor->physicalLine1 = '29th Floor Acme Building';
        $creditor->physicalLine2 = '123 Main Road';
        $creditor->physicalLine3 = 'Durban';
        $creditor->physicalCode = '4000';

        $creditor->postalLine1 = 'PO Box 5562';
        $creditor->postalLine2 = 'Durban';
        $creditor->postalCode = '4001';

        $creditor->postalProvinceId = 1;
        $creditor->physicalProvinceId = 1;
        $creditor->postalCountryId = 1;
        $creditor->physicalCountryId = 1;

        $creditor->save();

        // Add an email address
        $creditorNumber = new CreditorNumber;
        $creditorNumber->creditorId = $creditor->id;
        $creditorNumber->methodId = 1;
        $creditorNumber->defaultFlag = 1;
        $creditorNumber->description = 'joe@advocates.co.za';
        $creditorNumber->save();

        $creditor = new Creditor;

        $creditor->code = 'WAL1';
        $creditor->type = 'Business';
        $creditor->name = 'Waltons Stationery (Pty) Ltd';
        $creditor->friendlyName = 'Waltons';
        $creditor->salutation = 'Dear Sir/Madam';
        $creditor->vatNumber = '1223676-789';
        $creditor->defaultExpenseId = 46;

        $creditor->physicalLine1 = '123 Main Road';
        $creditor->physicalLine2 = 'Durban';
        $creditor->physicalCode = '4000';

        $creditor->postalLine1 = 'PO Box 5562';
        $creditor->postalLine2 = 'Cape Town';
        $creditor->postalCode = '4001';

        $creditor->postalProvinceId = 1;
        $creditor->physicalProvinceId = 1;
        $creditor->postalCountryId = 1;
        $creditor->physicalCountryId = 1;

        $creditor->save();

        // Add an email address
        $creditorNumber = new CreditorNumber;
        $creditorNumber->creditorId = $creditor->id;
        $creditorNumber->methodId = 1;
        $creditorNumber->defaultFlag = 1;
        $creditorNumber->description = 'admin@waltons.co.za';
        $creditorNumber->save();

        $creditor = new Creditor;

        $creditor->code = 'SHE1';
        $creditor->type = 'Business';
        $creditor->name = 'Sheriff - Johannesburg';
        $creditor->friendlyName = 'Sheriff';
        $creditor->salutation = 'Dear Sir/Madam';
        $creditor->vatNumber = '5687676-789';
        $creditor->defaultExpenseId = 21;

        $creditor->physicalLine1 = '123 Eloff Street';
        $creditor->physicalLine2 = 'Johannesburg';
        $creditor->physicalCode = '2001';

        $creditor->postalLine1 = 'PO Box 5562';
        $creditor->postalLine2 = 'Johannesburg';
        $creditor->postalCode = '2002';

        $creditor->postalProvinceId = 1;
        $creditor->physicalProvinceId = 1;
        $creditor->postalCountryId = 1;
        $creditor->physicalCountryId = 1;

        $creditor->save();

        $creditor = new Creditor;

        $creditor->code = 'SHE2';
        $creditor->type = 'Business';
        $creditor->name = 'Sheriff - Cape Town';
        $creditor->friendlyName = 'Sheriff';
        $creditor->salutation = 'Dear Sir/Madam';
        $creditor->vatNumber = '5687676-789';
        $creditor->defaultExpenseId = 21;

        $creditor->physicalLine1 = '43 Strand Street';
        $creditor->physicalLine2 = 'Cape Town';
        $creditor->physicalCode = '2001';

        $creditor->postalLine1 = 'PO Box 5562';
        $creditor->postalLine2 = 'Cape Town';
        $creditor->postalCode = '2002';

        $creditor->postalProvinceId = 1;
        $creditor->physicalProvinceId = 1;
        $creditor->postalCountryId = 1;
        $creditor->physicalCountryId = 1;

        $creditor->save();

        $creditor = new Creditor;

        $creditor->code = 'TEL2';
        $creditor->type = 'Business';
        $creditor->name = 'Telkom';
        $creditor->salutation = 'Dear Sir/Madam';
        $creditor->vatNumber = '5687676-789';
        $creditor->defaultExpenseId = 47;

        $creditor->physicalLine1 = '43 Strand Street';
        $creditor->physicalLine2 = 'Cape Town';
        $creditor->physicalCode = '2001';

        $creditor->postalLine1 = 'PO Box 5562';
        $creditor->postalLine2 = 'Cape Town';
        $creditor->postalCode = '2002';

        $creditor->postalProvinceId = 1;
        $creditor->physicalProvinceId = 1;
        $creditor->postalCountryId = 1;
        $creditor->physicalCountryId = 1;

        $creditor->save();

        // Add an email address
        $creditorNumber = new CreditorNumber;
        $creditorNumber->creditorId = $creditor->id;
        $creditorNumber->methodId = 1;
        $creditorNumber->defaultFlag = 1;
        $creditorNumber->description = 'accounts@telkom.co.za';
        $creditorNumber->save();

        $party = new Party;

        $party->code = 'BLO1';

        $party->title = 'Mr';
        $party->name = 'Bloggs, Joe';
        $party->firstName = 'Joe';
        $party->lastName = 'Bloggs';
        $party->friendlyName = 'Joe';
        $party->salutation = 'Dear Joe';

        $party->physicalLine1 = '29 High Rise Towers';
        $party->physicalLine2 = '13423 Ridge Road';
        $party->physicalLine3 = 'Durban';
        $party->physicalCode = '4000';

        $party->postalLine1 = 'PO Box 5562';
        $party->postalLine2 = 'Durban';
        $party->postalCode = '4001';

        $party->entityId = 1;
        $party->typeId = 1;
        $party->idType = 'I';
        $party->idNumber = '731212 5097 087';
        $party->marriageId = 1;
        $party->postalProvinceId = 1;
        $party->physicalProvinceId = 1;
        $party->postalCountryId = 1;
        $party->physicalCountryId = 1;

        $party->save();

        // Add a cell phone number
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 2;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = '+27824353454';
        $partyNumber->save();

        $matter = new Matter;

        $matter->fileRef = $party->code.'/0001';
        $matter->instructed = date('Y-m-d');
        $matter->description = 'Buy & Sell Agreement';
        $matter->feeSheetId = 1;
        $matter->branchId = 1;
        $matter->incomeAccountId = 17;
        $matter->trustBankAccountId = 2;
        $matter->matterTypeId = 1;
        $matter->documentSetId = 1;

        $matter->save();

        //Client MatterParty
        $matterParty = new MatterParty;

        $matterParty->partyId = $party->id;
        $matterParty->matterId = $matter->id;
        $matterParty->roleId = 1;
        $matterParty->rank = 1;
        $matterParty->reference = '12345/678';

        $matterParty->save();

        $matterEmployee = new MatterEmployee;

        $matterEmployee->employeeId = 1;
        $matterEmployee->matterId = $matter->id;
        $matterEmployee->roleId = 1;
        $matterEmployee->rank = 1;

        $matterEmployee->save();

        $party = new Party;

        $party->code = 'JOR1';

        $party->title = 'Mr';
        $party->name = 'Jordan, Rick';
        $party->firstName = 'Rick';
        $party->lastName = 'Jordan';
        $party->friendlyName = 'Rick';
        $party->salutation = 'Dear Rick';

        $party->physicalLine1 = '123 Main Road';
        $party->physicalLine2 = 'Durban North';
        $party->physicalCode = '4015';

        $party->postalLine1 = 'PO Box 1234';
        $party->postalLine2 = 'Durban North';
        $party->postalCode = '4016';

        $party->entityId = 1;
        $party->typeId = 1;
        $party->idType = 'I';
        $party->idNumber = '640302 5097 081';
        $party->marriageId = 1;
        $party->postalProvinceId = 1;
        $party->physicalProvinceId = 1;
        $party->postalCountryId = 1;
        $party->physicalCountryId = 1;

        $party->save();

        // Add an email address
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 1;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = 'rick@legalsuite.co.za';
        $partyNumber->save();

        // Add a cell phone number
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 2;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = '+27833011942';
        $partyNumber->save();

        $matter = new Matter;

        //$matter->clientId = $party->id;
        $matter->fileRef = $party->code.'/0001';
        $matter->instructed = date('Y-m-d');
        $matter->description = 'Sale Agreement';
        $matter->feeSheetId = 1;
        $matter->branchId = 1;
        $matter->incomeAccountId = 17;
        $matter->trustBankAccountId = 2;
        $matter->matterTypeId = 2;
        $matter->documentSetId = 2;

        $matter->save();

        //Client MatterParty
        $matterParty = new MatterParty;

        $matterParty->partyId = $party->id;
        $matterParty->matterId = $matter->id;
        $matterParty->roleId = 1;
        $matterParty->rank = 1;
        $matterParty->reference = '12345/678';

        $matterParty->save();

        $matterEmployee = new MatterEmployee;

        $matterEmployee->employeeId = 1;
        $matterEmployee->matterId = $matter->id;
        $matterEmployee->roleId = 1;
        $matterEmployee->rank = 1;

        $matterEmployee->save();

        $matter = new Matter;

        $matter->fileRef = $party->code.'/0002';
        $matter->instructed = date('Y-m-d');
        $matter->description = 'Transfer: Lot 123 Durban';
        $matter->feeSheetId = 1;
        $matter->branchId = 1;
        $matter->incomeAccountId = 17;
        $matter->trustBankAccountId = 2;
        $matter->matterTypeId = 3;
        $matter->documentSetId = 3;

        $matter->save();

        //Client MatterParty
        $matterParty = new MatterParty;

        $matterParty->partyId = $party->id;
        $matterParty->matterId = $matter->id;
        $matterParty->roleId = 1;
        $matterParty->rank = 1;
        $matterParty->reference = '';

        $matterParty->save();

        $matterEmployee = new MatterEmployee;

        $matterEmployee->employeeId = 1;
        $matterEmployee->matterId = $matter->id;
        $matterEmployee->roleId = 1;
        $matterEmployee->rank = 1;

        $matterEmployee->save();

        $matter = new Matter;

        $matter->fileRef = $party->code.'/0003';
        $matter->instructed = date('Y-m-d');
        $matter->description = 'Bond Registration: First National Bank';
        $matter->feeSheetId = 1;
        $matter->branchId = 1;
        $matter->incomeAccountId = 17;
        $matter->trustBankAccountId = 2;
        $matter->matterTypeId = 4;
        $matter->documentSetId = 4;

        $matter->save();

        //Client MatterParty
        $matterParty = new MatterParty;

        $matterParty->partyId = $party->id;
        $matterParty->matterId = $matter->id;
        $matterParty->roleId = 1;
        $matterParty->rank = 1;
        $matterParty->reference = 'FNB123/567';

        $matterParty->save();

        $matterEmployee = new MatterEmployee;

        $matterEmployee->employeeId = 1;
        $matterEmployee->matterId = $matter->id;
        $matterEmployee->roleId = 1;
        $matterEmployee->rank = 1;

        $matterEmployee->save();

        $party = new Party;

        $party->code = 'ELL1';

        $party->title = 'Ms';
        $party->name = 'Elliot, Anrie';
        $party->firstName = 'Anrie';
        $party->lastName = 'Elliot';
        $party->friendlyName = 'Anrie';
        $party->salutation = 'Dear Anrie';

        $party->physicalLine1 = '123 High Ridge Road';
        $party->physicalLine2 = 'La Lucia';
        $party->physicalCode = '4015';

        $party->postalLine1 = 'PO Box 1234';
        $party->postalLine2 = 'La Lucia';
        $party->postalCode = '4016';

        $party->entityId = 1;
        $party->typeId = 2;
        $party->idType = 'I';
        $party->idNumber = '750302 5097 081';
        $party->marriageId = 1;
        $party->postalProvinceId = 1;
        $party->physicalProvinceId = 1;
        $party->postalCountryId = 1;
        $party->physicalCountryId = 1;

        $party->save();

        // Add an email address
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 1;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = 'anrie@legalsuite.co.za';
        $partyNumber->save();

        // Add a cell phone number
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 2;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = '+2712345678';
        $partyNumber->save();

        $party = new Party;

        $party->code = 'SUM1';

        $party->title = 'Mr';
        $party->name = 'Summerell, Ross';
        $party->firstName = 'Ross';
        $party->lastName = 'Summerell';
        $party->friendlyName = 'Ross';
        $party->salutation = 'Dear Ross';

        $party->physicalLine1 = '456 Valley Road';
        $party->physicalLine2 = 'Westville';
        $party->physicalCode = '4015';

        $party->postalLine1 = 'PO Box 234234';
        $party->postalLine2 = 'Westville';
        $party->postalCode = '4016';

        $party->entityId = 1;
        $party->typeId = 1;
        $party->idType = 'I';
        $party->idNumber = '850907 5097 081';
        $party->marriageId = 1;
        $party->postalProvinceId = 1;
        $party->physicalProvinceId = 1;
        $party->postalCountryId = 1;
        $party->physicalCountryId = 1;

        $party->save();

        $rossId = $party->id;

        // Add an email address
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 1;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = 'ross@legalsuite.co.za';
        $partyNumber->save();

        // Add a cell phone number
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 2;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = '+2745324234';
        $partyNumber->save();

        $party = new Party;

        $party->code = 'ACM1';

        $party->name = 'Acme International Trading & Investment Company (Pty) Ltd';
        $party->friendlyName = 'Acme Inc';

        $party->physicalLine1 = '1234 High Rise Office Block';
        $party->physicalLine2 = '100 Main Street';
        $party->physicalLine3 = 'Cape Town';
        $party->physicalCode = '8015';

        $party->postalLine1 = 'PO Box 234234';
        $party->postalLine2 = 'Cape Town';
        $party->postalCode = '8000';

        $party->entityId = 6;
        $party->typeId = 3;
        $party->idNumber = '1234/567777';
        $party->salutation = 'Dear Sir/Madam';
        $party->marriageId = 1;
        $party->postalProvinceId = 9;
        $party->physicalProvinceId = 9;
        $party->postalCountryId = 1;
        $party->physicalCountryId = 1;

        $party->save();

        // Add an email address
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 1;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = 'info@acme.co.za';
        $partyNumber->save();

        // Add a cell phone number
        $partyNumber = new PartyNumber;
        $partyNumber->partyId = $party->id;
        $partyNumber->methodId = 3;
        $partyNumber->defaultFlag = 1;
        $partyNumber->description = '+27 21 555 4576';
        $partyNumber->save();

        $matter = new Matter;

        $matter->fileRef = $party->code.'/0001';
        $matter->instructed = date('Y-m-d');
        $matter->description = 'Shareholders Agreement & Drafting of Merger Documents for Listing';
        $matter->feeSheetId = 1;
        $matter->branchId = 1;
        $matter->incomeAccountId = 17;
        $matter->trustBankAccountId = 2;
        $matter->matterTypeId = 1;
        $matter->documentSetId = 1;

        $matter->save();

        //Client MatterParty
        $matterParty = new MatterParty;

        $matterParty->partyId = $party->id;
        $matterParty->matterId = $matter->id;
        $matterParty->roleId = 1;
        $matterParty->rank = 1;
        $matterParty->reference = '';

        $matterParty->save();

        $matterEmployee = new MatterEmployee;

        $matterEmployee->employeeId = 1;
        $matterEmployee->matterId = $matter->id;
        $matterEmployee->roleId = 1;
        $matterEmployee->rank = 1;

        $matterEmployee->save();

        //Add a contact Person
        $matterParty = new MatterParty;

        $matterParty->partyId = $rossId;
        $matterParty->matterId = $matter->id;
        $matterParty->roleId = 2;
        $matterParty->rank = 1;
        $matterParty->reference = '';

        $matterParty->save();

        // Add an branch
        $branch = new Branch;
        $branch->description = 'Cape Town';
        $branch->code = 'capeTown';
        $branch->save();

        // Add an branch
        $branch = new Branch;
        $branch->description = 'Johannesburg';
        $branch->code = 'johannesburg';
        $branch->save();

        // Add an branch
        $branch = new Branch;
        $branch->description = 'Durban';
        $branch->code = 'durban';
        $branch->save();

        $feeNote = new FeeNote;

        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Perusing documents';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;

        $feeNote->save();

        $feeNote = new FeeNote;

        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting agreement';
        $feeNote->taxRateId = 5;
        $feeNote->amount = 1000;
        $feeNote->taxAmount = 150;

        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 2;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 3;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Fee for persuing document';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 2;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 3;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 4;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Drafting long agreement';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 2;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 3;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 4;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = $faker->numberBetween(1, 5);
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = $faker->randomFloat(2, 0, 10000);
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        $feeNote = new FeeNote;
        $feeNote->matterId = 5;
        $feeNote->allocatedToId = $feeNote->createdById = 1;
        $feeNote->date = date('Y-m-d H:i:s');
        $feeNote->description = 'Telephonic Consultation (12 mins)';
        $feeNote->taxRateId = 5;
        $amount = 200;
        $taxAmount = $amount * 0.15;
        $feeNote->amount = $amount;
        $feeNote->taxAmount = $taxAmount;
        $feeNote->save();

        // **********************************************************
        // Disbursements
        // **********************************************************
/*
        $disbursement = new Disbursement;
        $disbursement->matterId = $faker->numberBetween(1,5);
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Service of Summons';
        $disbursement->taxRateId = 5;
        $disbursement->amount = 100;
        $disbursement->taxAmount = 15;
        $disbursement->save();

        $disbursement = new Disbursement;
        $disbursement->matterId = $faker->numberBetween(1,5);
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Tracing Fee';
        $disbursement->taxRateId = 5;
        $disbursement->amount = 1000;
        $disbursement->taxAmount = 150;
        $disbursement->save();

        $disbursement = new Disbursement;
        $disbursement->matterId = $faker->numberBetween(1,5);
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Advocate\'s Fee';
        $disbursement->taxRateId = 5;
        $disbursement->amount = 2000;
        $disbursement->taxAmount = 300;
        $disbursement->save();

        $disbursement = new Disbursement;
        $disbursement->matterId = $faker->numberBetween(1,5);
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Stationery Supplies';
        $disbursement->taxRateId = 5;
        $disbursement->amount = 345.99;
        $disbursement->taxAmount = 51.90;
        $disbursement->save();

        $disbursement = new Disbursement;
        $disbursement->matterId = $faker->numberBetween(1,5);
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Telephone Call';
        $disbursement->taxRateId = 5;
        $disbursement->amount = 300;
        $disbursement->taxAmount = 45;
        $disbursement->save();

        $disbursement = new Disbursement;
        $disbursement->matterId = $faker->numberBetween(1,5);
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Postage Stamps';
        $disbursement->taxRateId = 1;
        $disbursement->amount = 50;
        $disbursement->taxAmount = 0;
        $disbursement->save();

        $disbursement = new Disbursement;
        $disbursement->matterId = 5;
        $disbursement->createdById = 1;
        $disbursement->date = date("Y-m-d H:i:s");
        $disbursement->description = 'Revenue Stamp';
        $disbursement->taxRateId = 1;
        $disbursement->amount = 100;
        $disbursement->taxAmount = 0;
        $disbursement->save();
*/
    }
}
