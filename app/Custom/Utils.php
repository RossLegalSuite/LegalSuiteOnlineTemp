<?php

namespace App\Custom;


//use App\Models\Company;
//use App\Models\Employee;
use Carbon\Carbon;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Config;
use Maatwebsite\Excel\{Sheet, Writer};

class Utils
{

        /* TO DO 
        if ($request->where) $query->where( $request->where['column'], $request->where['value'] );
        
        if ($request->where2) $query->where( $request->where2['column'], $request->where2['value'] );

        if ($request->whereIn) $query->whereIn( $request->whereIn['column'], $request->whereIn['value'] );

        if ($request->whereNull) $query->whereNull( $request->whereNull );

        if ($request->whereRaw) $query->whereRaw($request->whereRaw);

        if ($request->tableFilter) $query->whereRaw($request->tableFilter);

        if ($request->tableHaving) $query->havingRaw($request->tableHaving);

        if ($request->whereClause) $query->whereRaw($request->whereClause);
        */




    public static function convertClarionDate($date)
    {

        /* Converts a date sent in an UNAMIGUOUS format (e.g. dd MMM yyyy or yyyy-mm-dd to a Clarion date */

        $thisDate = strtotime($date); // Get the unix date for the sent date (in seconds since 1 Jan 1970)

        $baseDate = mktime(0,0,0,1,1,1980); //Set a base date that UNIX can Handle (it cant go before 1/1/1902!!)

        $daysDiff = $thisDate - $baseDate; //Get the difference (in seconds)

        $clarionDays = (int)floor($daysDiff/86400); //Divide by (60*60*24) and round down to the whole number to give us the no of days since 1/1/1980
        
        $clarionDays += 65382; //Add the days since 1/1/1800 Clarions Base Date to give us the Clarion Date integer for $SentDate

        return($clarionDays);

    }



