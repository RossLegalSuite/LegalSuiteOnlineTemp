<?php

namespace App\Http\Controllers\App;

use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Custom\Utils;
use Illuminate\Support\Facades\DB;


class CompanyController extends Controller
{

/*  
    private function addColumns(&$query) {

        $query->addSelect("name as company-&gt;name");
        $query->addSelect("tradingName as company-&gt;tradingName");
        $query->addSelect("registrationNumber as company-&gt;registrationNumber");
        $query->addSelect("website as company-&gt;website");
        $query->addSelect("logo as company-&gt;logo");
        // $query->addSelect("letterHeadPdfFile as company-&gt;letterHeadPdfFile");
        // $query->addSelect("letterHeadPath as company-&gt;letterHeadPath");
        // $query->addSelect("letterHeadFileName as company-&gt;letterHeadFileName");
        $query->addSelect("bankAccountName as company-&gt;bankAccountName");
        $query->addSelect("bankAccountNumber as company-&gt;bankAccountNumber");
        $query->addSelect("bankAccountBranchName as company-&gt;bankAccountBranchName");
        $query->addSelect("bankAccountBranchCode as company-&gt;bankAccountBranchCode");
        $query->addSelect("bankAccountType as company-&gt;bankAccountType");
        $query->addSelect("physicalLine1 as company-&gt;physicalLine1");
        $query->addSelect("physicalLine2 as company-&gt;physicalLine2");
        $query->addSelect("physicalLine3 as company-&gt;physicalLine3");
        $query->addSelect("physicalCode as company-&gt;physicalCode");
        $query->addSelect("postalLine1 as company-&gt;postalLine1");
        $query->addSelect("postalLine2 as company-&gt;postalLine2");
        $query->addSelect("postalLine3 as company-&gt;postalLine3");
        $query->addSelect("postalCode as company-&gt;postalCode");

        $query->addSelect("unpostedFeeTextColor as company-&gt;unpostedFeeTextColor");
        $query->addSelect("unpostedFeeBackgroundColor as company-&gt;unpostedFeeBackgroundColor");
        $query->addSelect("postedFeeTextColor as company-&gt;postedFeeTextColor");
        $query->addSelect("postedFeeBackgroundColor as company-&gt;postedFeeBackgroundColor");
        $query->addSelect("unpostedDisbursementTextColor as company-&gt;unpostedDisbursementTextColor");
        $query->addSelect("unpostedDisbursementBackgroundColor as company-&gt;unpostedDisbursementBackgroundColor");
        $query->addSelect("postedDisbursementTextColor as company-&gt;postedDisbursementTextColor");
        $query->addSelect("postedDisbursementBackgroundColor as company-&gt;postedDisbursementBackgroundColor");

        $query->addSelect("incompleteReminderTextColor as company-&gt;incompleteReminderTextColor");
        $query->addSelect("incompleteReminderBackgroundColor as company-&gt;incompleteReminderBackgroundColor");
        $query->addSelect("completedReminderTextColor as company-&gt;completedReminderTextColor");
        $query->addSelect("completedReminderBackgroundColor as company-&gt;completedReminderBackgroundColor");

        $query->addSelect("unpostedInvoiceTextColor as company-&gt;unpostedInvoiceTextColor");
        $query->addSelect("unpostedInvoiceBackgroundColor as company-&gt;unpostedInvoiceBackgroundColor");
        $query->addSelect("postedInvoiceTextColor as company-&gt;postedInvoiceTextColor");
        $query->addSelect("postedInvoiceBackgroundColor as company-&gt;postedInvoiceBackgroundColor");

        $query->addSelect("assetsBackgroundColor as company-&gt;assetsBackgroundColor");
        $query->addSelect("liabilitiesBackgroundColor as company-&gt;liabilitiesBackgroundColor");
        $query->addSelect("revenueBackgroundColor as company-&gt;revenueBackgroundColor");
        $query->addSelect("expensesBackgroundColor as company-&gt;expensesBackgroundColor");
        $query->addSelect("equityBackgroundColor as company-&gt;equityBackgroundColor");

        $query->addSelect("assetsTextColor as company-&gt;assetsTextColor");
        $query->addSelect("liabilitiesTextColor as company-&gt;liabilitiesTextColor");
        $query->addSelect("revenueTextColor as company-&gt;revenueTextColor");
        $query->addSelect("expensesTextColor as company-&gt;expensesTextColor");
        $query->addSelect("equityTextColor as company-&gt;equityTextColor");



        $query->addSelect("dateFormat as company-&gt;dateFormat");
        $query->addSelect("timeZone as company-&gt;timeZone");
        $query->addSelect("countryCode as company-&gt;countryCode");
        $query->addSelect("currencyCode as company-&gt;currencyCode");
        $query->addSelect("currencySymbol as company-&gt;currencySymbol");
        $query->addSelect("paperSize as company-&gt;paperSize");
        $query->addSelect("region as company-&gt;region");
        $query->addSelect("salesTaxFlag as company-&gt;salesTaxFlag");
        $query->addSelect("salesTaxType as company-&gt;salesTaxType");
        $query->addSelect("salesTaxNumber as company-&gt;salesTaxNumber");
        $query->addSelect("taxAuthority as company-&gt;taxAuthority");
        $query->addSelect("salesTaxMethod as company-&gt;salesTaxMethod");
        $query->addSelect("salesTaxFrequency as company-&gt;salesTaxFrequency");
        $query->addSelect("salesTaxStartMonth as company-&gt;salesTaxStartMonth");
        $query->addSelect("noTaxRateId as company-&gt;noTaxRateId");
        $query->addSelect("salesTaxRateId as company-&gt;salesTaxRateId");
        $query->addSelect("purchasesTaxRateId as company-&gt;purchasesTaxRateId");
        $query->addSelect("businessBankAccountId as company-&gt;businessBankAccountId");
        $query->addSelect("trustBankAccountId as company-&gt;trustBankAccountId");
        $query->addSelect("salesTaxControlAccountId as company-&gt;salesTaxControlAccountId");
        $query->addSelect("trustControlAccountId as company-&gt;trustControlAccountId");
        $query->addSelect("creditorsControlAccountId as company-&gt;creditorsControlAccountId");
        $query->addSelect("debtorsControlAccountId as company-&gt;debtorsControlAccountId");
        $query->addSelect("disbursementsControlAccountId as company-&gt;disbursementsControlAccountId");
        $query->addSelect("equityAccountId as company-&gt;equityAccountId");
        $query->addSelect("retainedEarningsAccountId as company-&gt;retainedEarningsAccountId");
        $query->addSelect("incomeAccountId as company-&gt;incomeAccountId");
        $query->addSelect("interestReceivedAccountId as company-&gt;interestReceivedAccountId");
        $query->addSelect("purchasesAccountId as company-&gt;purchasesAccountId");
        $query->addSelect("yearEndDay as company-&gt;yearEndDay");
        $query->addSelect("yearEndMonth as company-&gt;yearEndMonth");
        $query->addSelect("reportTemplateId as company-&gt;reportTemplateId");
        $query->addSelect("invoiceTemplateId as company-&gt;invoiceTemplateId");
        $query->addSelect("paymentTemplateId as company-&gt;paymentTemplateId");
        $query->addSelect("statementTemplateId as company-&gt;statementTemplateId");
        $query->addSelect("creditNoteTemplateId as company-&gt;creditNoteTemplateId");
        $query->addSelect("receiptTemplateId as company-&gt;receiptTemplateId");
        $query->addSelect("reportEmailTemplateId as company-&gt;reportEmailTemplateId");
        $query->addSelect("invoiceEmailTemplateId as company-&gt;invoiceEmailTemplateId");
        $query->addSelect("paymentEmailTemplateId as company-&gt;paymentEmailTemplateId");
        $query->addSelect("statementEmailTemplateId as company-&gt;statementEmailTemplateId");
        $query->addSelect("creditNoteEmailTemplateId as company-&gt;creditNoteEmailTemplateId");
        $query->addSelect("receiptEmailTemplateId as company-&gt;receiptEmailTemplateId");

    }
*/
    public function get(Request $request)
    {
        
        // if ( $request->dataFormat === 'mergeArray' ) {
            
        //     $query = DB::table('company');

        //     $this->addColumns($query);

        //     return $query->get()->toArray();            

        // } else {

            $company = Company::first();

            session(['dateFormat' => $company->dateFormat]);

            return $company;

//        }
    } 

