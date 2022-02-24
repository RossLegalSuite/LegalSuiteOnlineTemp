<?php

use Illuminate\Database\Seeder;

class PartyRoleSeeder extends Seeder
{
    public function run()
    {

        
        DB::table('party_roles')->insert(['code' => 'client', 'plural' => 'clients', 'description' => 'Client']);
        DB::table('party_roles')->insert(['code' => 'contact', 'plural' => 'contacts', 'description' => 'Contact Person']);
        DB::table('party_roles')->insert(['code' => 'defendant', 'plural' => 'defendants', 'description' => 'Defendant']);
        DB::table('party_roles')->insert(['code' => 'plaintiff', 'plural' => 'plaintiffs', 'description' => 'Plaintiff']);
        DB::table('party_roles')->insert(['code' => 'applicant', 'plural' => 'applicants', 'description' => 'Applicant']);
        DB::table('party_roles')->insert(['code' => 'respondent', 'plural' => 'respondents', 'description' => 'Respondent']);
        DB::table('party_roles')->insert(['code' => 'mortgagor', 'plural' => 'mortgagors', 'description' => 'Mortgagor']);
        DB::table('party_roles')->insert(['code' => 'mortgagee', 'plural' => 'mortgagees', 'description' => 'Mortgagee']);
        DB::table('party_roles')->insert(['code' => 'buyer', 'plural' => 'buyers', 'description' => 'Buyer']);
        DB::table('party_roles')->insert(['code' => 'seller', 'plural' => 'sellers', 'description' => 'Seller']);
        DB::table('party_roles')->insert(['code' => 'opposing', 'plural' => 'opposings', 'description' => 'Opposing Attorney']);
        DB::table('party_roles')->insert(['code' => 'instructed', 'plural' => 'instructeds', 'description' => 'Instructed Attorney']);
        DB::table('party_roles')->insert(['code' => 'instructing', 'plural' => 'instructings', 'description' => 'Instructing Attorney']);
        DB::table('party_roles')->insert(['code' => 'deponent', 'plural' => 'deponents', 'description' => 'Deponent']);
        DB::table('party_roles')->insert(['code' => 'witness', 'plural' => 'witnesses', 'description' => 'Witness']);
        DB::table('party_roles')->insert(['code' => 'courtOfficial', 'plural' => 'courtOfficials', 'description' => 'Court Official']);
        DB::table('party_roles')->insert(['code' => 'investigatingOfficer', 'plural' => 'investigatingOfficers', 'description' => 'Investigating Officer']);
        DB::table('party_roles')->insert(['code' => 'socialWorker', 'plural' => 'socialWorkers', 'description' => 'Social Worker']);
        DB::table('party_roles')->insert(['code' => 'sheriff', 'plural' => 'sheriffs', 'description' => 'Sheriff']);
        DB::table('party_roles')->insert(['code' => 'principal', 'plural' => 'principals', 'description' => 'Principal']);
        DB::table('party_roles')->insert(['code' => 'estateAgent', 'plural' => 'estateAgents', 'description' => 'Estate Agent']);
        DB::table('party_roles')->insert(['code' => 'transferringAttorney', 'plural' => 'transferringAttorneys', 'description' => 'Transferring Attorney']);
        DB::table('party_roles')->insert(['code' => 'registeringAttorney', 'plural' => 'registeringAttorneys', 'description' => 'Registering Attorney']);
        DB::table('party_roles')->insert(['code' => 'existingBondholder', 'plural' => 'existingBondholders', 'description' => 'Existing Bondholder']);
        DB::table('party_roles')->insert(['code' => 'managingAgent', 'plural' => 'managingAgents', 'description' => 'Managing Agent']);
        DB::table('party_roles')->insert(['code' => 'insurer', 'plural' => 'insurers', 'description' => 'Insurer']);
        DB::table('party_roles')->insert(['code' => 'counsel', 'plural' => 'counsels', 'description' => 'Counsel']);
        DB::table('party_roles')->insert(['code' => 'advocate', 'plural' => 'advocates', 'description' => 'Advocate']);
        DB::table('party_roles')->insert(['code' => 'employer', 'plural' => 'employers', 'description' => 'Employer']);
        DB::table('party_roles')->insert(['code' => 'ourLodgingAgent', 'plural' => 'ourLodgingAgents', 'description' => 'Our Lodging Agent']);
        DB::table('party_roles')->insert(['code' => 'transferLodgingAgent', 'plural' => 'transferLodgingAgents', 'description' => 'Transfer Lodging Agent']);
        DB::table('party_roles')->insert(['code' => 'cancellationAttorney', 'plural' => 'cancellationAttorneys', 'description' => 'Cancellation Attorney']);
        DB::table('party_roles')->insert(['code' => 'cancellationLodgingAgent', 'plural' => 'cancellationLodgingAgents', 'description' => 'Cancellation Lodging Agent']);
        DB::table('party_roles')->insert(['code' => 'newBondHolder', 'plural' => 'newBondHolders', 'description' => 'New Bond Holder']);
        DB::table('party_roles')->insert(['code' => 'newBondAttorney', 'plural' => 'newBondAttorneys', 'description' => 'New Bond Attorney']);
        DB::table('party_roles')->insert(['code' => 'newBondLodgingAgent', 'plural' => 'newBondLodgingAgents', 'description' => 'New Bond Lodging Agent']);
        DB::table('party_roles')->insert(['code' => 'surety', 'plural' => 'sureties', 'description' => 'Surety']);
        DB::table('party_roles')->insert(['code' => 'receiverOfRevenue', 'plural' => 'receiverOfRevenues', 'description' => 'Receiver of Revenue']);
        DB::table('party_roles')->insert(['code' => 'localAuthority', 'plural' => 'localAuthorities', 'description' => 'Local Authority']);
        DB::table('party_roles')->insert(['code' => 'tracingAgent', 'plural' => 'tracingAgents', 'description' => 'Tracing Agent']);
        DB::table('party_roles')->insert(['code' => 'assessor', 'plural' => 'assessors', 'description' => 'Assessor']);
        DB::table('party_roles')->insert(['code' => 'lessor', 'plural' => 'lessors', 'description' => 'Lessor']);
        DB::table('party_roles')->insert(['code' => 'lessee', 'plural' => 'lessees', 'description' => 'Lessee']);
        DB::table('party_roles')->insert(['code' => 'cedent', 'plural' => 'cedents', 'description' => 'Cedent']);
        DB::table('party_roles')->insert(['code' => 'developer', 'plural' => 'developers', 'description' => 'Developer']);
        DB::table('party_roles')->insert(['code' => 'surveyorGeneral', 'plural' => 'surveyorGenerals', 'description' => 'Surveyor General']);
        DB::table('party_roles')->insert(['code' => 'garnishee', 'plural' => 'garnishees', 'description' => 'Garnishee']);
        DB::table('party_roles')->insert(['code' => 'deceased', 'plural' => 'deceaseds', 'description' => 'Deceased']);
        DB::table('party_roles')->insert(['code' => 'mortgageOriginator', 'plural' => 'mortgageOriginators', 'description' => 'Mortgage Originator']);
        DB::table('party_roles')->insert(['code' => 'registrar', 'plural' => 'registrars', 'description' => 'Registrar']);
        DB::table('party_roles')->insert(['code' => 'newspaper', 'plural' => 'newspapers', 'description' => 'Newspaper']);
        DB::table('party_roles')->insert(['code' => 'medicalPractitioner', 'plural' => 'medicalPractitioners', 'description' => 'Medical Practitioner']);
        DB::table('party_roles')->insert(['code' => 'listingEstateAgent', 'plural' => 'listingEstateAgents', 'description' => 'Listing Estate Agent']);
        DB::table('party_roles')->insert(['code' => 'sellingEstateAgency', 'plural' => 'sellingEstateAgencies', 'description' => 'Selling Estate Agency']);
        DB::table('party_roles')->insert(['code' => 'attorney', 'plural' => 'attorneys', 'description' => 'Attorney']);
        DB::table('party_roles')->insert(['code' => 'advertiser', 'plural' => 'advertisers', 'description' => 'Advertiser']);
        DB::table('party_roles')->insert(['code' => 'executor', 'plural' => 'executors', 'description' => 'Executor']);
        DB::table('party_roles')->insert(['code' => 'bondAttorney', 'plural' => 'bondAttorneys', 'description' => 'Bond Attorney']);
        DB::table('party_roles')->insert(['code' => 'bondLodgingAgent', 'plural' => 'bondLodgingAgents', 'description' => 'Bond Lodging Agent']);
        DB::table('party_roles')->insert(['code' => 'expert', 'plural' => 'experts', 'description' => 'Expert']);
        DB::table('party_roles')->insert(['code' => 'trustee', 'plural' => 'trustees', 'description' => 'Trustee']);
        DB::table('party_roles')->insert(['code' => 'director', 'plural' => 'directors', 'description' => 'Director']);
        DB::table('party_roles')->insert(['code' => 'member', 'plural' => 'members', 'description' => 'Member']);
        DB::table('party_roles')->insert(['code' => 'homeOwnersAssociation', 'plural' => 'homeOwnersAssociations', 'description' => 'Home Owners Association']);
        DB::table('party_roles')->insert(['code' => 'correspondent', 'plural' => 'correspondents', 'description' => 'Correspondent']);
        DB::table('party_roles')->insert(['code' => 'clerkOfCourt', 'plural' => 'clerkOfCourts', 'description' => 'Clerk of the Court']);
        DB::table('party_roles')->insert(['code' => 'minor', 'plural' => 'minors', 'description' => 'Minor']);
        DB::table('party_roles')->insert(['code' => 'familyAdvocate', 'plural' => 'familyAdvocates', 'description' => 'Family Advocate']);
        DB::table('party_roles')->insert(['code' => 'builder', 'plural' => 'builders', 'description' => 'Builder']);
        DB::table('party_roles')->insert(['code' => 'insolventParty', 'plural' => 'insolventPartys', 'description' => 'Insolvent Party']);
        DB::table('party_roles')->insert(['code' => 'signatory', 'plural' => 'signatories', 'description' => 'Signatory']);
        DB::table('party_roles')->insert(['code' => 'judge', 'plural' => 'judges', 'description' => 'Judge']);
        DB::table('party_roles')->insert(['code' => 'financialInstitution', 'plural' => 'financialInstitutions', 'description' => 'Financial Institution']);
        DB::table('party_roles')->insert(['code' => 'debtor', 'plural' => 'debtors', 'description' => 'Debtor']);
        DB::table('party_roles')->insert(['code' => 'creditor', 'plural' => 'creditors', 'description' => 'Creditor']);
        DB::table('party_roles')->insert(['code' => 'conveyancer', 'plural' => 'conveyancers', 'description' => 'Conveyancer']);
        DB::table('party_roles')->insert(['code' => 'donor', 'plural' => 'donors', 'description' => 'Donor']);
        DB::table('party_roles')->insert(['code' => 'partner', 'plural' => 'partners', 'description' => 'Partner']);
        DB::table('party_roles')->insert(['code' => 'shareBlockCompany', 'plural' => 'shareBlockCompanies', 'description' => 'Share Block Company']);
        DB::table('party_roles')->insert(['code' => 'shareholder', 'plural' => 'shareholders', 'description' => 'Shareholder']);
        DB::table('party_roles')->insert(['code' => 'beneficiary', 'plural' => 'beneficiaries', 'description' => 'Beneficiary']);
        DB::table('party_roles')->insert(['code' => 'legalRepresentative', 'plural' => 'legalRepresentatives', 'description' => 'Legal Representative']);
        DB::table('party_roles')->insert(['code' => 'other', 'plural' => 'others', 'description' => 'Other']);
        DB::table('party_roles')->insert(['code' => 'unknown', 'plural' => 'unknowns', 'description' => 'Unknown']);

    }
}
