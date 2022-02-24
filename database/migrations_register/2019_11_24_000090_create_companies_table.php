<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCompaniesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('company', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->string('tradingName');
            $table->string('registrationNumber')->nullable();
            $table->string('website')->nullable();
            $table->string('logo')->nullable();
            $table->string('letterHeadPdfFile')->nullable();
            $table->string('letterHeadFileName')->nullable();
            $table->string('region');

            $table->string('bankAccountName')->nullable();
            $table->string('bankAccountNumber')->nullable();
            $table->string('bankAccountBranchName')->nullable();
            $table->string('bankAccountBranchCode')->nullable();
            $table->string('bankAccountType')->nullable();

            $table->string('physicalLine1')->nullable();
            $table->string('physicalLine2')->nullable();
            $table->string('physicalLine3')->nullable();
            $table->string('physicalCode')->nullable();

            $table->string('postalLine1')->nullable();
            $table->string('postalLine2')->nullable();
            $table->string('postalLine3')->nullable();
            $table->string('postalCode')->nullable();

            $table->string('smtpServer')->nullable();
            $table->string('smtpPort')->nullable();
            $table->enum('smtpEncryption', ['None', 'tls', 'ssl'])->default('None');
            $table->enum('smtpAuthentication', ['No', 'Yes'])->default('Yes');

            $table->string('incomingServer')->nullable();
            $table->string('incomingPort')->nullable();
            $table->string('incomingEncryption')->nullable();

            $table->string('dateFormat',50);
            $table->string('timeZone',10);
            $table->string('countryCode',10);
            $table->string('currencyCode',10);
            $table->string('currencySymbol',10);
            $table->string('paperSize',10)->default('A4');

            $table->unsignedInteger('yearEndDay')->default(31);
            $table->enum('yearEndMonth', ['January', 'February', 'March', 'April', 'May','June', 'July', 'August', 'September', 'October', 'November', 'December'])->default('December');

            $table->boolean('salesTaxFlag')->default(1);
            $table->enum('salesTaxType', ['Vat', 'Gst'])->default('Vat');
            $table->string('salesTaxNumber')->nullable();
            $table->string('taxAuthority')->default('Tax Authorities');
            $table->enum('salesTaxMethod', ['Cash', 'Accrual'])->default('Cash');
            $table->enum('salesTaxFrequency', ['Monthly', 'Bi-Monthly', 'Quarterly', '4-Monthly', 'Bi-Annually', 'Annually'])->default('Monthly');
            $table->enum('salesTaxStartMonth', ['January', 'February', 'March', 'April', 'May','June', 'July', 'August', 'September', 'October', 'November', 'December'])->default('January');

            $table->string('unpostedFeeTextColor')->default('#000');
            $table->string('unpostedFeeBackgroundColor')->default('#FFF');
            $table->string('postedFeeTextColor')->default('#000');
            $table->string('postedFeeBackgroundColor')->default('#FFF');
            $table->string('unpostedDisbursementTextColor')->default('#000');
            $table->string('unpostedDisbursementBackgroundColor')->default('#FFF');
            $table->string('postedDisbursementTextColor')->default('#000');
            $table->string('postedDisbursementBackgroundColor')->default('#FFF');

            $table->string('incompleteReminderTextColor')->default('#000');
            $table->string('incompleteReminderBackgroundColor')->default('#FFF');
            $table->string('completedReminderTextColor')->default('#000');
            $table->string('completedReminderBackgroundColor')->default('#FFF');

            $table->string('unpostedInvoiceTextColor')->default('#000');
            $table->string('unpostedInvoiceBackgroundColor')->default('#FFF');
            $table->string('postedInvoiceTextColor')->default('#000');
            $table->string('postedInvoiceBackgroundColor')->default('#FFF');

            $table->string('assetsBackgroundColor')->default('#FFF');
            $table->string('liabilitiesBackgroundColor')->default('#FFF');
            $table->string('revenueBackgroundColor')->default('#FFF');
            $table->string('expensesBackgroundColor')->default('#FFF');
            $table->string('equityBackgroundColor')->default('#FFF');

            $table->string('assetsTextColor')->default('#000');
            $table->string('liabilitiesTextColor')->default('#000');
            $table->string('revenueTextColor')->default('#000');
            $table->string('expensesTextColor')->default('#000');
            $table->string('equityTextColor')->default('#000');


            $table->unsignedInteger('noTaxRateId');
            $table->unsignedInteger('salesTaxRateId');
            $table->unsignedInteger('purchasesTaxRateId');

            $table->unsignedInteger('businessBankAccountId');
            $table->unsignedInteger('trustBankAccountId');

            $table->unsignedInteger('salesTaxControlAccountId');

            $table->unsignedInteger('trustControlAccountId');
            $table->unsignedInteger('creditorsControlAccountId');
            $table->unsignedInteger('debtorsControlAccountId');
            $table->unsignedInteger('disbursementsControlAccountId');

            $table->unsignedInteger('equityAccountId');
            $table->unsignedInteger('retainedEarningsAccountId');
            $table->unsignedInteger('incomeAccountId');
            //$table->unsignedInteger('disbursementIncomeAccountId');
            $table->unsignedInteger('interestReceivedAccountId');
            $table->unsignedInteger('purchasesAccountId');


            // Set foreign keys as well below
            $table->unsignedInteger('reportTemplateId')->nullable();
            $table->unsignedInteger('invoiceTemplateId')->nullable();
            $table->unsignedInteger('paymentTemplateId')->nullable();
            $table->unsignedInteger('statementTemplateId')->nullable();
            $table->unsignedInteger('creditNoteTemplateId')->nullable();
            $table->unsignedInteger('receiptTemplateId')->nullable();
            
            $table->unsignedInteger('documentEmailTemplateId')->nullable();
            $table->unsignedInteger('reportEmailTemplateId')->nullable();
            $table->unsignedInteger('partiesEmailTemplateId')->nullable();
            $table->unsignedInteger('invoiceEmailTemplateId')->nullable();
            $table->unsignedInteger('paymentEmailTemplateId')->nullable();
            $table->unsignedInteger('statementEmailTemplateId')->nullable();
            $table->unsignedInteger('creditNoteEmailTemplateId')->nullable();
            $table->unsignedInteger('receiptEmailTemplateId')->nullable();

            $table->unsignedInteger('trialBalanceTemplateId')->nullable();
            $table->unsignedInteger('incomeStatementTemplateId')->nullable();
            $table->unsignedInteger('balanceSheetTemplateId')->nullable();

            $table->timestamps();

            $table->foreign('reportTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('invoiceTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('statementTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('creditNoteTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('receiptTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('reportEmailTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('partiesEmailTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('invoiceEmailTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('statementEmailTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('creditNoteEmailTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('receiptEmailTemplateId')->references('id')->on('templates')->onDelete('restrict');

            $table->foreign('trialBalanceTemplateId')->references('id')->on('templates')->onDelete('restrict');
            $table->foreign('incomeStatementTemplateId')->references('id')->on('templates')->onDelete('restrict');
            $table->foreign('balanceSheetTemplateId')->references('id')->on('templates')->onDelete('restrict');


            $table->foreign('purchasesTaxRateId')->references('id')->on('tax_rates')->onDelete('restrict');

            $table->foreign('businessBankAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('trustBankAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('salesTaxControlAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('creditorsControlAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('debtorsControlAccountId')->references('id')->on('accounts')->onDelete('restrict');
            
            $table->foreign('disbursementsControlAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('equityAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('retainedEarningsAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('incomeAccountId')->references('id')->on('accounts')->onDelete('restrict');

            //$table->foreign('disbursementIncomeAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('interestReceivedAccountId')->references('id')->on('accounts')->onDelete('restrict');

            $table->foreign('purchasesAccountId')->references('id')->on('accounts')->onDelete('restrict');





        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('company');
    }
}
