<?php

namespace App\Http\Controllers\QuickBooks;

use Illuminate\Http\Request;
use LifeOnScreen\LaravelQuickBooks\Resources\Customer;
use LifeOnScreen\LaravelQuickBooks\Resources\Account;



class CustomerController extends Controller
{

    protected $connection;
    private $customer = null;

    public function __construct()
    {

        $this->customer = new Customer;

    }


    public function createCustomer(Request $request)
    {

        $returnData = new \stdClass();

        $customerId = null;
        //$trustAccountId = null;

        
        // Added a Matter
        if ( isset($request->parentRef) && isset($request->fileRef) ) {

            $customerId =  $this->customer->create([
                'DisplayName'  => $request->fileRef . ' - ' . $request->description,
                'ParentRef'  => $request->parentRef,
                'Job' => true,
                'ResaleNum'  => $request->id,
                'Notes'  => 'FileRef: ' . $request->fileRef,
            ]);
            
        // Added a Client
        } else if (isset($request->code) ) {

            $customerId =  $this->customer->create([
                'DisplayName'  => $request->code . ' - ' . $request->name,
                'GivenName'  => $request->firstName,
                'FamilyName' => $request->lastName,
                'Title' => $request->title,
                'CompanyName' => $request->entityType === 'N' ? $request->name : '',
                'ResaleNum'  => $request->id,
                'Notes'  => 'Code: ' . $request->code,
            ]);

        }

        // $account = new Account;

        // // Added a Matter
        // if ( isset($request->parentId) && isset($request->trustAccountId)  ) {

        //     $trustAccountId =  $account->create([
        //         'Classification' => 'Liability',
        //         'AccountType'  => 'Other Current Liability',
        //         'AccountSubType' => 'TrustAccountsLiabilities',
        //         'Name' => $request->fileRef . ' - ' . $request->description,
        //         'ParentRef' => $request->trustAccountId,
        //     ]);

        // // Added a Client
        // } else if (isset($request->code) ) {

        //     $trustAccountId = $account->create([
        //         'Classification' => 'Liability',
        //         'AccountType'  => 'Other Current Liability',
        //         'AccountSubType' => 'TrustAccountsLiabilities',
        //         'Name' => $request->code . ' - ' . $request->name,
        //     ]);

        // }


        $returnData->id = $customerId;
        //$returnData->trustAccountId = $trustAccountId;
        return json_encode($returnData); 
    

    }


    public function fetchBalances(Request $request)
    {

        $account = new Account;

        return json_encode( $account->find($request->trustAccountId) );

    }

    
    public function get(Request $request)
    {

        /* 
        
        TINKERING EXAMPLE:
        ------------------
        $customer = new LifeOnScreen\LaravelQuickBooks\Resources\Customer;
        $whereClause = " WHERE Level = 0";        
        $records = $customer->query($whereClause);   

        $whereClause = " WHERE Active = true AND AccountSubType = 'TrustAccountsLiabilities'";        
        $whereClause = " WHERE AccountType LIKE 'Other Current Liability%'";     
        $whereClause = " WHERE Metadata.CreateTime > '2014-12-31'";     
        $records = $customer->query($whereClause);   
        $records = $customer->query(" WHERE Active = true");   
        $records = $customer->query(" WHERE ParentRef = null");   

        foreach ($records as $record) { echo $record['ParentRef']; }


        $connection = App::make(QuickBooksConnection::class);
        $dataService = $connection->getDataService();


        $oneQuery->whereClause = "FamilyName = '34'";
        $oneQuery->whereClause = "ParentRef = true";

        $oneQuery = new QuickBooksOnline\API\QueryFilter\QueryMessage();
        $oneQuery->sql = "SELECT";
        $oneQuery->entity = "Customer";
        $oneQuery->orderByClause = "FamilyName";
        $oneQuery->whereClause = ["Level = 0"];
        $oneQuery->startposition = "1";
        $oneQuery->maxresults = "4";
        $queryString = $oneQuery->getString();

        Returns: "SELECT * FROM Customer ORDERBY FamilyName STARTPOSITION 1 MAXRESULTS 1"

        $queryString = "SELECT * FROM Customer ORDERBY FamilyName STARTPOSITION 1 MAXRESULTS 1";
        $queryString = "SELECT * FROM Customer WHERE ParentRef.value = '99' STARTPOSITION 1 MAXRESULTS 1";
        $queryString = "SELECT * FROM Customer ORDERBY FamilyName WHERE Level = 0 STARTPOSITION 1 MAXRESULTS 4";

        $dataService->Query($queryString);

        */
        
        if ($request->id) {

            return json_encode( $this->customer->find($request->id) );

        } else {


            //$customers = [];

            if ($request->whereClause) {

                return $this->customer->query(" WHERE " . $request->whereClause);
    
            } else {
                
                return $this->customer->query();

            }


            // if ($request->whereClause) {

            //     //$whereClause = " WHERE Metadata.CreateTime > '2014-12-31'";
            //     $records =  $this->customer->query(" WHERE " . $request->whereClause);
    
            // } else {
                
            //     $records = $this->customer->query();

            // }

            // foreach ($records as $record) { 

            //     if ( $record->ParentRef === null) {
            //          //logger('$record->ParentRef',[$record->ParentRef]);
            //          array_push($customers, $record);
            //     }
                
            //  }

            
            //logger($customers);
            //return $customers;
           
        

        }        



    }