    public static function getCurlError($errNo) {


        $error_codes=array(
            '1' => 'CURLE_UNSUPPORTED_PROTOCOL',
            '2' => 'CURLE_FAILED_INIT',
            '3' => 'CURLE_URL_MALFORMAT',
            '4' => 'CURLE_URL_MALFORMAT_USER',
            '5' => 'CURLE_COULDNT_RESOLVE_PROXY',
            '6' => 'CURLE_COULDNT_RESOLVE_HOST',
            '7' => 'CURLE_COULDNT_CONNECT',
            '8' => 'CURLE_FTP_WEIRD_SERVER_REPLY',
            '9' => 'CURLE_REMOTE_ACCESS_DENIED',
            '11' => 'CURLE_FTP_WEIRD_PASS_REPLY',
            '13' => 'CURLE_FTP_WEIRD_PASV_REPLY',
            '14' => 'CURLE_FTP_WEIRD_227_FORMAT',
            '15' => 'CURLE_FTP_CANT_GET_HOST',
            '17' => 'CURLE_FTP_COULDNT_SET_TYPE',
            '18' => 'CURLE_PARTIAL_FILE',
            '19' => 'CURLE_FTP_COULDNT_RETR_FILE',
            '21' => 'CURLE_QUOTE_ERROR',
            '22' => 'CURLE_HTTP_RETURNED_ERROR',
            '23' => 'CURLE_WRITE_ERROR',
            '25' => 'CURLE_UPLOAD_FAILED',
            '26' => 'CURLE_READ_ERROR',
            '27' => 'CURLE_OUT_OF_MEMORY',
            '28' => 'CURLE_OPERATION_TIMEDOUT',
            '30' => 'CURLE_FTP_PORT_FAILED',
            '31' => 'CURLE_FTP_COULDNT_USE_REST',
            '33' => 'CURLE_RANGE_ERROR',
            '34' => 'CURLE_HTTP_POST_ERROR',
            '35' => 'CURLE_SSL_CONNECT_ERROR',
            '36' => 'CURLE_BAD_DOWNLOAD_RESUME',
            '37' => 'CURLE_FILE_COULDNT_READ_FILE',
            '38' => 'CURLE_LDAP_CANNOT_BIND',
            '39' => 'CURLE_LDAP_SEARCH_FAILED',
            '41' => 'CURLE_FUNCTION_NOT_FOUND',
            '42' => 'CURLE_ABORTED_BY_CALLBACK',
            '43' => 'CURLE_BAD_FUNCTION_ARGUMENT',
            '45' => 'CURLE_INTERFACE_FAILED',
            '47' => 'CURLE_TOO_MANY_REDIRECTS',
            '48' => 'CURLE_UNKNOWN_TELNET_OPTION',
            '49' => 'CURLE_TELNET_OPTION_SYNTAX',
            '51' => 'CURLE_PEER_FAILED_VERIFICATION',
            '52' => 'CURLE_GOT_NOTHING',
            '53' => 'CURLE_SSL_ENGINE_NOTFOUND',
            '54' => 'CURLE_SSL_ENGINE_SETFAILED',
            '55' => 'CURLE_SEND_ERROR',
            '56' => 'CURLE_RECV_ERROR',
            '58' => 'CURLE_SSL_CERTPROBLEM',
            '59' => 'CURLE_SSL_CIPHER',
            '60' => 'CURLE_SSL_CACERT',
            '61' => 'CURLE_BAD_CONTENT_ENCODING',
            '62' => 'CURLE_LDAP_INVALID_URL',
            '63' => 'CURLE_FILESIZE_EXCEEDED',
            '64' => 'CURLE_USE_SSL_FAILED',
            '65' => 'CURLE_SEND_FAIL_REWIND',
            '66' => 'CURLE_SSL_ENGINE_INITFAILED',
            '67' => 'CURLE_LOGIN_DENIED',
            '68' => 'CURLE_TFTP_NOTFOUND',
            '69' => 'CURLE_TFTP_PERM',
            '70' => 'CURLE_REMOTE_DISK_FULL',
            '71' => 'CURLE_TFTP_ILLEGAL',
            '72' => 'CURLE_TFTP_UNKNOWNID',
            '73' => 'CURLE_REMOTE_FILE_EXISTS',
            '74' => 'CURLE_TFTP_NOSUCHUSER',
            '75' => 'CURLE_CONV_FAILED',
            '76' => 'CURLE_CONV_REQD',
            '77' => 'CURLE_SSL_CACERT_BADFILE',
            '78' => 'CURLE_REMOTE_FILE_NOT_FOUND',
            '79' => 'CURLE_SSH',
            '80' => 'CURLE_SSL_SHUTDOWN_FAILED',
            '81' => 'CURLE_AGAIN',
            '82' => 'CURLE_SSL_CRL_BADFILE',
            '83' => 'CURLE_SSL_ISSUER_ERROR',
            '84' => 'CURLE_FTP_PRET_FAILED',
            '84' => 'CURLE_FTP_PRET_FAILED',
            '85' => 'CURLE_RTSP_CSEQ_ERROR',
            '86' => 'CURLE_RTSP_SESSION_ERROR',
            '87' => 'CURLE_FTP_BAD_FILE_LIST',
            '88' => 'CURLE_CHUNK_FAILED');
            return $error_codes[$errNo];

    }

    public static function SetCurlParams($apiUrl, $customRequest = 'GET', $postFields = [])
    {

        try {

            // Stripping out Char(13) e.g. in case a Where Clause is sent from a text area
            $apiUrl = str_replace("\n", "", $apiUrl);

            // if ($apiUrl == "/library/get" || $apiUrl == "/LolSystemTemplate/get") {
            //      logger('Util.php Curl Settings',[config('api.url') . $apiUrl,$customRequest,$postFields]);
            // }

            $curl = curl_init();

            //https://stackoverflow.com/questions/4344528/curlopt-postfields-has-a-length-or-size-limit

            curl_setopt_array($curl, array(
                CURLOPT_URL => config('api.url') . $apiUrl,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => '',
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 30000,
                CURLOPT_CONNECTTIMEOUT => 30000,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => $customRequest,
                CURLOPT_POSTFIELDS => $postFields,
                CURLOPT_HTTPHEADER => array(
                    'Authorization: Bearer ' . session('api_token'),
                    'Content-Type: application/x-www-form-urlencoded',
                    'Expect: 100-continue'
                ),
            ));

            $curlResponse = curl_exec($curl);

            if ( curl_errno($curl) ) {
            
                $response["errors"] = '<p>Could not connect to ' . config('api.url') . '</p><p>Curl Error No: ' . curl_errno($curl) . '</p><p>' . \App\Custom\Utils::getCurlError( curl_errno($curl) ) . '</p>'; 
                curl_close($curl); 
                return $response;

            } else {

                $response = json_decode( $curlResponse );

            }

            curl_close($curl);

            return $response;

        } catch(\Exception $e)  {

            throw new \Exception($e->getMessage());

        }

    }

