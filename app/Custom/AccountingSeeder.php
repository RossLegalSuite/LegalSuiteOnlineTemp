<?php

namespace App\Custom;

use App\Models\Account;
use App\Models\Company;
use App\Models\TaxComponent;
use App\Models\TaxRate;
use App\Models\TaxRateComponent;

class AccountingSeeder
{
    protected $noTaxRate;

    protected $noTaxComponent;

    protected $oldTaxRate;

    protected $oldTaxComponent;

    protected $salesTaxRate;

    protected $purchasesTaxRate;

    protected $currentTaxComponent;

    protected $businessBankAccount;

    protected $trustBankAccount;

    protected $equityAccount;

    protected $retainedEarningsAccount;

    protected $incomeAccount;

    //protected $disbursementIncomeAccount;
    protected $interestReceivedAccount;

    protected $purchasesAccount;

    protected $accountsReceivableAccount;

    protected $disbursementsControlAccount;

    protected $accountsPayableAccount;

    protected $trustControlAccount;

    protected $salesTaxAccount;

    public function createCompany($request)
    {

        // AWS Regions
        // US East (Ohio) us-east-2
        // US East (N. Virginia)	us-east-1
        // US West (N. California)	us-west-1
        // US West (Oregon)	us-west-2
        // Africa (Cape Town)	af-south-1
        // Asia Pacific (Hong Kong)	ap-east-1
        // Asia Pacific (Mumbai)	ap-south-1
        // Asia Pacific (Osaka-Local)	ap-northeast-3
        // Asia Pacific (Seoul)	ap-northeast-2
        // Asia Pacific (Singapore)	ap-southeast-1
        // Asia Pacific (Sydney)	ap-southeast-2
        // Asia Pacific (Tokyo)	ap-northeast-1
        // Canada (Central)	ca-central-1
        // China (Beijing)	cn-north-1
        // China (Ningxia)	cn-northwest-1
        // Europe (Frankfurt)	eu-central-1
        // Europe (Ireland)	eu-west-1
        // Europe (London)	eu-west-2
        // Europe (Milan)	eu-south-1
        // Europe (Paris)	eu-west-3
        // Europe (Stockholm)	eu-north-1
        // Middle East (Bahrain)	me-south-1
        // South America (São Paulo)	sa-east-1

        $currencyCode = 'USD';
        $currencySymbol = '$';
        $taxAuthority = 'Tax Authorities';
        $salesTaxType = 'Gst';
        $paperSize = 'A4';
        $region = 'us-east-1';

        if ($request->company_country === 'ZA') {
            $currencyCode = 'ZAR';
            $currencySymbol = 'R';
            $taxAuthority = 'SARS';
            $region = 'af-south-1';
            $salesTaxType = 'Vat';
        } elseif ($request->company_country === 'GB') {
            $currencyCode = 'GBP';
            $currencySymbol = '£'; //Alt 0163
            $taxAuthority = 'HM Revenue & Customs';
            $region = 'eu-west-2';
            $salesTaxType = 'Vat';
        } elseif ($request->company_country === 'AU') {
            $currencyCode = 'AUD';
            $taxAuthority = 'Australian Taxation Office';
            $region = 'ap-southeast-2';
        } elseif ($request->company_country === 'NZ') {
            $currencyCode = 'NZD';
            $taxAuthority = 'Inland Revenue';
            $region = 'ap-southeast-2';
        } elseif ($request->company_country === 'CA') {
            $currencyCode = 'CAD';
            $taxAuthority = 'Canada Revenue Agency';
            $paperSize = 'Letter';
            $region = 'ca-central-1';
        } elseif ($request->company_country === 'US') {
            $currencyCode = 'USD';
            $taxAuthority = 'Internal Revenue Service';
            $paperSize = 'Letter';
        }

        Company::create([
            'name' => $request->company_name,
            'tradingName' => $request->company_trading_name,
            'countryCode' => $request->company_country,
            'timeZone' => $request->company_timezone,
            'currencyCode' => $currencyCode,
            'currencySymbol' => $currencySymbol,
            'paperSize' => $paperSize,
            'region' => $region,
            'dateFormat' => 'DD MMM YYYY',
            'smtpEncryption' => 'tls',
            'smtpAuthentication' => 'Yes',
            'smtpPort' => '587',
            'incomingEncryption' => 'ssl',
            'incomingPort' => '993',

            'businessBankAccountId' => $this->businessBankAccount->id,
            'trustBankAccountId' => $this->trustBankAccount->id,
            'salesTaxControlAccountId' => $this->salesTaxAccount->id,
            'creditorsControlAccountId' => $this->accountsPayableAccount->id,
            'trustControlAccountId' => $this->trustControlAccount->id,
            'debtorsControlAccountId' => $this->accountsReceivableAccount->id,
            'disbursementsControlAccountId' => $this->disbursementsControlAccount->id,
            'equityAccountId' => $this->equityAccount->id,
            'retainedEarningsAccountId' => $this->retainedEarningsAccount->id,
            'incomeAccountId' => $this->incomeAccount->id,
            //'disbursementIncomeAccountId' => $this->disbursementIncomeAccount->id,
            'interestReceivedAccountId' => $this->interestReceivedAccount->id,
            'purchasesAccountId' => $this->purchasesAccount->id,
            'noTaxRateId' => $this->noTaxRate->id,
            'salesTaxRateId' => $this->salesTaxRate->id,
            'purchasesTaxRateId' => $this->salesTaxRate->id,
            'taxAuthority' => $taxAuthority,
            'salesTaxType' => $salesTaxType,
            'assetsBackgroundColor' => '#ADF',
            'liabilitiesBackgroundColor' => '#FFD',
            'revenueBackgroundColor' => '#DFA',
            'expensesBackgroundColor' => '#FAA',
            'equityBackgroundColor' => '#FDA',
            'assetsTextColor' => '#222',
            'liabilitiesTextColor' => '#222',
            'revenueTextColor' => '#222',
            'expensesTextColor' => '#222',
            'equityTextColor' => '#222',
        ]);
    }

