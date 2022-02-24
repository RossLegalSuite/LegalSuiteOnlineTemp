<?php

namespace App\Custom;
use DB;
use Illuminate\Support\Str;
class MergeColumns {

    public static function AddPartyMergeColumns(&$query)
    {

        // Party Columns
        $query->addSelect( "parties.id as id")
        ->addSelect( "parties.code as code")
        ->addSelect( "parties.name as name")
        ->addSelect(DB::raw("CONCAT(parties.code, ' - ', parties.name) as fullDescription"))
        ->addSelect( DB::raw("CASE 
        WHEN party_entities.type = 'J' THEN parties.name 
        ELSE CONCAT(parties.firstName, ' ', parties.lastName) END
        as fullName" ))
        ->addSelect("parties.firstName as firstName")
        ->addSelect("parties.lastName as lastName")
        ->addSelect("parties.title as title")
        ->addSelect("parties.friendlyName as friendlyName")
        ->addSelect("parties.salutation as salutation")
        ->addSelect("parties.idNumber as idNumber")
        ->addSelect( DB::raw("CASE 
        WHEN parties.idType = 'I' THEN 'Identity Document'
        WHEN parties.idType = 'S' THEN 'Social Security'
        WHEN parties.idType = 'P' THEN 'Passport'
        WHEN parties.idType = 'D' THEN 'Drivers Licence'
        WHEN parties.idType = 'B' THEN 'Birth Certificate'
        WHEN parties.idType = 'T' THEN 'Temporary Residence'
        WHEN parties.idType = 'X' THEN 'Tax Certificate'
        WHEN parties.idType = 'A' THEN 'Armed Forces ID'
        WHEN parties.idType = 'O' THEN 'Other'
        ELSE parties.idType END as idTypeDescription"))
        ->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(parties.birthdate,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as birthDate"))
        ->addSelect("party_entities.code as entityCode")
        ->addSelect("party_entities.description as entityDescription")
        ->addSelect("party_types.code as typeCode")
        ->addSelect("party_types.description as typeDescription")
        ->addSelect("marriage_types.description as marriageDescription")
        ->addSelect("parties.physicalLine1 as physicalLine1")
        ->addSelect("parties.physicalLine2 as physicalLine2")
        ->addSelect("parties.physicalLine3 as physicalLine3")
        ->addSelect("parties.physicalCode as physicalCode")
        ->addSelect("physicalProvince.description as physicalProvince")
        ->addSelect("physicalCountry.description as physicalCountry")
        ->addSelect("parties.postalLine1 as postalLine1")
        ->addSelect("parties.postalLine2 as postalLine2")
        ->addSelect("parties.postalLine3 as postalLine3")
        ->addSelect("parties.postalCode as postalCode")
        ->addSelect("postalProvince.description as postalProvince")
        ->addSelect("postalCountry.description as postalCountry")
        ->addSelect(DB::raw("CASE WHEN parties.id IN (SELECT partyID FROM matter_parties WHERE roleId = " . session('clientRoleId') . ") THEN true ELSE false END as isClient") )
        ->addSelect( DB::raw("CASE WHEN emailAddress.description IS NOT NULL THEN emailAddress.description ELSE '' END as email" ))
        ->addSelect( DB::raw("CASE WHEN mobileNumber.description IS NOT NULL THEN mobileNumber.description ELSE '' END as mobile" ));

    }

    public static function AddMatterMergeColumns(&$query)
    {

        $query->addSelect("matters.id as id")
        ->addSelect("matters.fileRef as fileRef")
        ->addSelect("matters.description as description")
        ->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as fullDescription"))
        ->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(matters.instructed,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as dateInstructed") )
        ->addSelect( "client.code as clientCode")
        ->addSelect( "client.name as clientName")
        ->addSelect( "client.salutation as clientSalutation")
        ->addSelect(DB::raw("CONCAT(client.code, ' - ', client.name) as client"))
        ->addSelect("owner.name as employeeName")
        ->addSelect("owner.email as employeeEmail")
        ->addSelect("branches.code as branchCode")
        ->addSelect("branches.description as branchDescription")
        ->addSelect("fee_sheets.code as feeSheetCode")
        ->addSelect("fee_sheets.description as feeSheetDescription")
        ->addSelect("document_sets.code as documentSetCode")
        ->addSelect("document_sets.description as documentSetDescription")
        ->addSelect("matter_types.code as typeCode") 
        ->addSelect("matter_types.description as typeDescription");

    }

    public static function AddPartyAgingColumns(&$query, $request) 
    {
        $formatBegin = "FORMAT( ";
        $formatEnd = ", 2, 'en_" . session('countryCode')  . "')";

        $query->leftJoin('client_aging', 'parties.id', '=', 'client_aging.partyId');

        $query->addSelect( DB::raw("CASE WHEN client_aging.current IS NOT NULL THEN {$formatBegin}client_aging.current{$formatEnd} ELSE 0.00 END as current"))
        ->addSelect( DB::raw("CASE WHEN client_aging.days30 IS NOT NULL THEN {$formatBegin}client_aging.days30{$formatEnd} ELSE 0.00 END as days30"))
        ->addSelect( DB::raw("CASE WHEN client_aging.days60 IS NOT NULL THEN {$formatBegin}client_aging.days60{$formatEnd} ELSE 0.00 END as days60"))
        ->addSelect( DB::raw("CASE WHEN client_aging.days90 IS NOT NULL THEN {$formatBegin}client_aging.days90{$formatEnd} ELSE 0.00 END as days90"))
        ->addSelect( DB::raw("CASE WHEN client_aging.days120 IS NOT NULL THEN {$formatBegin}client_aging.days120{$formatEnd} ELSE 0.00 END as days120"))
        ->addSelect( DB::raw("CASE WHEN (client_aging.days30+client_aging.days60+client_aging.days90+client_aging.days120 > 0) THEN 1 ELSE 0 END AS isPastDue"))
        ->addSelect( DB::raw("{$formatBegin}client_aging.days30+client_aging.days60+client_aging.days90+client_aging.days120{$formatEnd} as pastDueAmount"))
        ->addSelect( DB::raw("CASE WHEN (client_aging.days90+client_aging.days120 > 0) THEN 1 ELSE 0 END AS isDelinquent"))
        ->addSelect( DB::raw("{$formatBegin}client_aging.days90+client_aging.days120{$formatEnd} as delinquentAmount"));

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$formatBegin}SUM(balance){$formatEnd} FROM client_business_balances 
            WHERE partyId = parties.id GROUP BY partyId), 0.00) as balance") );


        if ( $request->dataFormat !== 'mergeFields') {
            $query->addSelect( DB::raw("CASE WHEN client_aging.current IS NOT NULL THEN client_aging.current ELSE 0.00 END as currentRaw"))
            ->addSelect( DB::raw("CASE WHEN client_aging.days30 IS NOT NULL THEN client_aging.days30 ELSE 0.00 END as days30Raw"))
            ->addSelect( DB::raw("CASE WHEN client_aging.days60 IS NOT NULL THEN client_aging.days60 ELSE 0.00 END as days60Raw"))
            ->addSelect( DB::raw("CASE WHEN client_aging.days90 IS NOT NULL THEN client_aging.days90 ELSE 0.00 END as days90Raw"))
            ->addSelect( DB::raw("CASE WHEN client_aging.days120 IS NOT NULL THEN client_aging.days120 ELSE 0.00 END as days120Raw"))

            ->addSelect( DB::raw("client_aging.days30+client_aging.days60+client_aging.days90+client_aging.days120 as pastDueAmountRaw"))
            ->addSelect( DB::raw("client_aging.days90+client_aging.days120 as delinquentAmountRaw"))
    
            ->addSelect(DB::raw("IFNULL( 
                (SELECT SUM(balance) FROM client_business_balances 
                WHERE partyId = parties.id GROUP BY partyId), 0.00) as balanceRaw") );
        }


    }



}