    // {
    //     "Customer": {
    //       "PrimaryEmailAddr": {
    //         "Address": "Surf@Intuit.com"
    //       }, 
    //       "SyncToken": "0", 
    //       "domain": "QBO", 
    //       "GivenName": "Bill", 
    //       "DisplayName": "Bill's Windsurf Shop", 
    //       "BillWithParent": false, 
    //       "FullyQualifiedName": "Bill's Windsurf Shop", 
    //       "CompanyName": "Bill's Windsurf Shop", 
    //       "FamilyName": "Lucchini", 
    //       "sparse": false, 
    //       "PrimaryPhone": {
    //         "FreeFormNumber": "(415) 444-6538"
    //       }, 
    //       "Active": true, 
    //       "Job": false, 
    //       "BalanceWithJobs": 85.0, 
    //       "BillAddr": {
    //         "City": "Half Moon Bay", 
    //         "Line1": "12 Ocean Dr.", 
    //         "PostalCode": "94213", 
    //         "Lat": "37.4307072", 
    //         "Long": "-122.4295234", 
    //         "CountrySubDivisionCode": "CA", 
    //         "Id": "3"
    //       }, 
    //       "PreferredDeliveryMethod": "Print", 
    //       "Taxable": false, 
    //       "PrintOnCheckName": "Bill's Windsurf Shop", 
    //       "Balance": 85.0, 
    //       "Id": "2", 
    //       "MetaData": {
    //         "CreateTime": "2014-09-11T16:49:28-07:00", 
    //         "LastUpdatedTime": "2014-09-18T12:56:01-07:00"
    //       }
    //     }, 
    //     "time": "2015-07-23T11:04:15.496-07:00"
    //   }

    // {
    //     "Account": {
    //       "FullyQualifiedName": "MyJobs", 
    //       "domain": "QBO", 
    //       "Name": "MyJobs", 
    //       "Classification": "Asset", 
    //       "AccountSubType": "AccountsReceivable", 
    //       "CurrencyRef": {
    //         "name": "United States Dollar", 
    //         "value": "USD"
    //       }, 
    //       "CurrentBalanceWithSubAccounts": 0, 
    //       "sparse": false, 
    //       "MetaData": {
    //         "CreateTime": "2014-12-31T09:29:05-08:00", 
    //         "LastUpdatedTime": "2014-12-31T09:29:05-08:00"
    //       }, 
    //       "AccountType": "Accounts Receivable", 
    //       "CurrentBalance": 0, 
    //       "Active": true, 
    //       "SyncToken": "0", 
    //       "Id": "94", 
    //       "SubAccount": false
    //     }, 
    //     "time": "2014-12-31T09:29:05.717-08:00"
    //   }
    // $party->firstName = $request->firstName;
    // $party->lastName = $request->lastName;
    // $party->title = $request->title;
    // $party->friendlyName = $request->friendlyName;
    // $party->salutation = $request->salutation;
    // $party->idNumber = $request->idNumber;
    // $party->idType = $request->idType;
    // $party->birthDate = $request->birthDate;
    // $party->marriageId = $request->marriageId;
    // $party->physicalLine1 = $request->physicalLine1;
    // $party->physicalLine2 = $request->physicalLine2;
    // $party->physicalLine3 = $request->physicalLine3;
    // $party->physicalCode = $request->physicalCode;




}