    // See: https://strategiccfo.com/standard-chart-of-accounts/

    // Assets - Account codes 1000-1990
    // Liabilities - 2000-2990
    // Equity - 3000-3990
    // Revenue - 4000-4990
    // Expenses - 5000-5990

    public function createAccounts($request)
    {

        /************************************/
        /*            ASSETS 1000 - 1999
        /************************************/
        $this->businessBankAccount = Account::create([
            'code' => '1000',
            'description' => 'Business Bank Account',
            'notes' => 'The bank account used for business-related activities',
            'category' => 'Assets',
            'type' => 'Business Bank',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        $this->trustBankAccount = Account::create([
            'code' => '1100',
            'description' => 'Trust Bank Account',
            'notes' => 'The bank account used to hold Clients\' deposits and retainers',
            'category' => 'Assets',
            'type' => 'Trust Bank',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        $this->accountsReceivableAccount = Account::create([
            'code' => '1200',
            'description' => 'Accounts Receivable (Debtors)',
            'notes' => 'Money owed to the company for goods and services rendered',
            'category' => 'Assets',
            'type' => 'Current Asset',
            'taxRateId' => $this->salesTaxRate->id,
        ]);

        $this->disbursementsControlAccount = Account::create([
            'code' => '1210',
            'description' => 'Disbursements Receivable',
            'notes' => 'Money owed to the company for expenses incurred on behalf of Clients. Note: Disbursements are basically short-term loans from your firm to the Client',
            'category' => 'Assets',
            'type' => 'Current Asset',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        Account::create([
            'code' => '1300',
            'description' => 'Supplies',
            'notes' => 'Items or resources that are expected to be used up within the financial year',
            'category' => 'Assets',
            'type' => 'Current Asset',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        Account::create([
            'code' => '1400',
            'description' => 'Property',
            'notes' => 'Land or buildings',
            'category' => 'Assets',
            'type' => 'Fixed Asset',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        Account::create([
            'code' => '1410',
            'description' => 'Equipment',
            'notes' => 'Equipment not intended to be sold within the financial year',
            'category' => 'Assets',
            'type' => 'Fixed Asset',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        Account::create([
            'code' => '1420',
            'description' => 'Vehicles',
            'notes' => 'Vehicles owned by the company',
            'category' => 'Assets',
            'type' => 'Fixed Asset',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        /************************************/
        /*         LIABILITIES 2000 - 2999
        /************************************/

        $this->trustControlAccount = Account::create([
            'code' => '2100',
            'description' => 'Trust Control Account',
            'notes' => 'The total of all monies held in trust',
            'category' => 'Liabilities',
            'type' => 'Current Liability',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        $this->accountsPayableAccount = Account::create([
            'code' => '2200',
            'description' => 'Accounts Payable (Creditors)',
            'notes' => 'Suppliers and vendors who are owed money for purchases, expenses and disbursements',
            'category' => 'Liabilities',
            'type' => 'Current Liability',
            'taxRateId' => $this->purchasesTaxRate->id,
        ]);

        Account::create([
            'code' => '2300',
            'description' => 'Current Liabilities',
            'notes' => 'Debts and obligations that are expected to be repaid within the financial year',
            'category' => 'Liabilities',
            'type' => 'Current Liability',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        if ($request->company_country === 'ZA' || $request->company_country === 'GB') {
            $taxAuthority = $request->company_country === 'ZA' ? 'SARS' : 'HM Revenue & Customs';

            $this->salesTaxAccount = Account::create([
                'code' => '2310',
                'description' => 'Vat Control Account',
                'notes' => 'The Vat owed to '.$taxAuthority,
                'category' => 'Liabilities',
                'type' => 'Current Liability',
                'taxRateId' => $this->noTaxRate->id,
            ]);
        } else {
            $this->salesTaxAccount = Account::create([
                'code' => '2310',
                'description' => 'Sales Tax Control Account',
                'notes' => 'The sales tax owed to the tax authorities',
                'category' => 'Liabilities',
                'type' => 'Current Liability',
                'taxRateId' => $this->noTaxRate->id,
            ]);
        }

        //https://strategiccfo.com/standard-chart-of-accounts/
        if ($request->company_country === 'US') {

        // 2200 ACCRUED COMPENSATION & RELATED ITEMS
        // 2210 Accrued – Payroll
        // 2220 Accrued – Commissions
        // 2230 Accrued – FICA
        // 2240 Accrued – Unemployment Taxes
        // 2250 Accrued – Workmen’s Comp
        // 2260 Accrued – Medical Benefits
        // 2270 Accrued – 401 K Company Match
        // 2275 W/H – FICA
        // 2280 W/H – Medical Benefits
        // 2285 W/H – 401 K Employee Contribution

        // 2300 OTHER ACCRUED EXPENSES
        // 2310 Accrued – Rent
        // 2320 Accrued – Interest
        // 2330 Accrued – Property Taxes
        // 2340 Accrued – Warranty Expense
        }

        Account::create([
            'code' => '2400',
            'description' => 'Long Term Liabilities',
            'notes' => 'Debts and obligations that are not expected to be repaid within the financial year',
            'category' => 'Liabilities',
            'type' => 'Long Term Liability',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        /************************************/
        /*         EQUITY 3000 - 3999
        /************************************/

        $this->equityAccount = Account::create([
            'code' => '3000',
            'description' => 'Owners Equity',
            'notes' => 'The funds used by the owners of the company to obtain the company\'s assets',
            'category' => 'Equity',
            'type' => 'Equity',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        $this->retainedEarningsAccount = Account::create([
            'code' => '3100',
            'description' => 'Retained Earnings',
            'notes' => 'The net income generated by the company in the financial year (less any dividends)',
            'category' => 'Equity',
            'type' => 'Equity',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        Account::create([
            'code' => '3200',
            'description' => 'Drawings',
            'notes' => 'Money withdrawn by the owners of the business',
            'category' => 'Equity',
            'type' => 'Equity',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        /************************************/
        /*         INCOME 4000 - 4999
        /************************************/

        $this->incomeAccount = Account::create([
            'code' => '4000',
            'description' => 'Income',
            'notes' => 'Revenue generated from services rendered',
            'category' => 'Revenue',
            'type' => 'Revenue',
            'taxRateId' => $this->salesTaxRate->id,
        ]);

        // $this->disbursementIncomeAccount = Account::create([
        //     'code' => '4100',
        //     'description' => 'Disbursement Income',
        //     'notes' => 'Reimbursable costs invoiced to the Client',
        //     'category' => 'Revenue',
        //     'type' => 'Revenue',
        //     'taxRateId' => $this->salesTaxRate->id,
        // ]);

        $this->interestReceivedAccount = Account::create([
            'code' => '4100',
            'description' => 'Interest Received',
            'notes' => 'Income generated from interest charged',
            'category' => 'Revenue',
            'type' => 'Revenue',
            'taxRateId' => $this->noTaxRate->id,
        ]);

        Account::create([
            'code' => '4200',
            'description' => 'Other Income',
            'notes' => 'Sundry income not generated from the sales of goods and services rendered',
            'category' => 'Revenue',
            'type' => 'Revenue',
            'taxRateId' => $this->salesTaxRate->id,
            'systemFlag' => 0,
        ]);

        /************************************/
        /*         EXPENSES 5000 - 5999
        /************************************/

        $this->purchasesAccount = Account::create([
            'code' => '5000',
            'description' => 'Purchases',
            'notes' => 'Payments for items or services used to generate sales and earn income',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
        ]);

        Account::create([
            'code' => '5010',
            'description' => 'Accounting',
            'notes' => 'Costs associated with accounting & bookkeeping',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,
        ]);

        Account::create([
            'code' => '5020',
            'description' => 'Advertising',
            'notes' => 'Costs associated with advertising & promotions',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5030',
            'description' => 'Bad Debts',
            'notes' => 'Unrecoverable debts or unpaid disbursements',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5040',
            'description' => 'Bank Charges',
            'notes' => 'Fees charged by the bank or credit card merchant',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5050',
            'description' => 'Commissions',
            'notes' => 'Payments to employees or third parties for work done',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5060',
            'description' => 'Courier Fees',
            'notes' => 'Cost of sending documents or items via courier',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5070',
            'description' => 'Depreciation',
            'notes' => 'The decrease in the value of assets due to use, wear and tear or obsolescence',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5080',
            'description' => 'Employee Benefits',
            'notes' => 'Perks offered to employees in addition to salary such as medical and disability contributions, life insurance, retirement benefits, paid time off and fringe benefits',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5090',
            'description' => 'Entertainment & Gifts',
            'notes' => 'Gifts or activities whose purpose was to actively conduct business',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5100',
            'description' => 'Insurance',
            'notes' => 'Insurance related expenses',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5110',
            'description' => 'Interest',
            'notes' => 'Interest paid on loans or other forms of credit',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5120',
            'description' => 'Internet, Software & Computers',
            'notes' => 'Costs associated with the internet, software or computers',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5130',
            'description' => 'Licenses',
            'notes' => 'Professional or commercial licence fees',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5140',
            'description' => 'Maintenance & Repairs',
            'notes' => 'Costs of maintaining or repairing fixed or current assets',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5150',
            'description' => 'Office Expenses',
            'notes' => 'General office expenses',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5160',
            'description' => 'Payroll Taxes',
            'notes' => 'Taxes paid on behalf of employees with regard to their salaries or wages',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5170',
            'description' => 'Printing, Copying & Scanning',
            'notes' => 'Document related costs',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5180',
            'description' => 'Postage & Petties',
            'notes' => 'Postages stamps & other costs relating to sending items via mail',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5190',
            'description' => 'Professional Fees & Services',
            'notes' => 'Fees paid to contractors for business related expenses',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5200',
            'description' => 'Rent',
            'notes' => 'Rent paid to landlord for business premises',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5210',
            'description' => 'Repairs & Maintenance',
            'notes' => 'Costs for repairs and maintenance to business premises or assets',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5220',
            'description' => 'Salaries & Wages',
            'note' => 'Staff salaries or casual wages',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5230',
            'description' => 'Sundry',
            'notes' => 'Small, incidental expenses that cannot be allocated to a nominal expense account',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5240',
            'description' => 'Subscriptions',
            'notes' => 'Subscriptions to apps, websites, software or other services',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5250',
            'description' => 'Supplies',
            'notes' => 'Consumable items used in the daily running of the business',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5260',
            'description' => 'Telephones',
            'notes' => 'Landline, mobile and fax costs',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,
        ]);

        Account::create([
            'code' => '5270',
            'description' => 'Travel',
            'notes' => 'Travel and accomodation expenses',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5280',
            'description' => 'Utilities',
            'notes' => 'Electricity, water, gas and other utilities',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,

        ]);

        Account::create([
            'code' => '5290',
            'description' => 'Vehicle Expenses',
            'notes' => 'Costs associated with running and maintaining vehicles owned by the business',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,
        ]);

        Account::create([
            'code' => '5900',
            'description' => 'Ask My Accountant',
            'notes' => 'Suspense account used for expenses that need to be allocated to the correct nominal account at a later date',
            'category' => 'Expenses',
            'type' => 'Expense',
            'taxRateId' => $this->purchasesTaxRate->id,
            'systemFlag' => 0,
        ]);
    }

    public function createSouthAfricanTaxRates()
    {

        // ******************************************************
        // No Vat
        // ******************************************************

        $this->noTaxRate = TaxRate::create([
            'description' => 'No Vat',
            'systemFlag' => true,
        ]);

        $this->noTaxComponent = TaxComponent::create([
            'description' => 'No Vat',
            'rate' => 0,
        ]);

        TaxRateComponent::create([
            'taxRateId' => $this->noTaxRate->id,
            'taxComponentId' => $this->noTaxComponent->id,
        ]);

        // ******************************************************
        // Zero Rated
        // ******************************************************

        $zeroTaxRate = TaxRate::create([
            'description' => 'Zero Rated',
            'systemFlag' => true,
        ]);

        TaxRateComponent::create([
            'taxRateId' => $zeroTaxRate->id,
            'taxComponentId' => $this->noTaxComponent->id,
        ]);

        // ******************************************************
        // Exempt
        // ******************************************************

        $exemptTaxRate = TaxRate::create([
            'description' => 'Exempt',
            'systemFlag' => true,
        ]);

        TaxRateComponent::create([
            'taxRateId' => $exemptTaxRate->id,
            'taxComponentId' => $this->noTaxComponent->id,
        ]);

        // ******************************************************
        // Old Tax Rate
        // ******************************************************

        $this->oldTaxRate = TaxRate::create([
            'description' => 'Vat (14%)',
            'rate' => 14,
        ]);

        $this->oldTaxComponent = TaxComponent::create([
            'description' => 'Vat',
            'rate' => 14,
        ]);

        TaxRateComponent::create([
            'taxRateId' => $this->oldTaxRate->id,
            'taxComponentId' => $this->oldTaxComponent->id,
        ]);

        // ******************************************************
        // Current Sales Tax Rate
        // ******************************************************

        $this->salesTaxRate = $this->purchasesTaxRate = TaxRate::create([
            'description' => 'Vat (15%)',
            'rate' => 15,
            'systemFlag' => true,
        ]);

        $currentTaxComponent = TaxComponent::create([
            'description' => 'Vat',
            'rate' => 15,
        ]);

        TaxRateComponent::create([
            'taxRateId' => $this->salesTaxRate->id,
            'taxComponentId' => $currentTaxComponent->id,
        ]);
    }
}