    public function storeLetterHead(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $record = Company::first();

            $record->letterHeadFileName = $request->letterHeadFileName;
            $record->letterHeadPdfFile = $request->letterHeadPdfFile;

            $record->save();

            return json_encode($record);
    
        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = $e->getMessage();

            return json_encode($returnData);            

        } catch(\Exception $e)  {

            $returnData->error = $e->getMessage();

            return json_encode($returnData);            

        }

    }

    public function storeLogo(Request $request)
    {

        $returnData = new \stdClass();

        try {

            $record = Company::first();

            $record->logo = $request->logo;

            session([
                'logo' => $record->logo,
            ]);


            $record->save();

            return json_encode($record);
    
        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = $e->getMessage();

            return json_encode($returnData);            

        } catch(\Exception $e)  {

            $returnData->error = $e->getMessage();

            return json_encode($returnData);            

        }

    }


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'tradingName' => 'required',
            'name' => 'required',
            'currencySymbol' => 'required',
            'timeZone' => 'required',
            'countryCode' => 'required',
            'currencyCode' => 'required',
            'paperSize' => 'required',
            'region' => 'required',
        ];


        $validator = Validator::make($request->all(), $rules); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            
        }        

        try {

            $record = Company::first();

            $record->name = $request->name;
            $record->tradingName = $request->tradingName;
            $record->registrationNumber = $request->registrationNumber;
            $record->website = $request->website;
            $record->salesTaxFlag = $request->salesTaxFlag;
            $record->salesTaxNumber = $request->salesTaxNumber;

            $record->postalLine1 = $request->postalLine1;
            $record->postalLine2 = $request->postalLine2;
            $record->postalLine3 = $request->postalLine3;
            $record->postalCode = $request->postalCode;

            $record->physicalLine1 = $request->physicalLine1;
            $record->physicalLine2 = $request->physicalLine2;
            $record->physicalLine3 = $request->physicalLine3;
            $record->physicalCode = $request->physicalCode;

            $record->smtpServer = $request->smtpServer;
            $record->smtpPort = $request->smtpPort;
            $record->smtpEncryption = $request->smtpEncryption;
            $record->smtpAuthentication = $request->smtpAuthentication;
            
            $record->incomingServer = $request->incomingServer;
            $record->incomingPort = $request->incomingPort;
            $record->incomingEncryption = $request->incomingEncryption;
            
            $record->unpostedFeeTextColor = $request->unpostedFeeBackgroundColor ? $request->unpostedFeeTextColor : '#000';
            $record->postedFeeTextColor = $request->postedFeeBackgroundColor ? $request->postedFeeTextColor : '#000';
            $record->unpostedDisbursementTextColor = $request->unpostedDisbursementBackgroundColor ? $request->unpostedDisbursementTextColor : '#000';
            $record->postedDisbursementTextColor = $request->postedDisbursementBackgroundColor ? $request->postedDisbursementTextColor : '#000';
            $record->incompleteReminderTextColor = $request->incompleteReminderBackgroundColor ? $request->incompleteReminderTextColor : '#000';
            $record->completedReminderTextColor = $request->completedReminderBackgroundColor ? $request->completedReminderTextColor : '#000';
            $record->unpostedInvoiceTextColor = $request->unpostedInvoiceBackgroundColor ? $request->unpostedInvoiceTextColor : '#000';
            $record->postedInvoiceTextColor = $request->postedInvoiceBackgroundColor ? $request->postedInvoiceTextColor : '#000';

            $record->assetsTextColor = $request->assetsBackgroundColor ? $request->assetsTextColor : '#000';
            $record->liabilitiesTextColor = $request->liabilitiesBackgroundColor ? $request->liabilitiesTextColor : '#000';
            $record->revenueTextColor = $request->revenueBackgroundColor ? $request->revenueTextColor : '#000';
            $record->expensesTextColor = $request->expensesBackgroundColor ? $request->expensesTextColor : '#000';
            $record->equityTextColor = $request->equityBackgroundColor ? $request->equityTextColor : '#000';

            $record->unpostedFeeBackgroundColor = $request->unpostedFeeBackgroundColor ? $request->unpostedFeeBackgroundColor : '#FFF';
            $record->postedFeeBackgroundColor = $request->postedFeeBackgroundColor ? $request->postedFeeBackgroundColor : '#FFF';
            $record->unpostedDisbursementBackgroundColor = $request->unpostedDisbursementBackgroundColor ? $request->unpostedDisbursementBackgroundColor : '#FFF';
            $record->postedDisbursementBackgroundColor = $request->postedDisbursementBackgroundColor ? $request->postedDisbursementBackgroundColor : '#FFF';
            $record->incompleteReminderBackgroundColor = $request->incompleteReminderBackgroundColor ? $request->incompleteReminderBackgroundColor : '#FFF';
            $record->completedReminderBackgroundColor = $request->completedReminderBackgroundColor ? $request->completedReminderBackgroundColor : '#FFF';
            $record->unpostedInvoiceBackgroundColor = $request->unpostedInvoiceBackgroundColor ? $request->unpostedInvoiceBackgroundColor : '#FFF';
            $record->postedInvoiceBackgroundColor = $request->postedInvoiceBackgroundColor ? $request->postedInvoiceBackgroundColor : '#FFF';

            $record->assetsBackgroundColor = $request->assetsBackgroundColor ? $request->assetsBackgroundColor : '#FFF';
            $record->liabilitiesBackgroundColor = $request->liabilitiesBackgroundColor ? $request->liabilitiesBackgroundColor : '#FFF';
            $record->revenueBackgroundColor = $request->revenueBackgroundColor ? $request->revenueBackgroundColor : '#FFF';
            $record->expensesBackgroundColor = $request->expensesBackgroundColor ? $request->expensesBackgroundColor : '#FFF';
            $record->equityBackgroundColor = $request->equityBackgroundColor ? $request->equityBackgroundColor : '#FFF';


            $record->dateFormat = $request->dateFormat;
            $record->currencySymbol = $request->currencySymbol;
            $record->timeZone = $request->timeZone;
            $record->countryCode = $request->countryCode;
            $record->currencyCode = $request->currencyCode;
            $record->paperSize = $request->paperSize;
            $record->region = $request->region;

            // Set the same in the LoginController
            session([
                'dateFormat' => $record->dateFormat,
                'currencySymbol' => $record->currencySymbol,
                'currencyCode' => $record->currencyCode,
                'countryCode' => $record->countryCode,
                'timeZone' => $record->timeZone,
                'paperSize' => $record->paperSize,
                'region' => $record->region,
                
            ]);
    

            $record->save();

            return json_encode($record);
    
        } catch (\Illuminate\Database\QueryException $e) {

            $validator->errors()->add('general', Utils::MySqlError($e));

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        } catch(\Exception $e)  {

            $validator->errors()->add('general', $e->getMessage());

            $returnData->errors = $validator->errors();
            return json_encode($returnData);

        }

    }

}