    public static function SetExcelMacros()
    {

        //https://docs.laravel-excel.com/3.1/exports/extending.html

        Writer::macro('setCreator', function (Writer $writer, string $creator) {
            $writer->getDelegate()->getProperties()->setCreator($creator);
        });

        Writer::macro('setTitle', function (Writer $writer, string $title) {
            $writer->getDelegate()->getProperties()->setTitle($title);
        });

        Writer::macro('setCompany', function (Writer $writer, string $company) {
            $writer->getDelegate()->getProperties()->setCompany($company);
        });

        Sheet::macro('styleCells', function (Sheet $sheet, string $cellRange, array $style) {
            $sheet->getDelegate()->getStyle($cellRange)->applyFromArray($style);
        });
    }

    public static function DB()
    {

        return DB::connection('user');
        
    }


    public static function SetConnection($companyCode)
    {

        if(! defined('STDIN')) define('STDIN', fopen("php://stdin","r"));

        // 18 Oct 2020
        // Problem: env('DB_HOST') is null in General.php
        // logger("env('DB_HOST')",[env('DB_HOST')]);
        // Solution: https://stackoverflow.com/questions/34263107/get-environment-value-in-controller
        // Added values.php in the config folder

        $dbHost = Config::get('values.dbhost');


        $db = strtolower(preg_replace('/[^a-zA-Z0-9-_\.]/','', $companyCode));
        $user = $db . '_user';
        $password = $db . '_1024';

        config(['database.default' => 'user']);
        
        config(['database.connections.user' =>
        [
            'driver' =>     'mysql',
            "host" =>       $dbHost,
            "database" =>   $db,
            "port" =>       '3306',
            "username" =>   $user,
            "password" =>   $password,
            'charset' =>    'utf8mb4',
            'collation' =>  'utf8mb4_unicode_ci',
            'prefix' =>     '',
            'prefix_indexes' => true,
            'strict' => true,
            'engine' => null,
        ]]);

        //logger("User Connection')",config('database.connections.user'));

        $adminUser = $db . '_admin';
        $adminPassword = 'Bacon1024!!';

        // **********************************************
        //Create an admin connection to do the migrations
        // **********************************************

        config(['database.connections.admin' =>
        [
            'driver' =>     'mysql',
            "host" =>       $dbHost,
            "database" =>   $db,
            "port" =>       '3306',
            "username" =>   $adminUser,
            "password" =>   $adminPassword,
            'charset' =>    'utf8mb4',
            'collation' =>  'utf8mb4_unicode_ci',
            'prefix' =>     '',
            'prefix_indexes' => true,
            'strict' => true,
            'engine' => null,
        ]]);

        //logger("admin Connection')",config('database.connections.admin'));

    }


    public static function LogSqlQuery($query)
    {

        if (config('app.debug')) {

            $sqlQuery = str_replace_array('?', $query->getBindings(), $query->toSql());
            logger($sqlQuery);
        }
    }

    public static function getDisbursementsControlAccount($disbursementsControlAccountId, $disbursementId, $disbursementDescription)
    {

        $parentAccountId = $disbursementsControlAccountId;

        $parentAccount = \App\Models\Account::findOrFail($parentAccountId);

        $disbursementChildAccount = \App\Models\Account::where('parentId',$disbursementsControlAccountId)
        ->where('disbursementId', $disbursementId)
        ->first();

        if ( $disbursementChildAccount ) {

            return $disbursementChildAccount;

        } else {

            return \App\Models\Account::create([
                'parentId' => $parentAccount->id,
                'code' => $parentAccount->code . '-' . Utils::padNumber($disbursementId),
                'disbursementId' => $disbursementId,
                'description' => $disbursementDescription,
                'category' => $parentAccount->category,
                'type' => $parentAccount->type,
                'taxRateId' => $parentAccount->taxRateId,
                'notes' => 'Prepaid expense recoverable from the Client',
            ]);

        }

    }


    public static function padNumber($number)
    {

        if ($number < 10000) {

            return str_pad(strval($number), 5, '0', STR_PAD_LEFT);

        } else {

            return(strval($number));

        }

    }



    public static function generateCode($table, $description) {

        $description = preg_replace("/[^a-zA-Z0-9]/", "", $description);

        return Str::camel($description);

    }

