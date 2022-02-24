<?php
/*
'host' => $returnData->smtpServer,
'port' => $returnData->smtpPort,
'encryption' => $returnData->smtpEncryption,
'username' => $returnData->smtpUserName,
'password' => $returnData->smtpPassword,
'from' => [
    'address' => env('MAIL_FROM_ADDRESS', 'hello@example.com'),
    'name' => env('MAIL_FROM_NAME', 'Example'),
],
*/

return [

    'driver' => 'smtp',
    'host' => 'smtp.bittex.co.za',
    'port' => '587',
    'encryption' => 'tls',
    'username' => 'ettorney@bittex.co.za',
    'password' => 'Bacon1024!!',
    'from' => [
        'address' => 'ettorney@bittex.co.za',
        'name' => 'Big Rick',
    ],



];
