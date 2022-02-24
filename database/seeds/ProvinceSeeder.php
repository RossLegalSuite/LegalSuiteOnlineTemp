<?php

use Illuminate\Database\Seeder;


class ProvinceSeeder extends Seeder
{

    public function run()
    {

        $data = array(        

            array('countryCode' => 'ZA', 'code' => 'NL', 'description' => 'Kwazulu-Natal'),
            array('countryCode' => 'ZA', 'code' => 'GT', 'description' => 'Gauteng'),
            array('countryCode' => 'ZA', 'code' => 'FS', 'description' => 'Free State'),
            array('countryCode' => 'ZA', 'code' => 'EC', 'description' => 'Eastern Cape'),
            array('countryCode' => 'ZA', 'code' => 'LP', 'description' => 'Limpopo'),
            array('countryCode' => 'ZA', 'code' => 'MP', 'description' => 'Mpumalanga'),
            array('countryCode' => 'ZA', 'code' => 'NC', 'description' => 'Northern Cape'),
            array('countryCode' => 'ZA', 'code' => 'NW', 'description' => 'North-West'),
            array('countryCode' => 'ZA', 'code' => 'WC', 'description' => 'Western Cape'),


            array('countryCode' => 'US', 'code' => 'AL', 'description' => 'Alabama'),
            array('countryCode' => 'US', 'code' => 'AK', 'description' => 'Alaska'),
            array('countryCode' => 'US', 'code' => 'AZ', 'description' => 'Arizona'),
            array('countryCode' => 'US', 'code' => 'AR', 'description' => 'Arkansas'),
            array('countryCode' => 'US', 'code' => 'CA', 'description' => 'California'),
            array('countryCode' => 'US', 'code' => 'CO', 'description' => 'Colorado'),
            array('countryCode' => 'US', 'code' => 'CT', 'description' => 'Connecticut'),
            array('countryCode' => 'US', 'code' => 'DE', 'description' => 'Delaware'),
            array('countryCode' => 'US', 'code' => 'DC', 'description' => 'District Of Columbia'),
            array('countryCode' => 'US', 'code' => 'FL', 'description' => 'Florida'),
            array('countryCode' => 'US', 'code' => 'GA', 'description' => 'Georgia'),
            array('countryCode' => 'US', 'code' => 'HI', 'description' => 'Hawaii'),
            array('countryCode' => 'US', 'code' => 'ID', 'description' => 'Idaho'),
            array('countryCode' => 'US', 'code' => 'IL', 'description' => 'Illinois'),
            array('countryCode' => 'US', 'code' => 'IN', 'description' => 'Indiana'),
            array('countryCode' => 'US', 'code' => 'IA', 'description' => 'Iowa'),
            array('countryCode' => 'US', 'code' => 'KS', 'description' => 'Kansas'),
            array('countryCode' => 'US', 'code' => 'KY', 'description' => 'Kentucky'),
            array('countryCode' => 'US', 'code' => 'LA', 'description' => 'Louisiana'),
            array('countryCode' => 'US', 'code' => 'ME', 'description' => 'Maine'),
            array('countryCode' => 'US', 'code' => 'MD', 'description' => 'Maryland'),
            array('countryCode' => 'US', 'code' => 'MA', 'description' => 'Massachusetts'),
            array('countryCode' => 'US', 'code' => 'MI', 'description' => 'Michigan'),
            array('countryCode' => 'US', 'code' => 'MN', 'description' => 'Minnesota'),
            array('countryCode' => 'US', 'code' => 'MS', 'description' => 'Mississippi'),
            array('countryCode' => 'US', 'code' => 'MO', 'description' => 'Missouri'),
            array('countryCode' => 'US', 'code' => 'MT', 'description' => 'Montana'),
            array('countryCode' => 'US', 'code' => 'NE', 'description' => 'Nebraska'),
            array('countryCode' => 'US', 'code' => 'NV', 'description' => 'Nevada'),
            array('countryCode' => 'US', 'code' => 'NH', 'description' => 'New Hampshire'),
            array('countryCode' => 'US', 'code' => 'NJ', 'description' => 'New Jersey'),
            array('countryCode' => 'US', 'code' => 'NM', 'description' => 'New Mexico'),
            array('countryCode' => 'US', 'code' => 'NY', 'description' => 'New York'),
            array('countryCode' => 'US', 'code' => 'NC', 'description' => 'North Carolina'),
            array('countryCode' => 'US', 'code' => 'ND', 'description' => 'North Dakota'),
            array('countryCode' => 'US', 'code' => 'OH', 'description' => 'Ohio'),
            array('countryCode' => 'US', 'code' => 'OK', 'description' => 'Oklahoma'),
            array('countryCode' => 'US', 'code' => 'OR', 'description' => 'Oregon'),
            array('countryCode' => 'US', 'code' => 'PA', 'description' => 'Pennsylvania'),
            array('countryCode' => 'US', 'code' => 'RI', 'description' => 'Rhode Island'),
            array('countryCode' => 'US', 'code' => 'SC', 'description' => 'South Carolina'),
            array('countryCode' => 'US', 'code' => 'SD', 'description' => 'South Dakota'),
            array('countryCode' => 'US', 'code' => 'TN', 'description' => 'Tennessee'),
            array('countryCode' => 'US', 'code' => 'TX', 'description' => 'Texas'),
            array('countryCode' => 'US', 'code' => 'UT', 'description' => 'Utah'),
            array('countryCode' => 'US', 'code' => 'VT', 'description' => 'Vermont'),
            array('countryCode' => 'US', 'code' => 'VA', 'description' => 'Virginia'),
            array('countryCode' => 'US', 'code' => 'WA', 'description' => 'Washington'),
            array('countryCode' => 'US', 'code' => 'WV', 'description' => 'West Virginia'),
            array('countryCode' => 'US', 'code' => 'WI', 'description' => 'Wisconsin'),
            array('countryCode' => 'US', 'code' => 'WY', 'description' => 'Wyoming'),


            //Canada
            array('countryCode' => 'CA', 'code' => 'AB', 'description' => 'Alberta'),
            array('countryCode' => 'CA', 'code' => 'BC', 'description' => 'British Columbia'),
            array('countryCode' => 'CA', 'code' => 'MB', 'description' => 'Manitoba'),
            array('countryCode' => 'CA', 'code' => 'NB', 'description' => 'New Brunswick'),
            array('countryCode' => 'CA', 'code' => 'NL', 'description' => 'Newfoundland and Labrador'),
            array('countryCode' => 'CA', 'code' => 'NS', 'description' => 'Nova Scotia'),
            array('countryCode' => 'CA', 'code' => 'ON', 'description' => 'Ontario'),
            array('countryCode' => 'CA', 'code' => 'PE', 'description' => 'Prince Edward Island'),
            array('countryCode' => 'CA', 'code' => 'QC', 'description' => 'Quebec'),
            array('countryCode' => 'CA', 'code' => 'SK', 'description' => 'Saskatchewan'),
            array('countryCode' => 'CA', 'code' => 'NT', 'description' => 'Northwest Territories'),
            array('countryCode' => 'CA', 'code' => 'NU', 'description' => 'Nunavut'),
            array('countryCode' => 'CA', 'code' => 'YT', 'description' => 'Yukon'),

            // Other Countries
            array('countryCode' => 'AF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AX', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'DZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BB', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BJ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'BI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CV', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CX', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'HR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'DK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'DJ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'DM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'DO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'EC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'EG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SV', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GQ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ER', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'EE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ET', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'FK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'FO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'FJ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'FI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'FR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'DE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GP', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'HT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'HN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'HK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'HU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ID', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IQ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'IT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'JM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'JP', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'JE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'JO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'XK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LV', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LB', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MV', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ML', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MQ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'YT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MX', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'FM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ME', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NP', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KP', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MP', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'NO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'OM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'QA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'RE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'RO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'RU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'RW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'MF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'PM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'WS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ST', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'RS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SL', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SX', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SB', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'KR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SS', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ES', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'LK', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SD', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'CH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'SY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TW', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TJ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TO', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TT', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TR', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TC', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'TV', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VI', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'UG', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'UA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'AE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'GB', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'UY', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'UZ', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VU', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VA', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'VN', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'WF', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'EH', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'YE', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ZM', 'description' => 'n/a ', 'code' => 'NA'),
            array('countryCode' => 'ZW', 'description' => 'n/a ', 'code' => 'NA'),

        );

        DB::table('provinces')->insert($data);

    }
}