    public static function generateCode_Deprecated($table, $description) {

        $description = preg_replace("/[^a-zA-Z0-9]/", "", $description);

        while ( strlen($description) < 4 ) { $description = $description . '_'; }

        $code = strtoupper(substr($description,0,4));

        $counter = DB::table($table)->where('code', 'like', $code . '%')->count();

        if ($counter) {

            //$counter++;
            
            while($counter <= 5000) {

                $existingRecord = DB::table($table)->where('code',$code . $counter)->first();

                if (!$existingRecord) break;

                $counter++;
                
            }

            return $code . $counter;

        } else {

            return $code;

        }


    }


    public static function isWritable($path) {

        
        if (file_exists($path)) {
            if (!($f = @fopen($path, 'r+')))  return false;
            fclose($f);
            return true;
        }
        
        if (!($f = @fopen($path, 'w'))) return false;

        fclose($f);

        unlink($path);

        return true;

    }

    public static function sqlDateFormat()
    {

        //https://www.w3schools.com/sql/func_mysql_date_format.asp
        

        if ( session('dateFormat') === 'DD MMM YYYY') {

            return '%d %b %Y';

        } else if ( session('dateFormat') === 'DD-MM-YYYY') {   

            return '%d-%m-%Y';

        } else if ( session('dateFormat') === 'DD/MM/YYYY') {

            return '%d/%m/%Y';

        } else if ( session('dateFormat') === 'MM-DD-YYYY') {   

            return '%m-%d-%Y';

        } else if ( session('dateFormat') === 'MM/DD/YYYY') {   

            return '%m/%d/%Y';

        } else if ( session('dateFormat') === 'YYYY-MM-DD') {   

            return '%Y-%m-%d';

        } else if ( session('dateFormat') === 'YYYY/MM/DD') {   

            return '%Y/%m/%d';

        } else {   

            return '%m-%d-%Y';

        }

    }

    public static function sqlDateTimeFormat()
    {

        return Utils::sqlDateFormat() . ' %H:%i:%s';

    }

    public static function convertDate($date)
    {

        //https://stackoverflow.com/questions/2891937/strtotime-doesnt-work-with-dd-mm-yyyy-format
        

        if ( session('dateFormat') === 'DD/MM/YYYY') {

            $date = str_replace('/', '-', $date);

        } else if ( session('dateFormat') === 'MM-DD-YYYY') {   

            $date = str_replace('-', '/', $date);
        }


        return date('Y-m-d', strtotime( $date ));


    }

    public static function convertDateTime($date)
    {

        //https://stackoverflow.com/questions/2891937/strtotime-doesnt-work-with-dd-mm-yyyy-format
        

        if ( session('dateFormat') === 'DD/MM/YYYY') {

            $date = str_replace('/', '-', $date);

        } else if ( session('dateFormat') === 'MM-DD-YYYY') {   

            $date = str_replace('-', '/', $date);
        }

        $utcDate = Carbon::parse($date, session('timeZone') )->setTimezone('UTC');

        return date('Y-m-d H:i:s', strtotime( $utcDate ));

    }


    public static function MySqlError($e, $recordInUse = 'another record')
    {

        $message = explode(' ', $e->getMessage());
        $dbCode = rtrim($message[3], ']');
        $dbCode = trim($dbCode, '[');

        if (!is_numeric($dbCode)) {
            $dbCode = rtrim($message[4], ']');
            $dbCode = trim($dbCode, '[');
        }

        if (!is_numeric($dbCode)) {
            $dbCode = rtrim($message[5], ']');
            $dbCode = trim($dbCode, '[');
        }

        if (!is_numeric($dbCode)) {
            $dbCode = rtrim($message[6], ']');
            $dbCode = trim($dbCode, '[');
        }

        //logger('MySql error',[$e->getMessage()]);
        //logger('MySql error ARRAY',[$message]);
        //logger('$dbCode',[$dbCode]);

        switch ($dbCode)
        {
            case 1396:
                $userMessage = 'Cannot create user.';
                break;
            case 1007:
                $userMessage = 'Cannot create database - Database already exists.';
                break;
            case 1451:
                $userMessage = 'It is being referenced in another table.';
                break;
            case 1062:
                $userMessage = 'Duplicate entry.';
                break;
            case 1049:
                $userMessage = 'Unknown database.';
                break;
            case 1217:
                $userMessage = 'Access denied: The record is being referenced by another table in the program.';
                break;
            case 1264:
                $userMessage = 'Invalid data: The data provided is out of range or exceeds the maximum size allowed.';
                break;
            case 2002:
                $userMessage = 'Database is unavailable.';
                break;
            default:
                $userMessage = $e->getMessage();
                break;
        }

        return $userMessage;

    }
    
}



