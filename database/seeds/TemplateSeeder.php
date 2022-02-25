<?php

use App\Models\Company;
use App\Models\Template;
use Illuminate\Database\Seeder;

class TemplateSeeder extends Seeder
{
    public function run()
    {
        $company = Company::first();
        $templatePath = base_path().'/resources/js/pages/templates/default/';

        $contents = file_get_contents($templatePath.'report.html');
        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Report';
        $template->description = 'Layout used when printing a table report';
        $template->source = 'Report';
        $template->orientation = 'Landscape';
        $template->contents = $contents;

        $template->save();
        $company->reportTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'trialBalance.html');
        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Trial Balance';
        $template->description = 'The layout of the trial balance report';
        $template->source = 'Accounts';
        $template->contents = $contents;

        $template->save();
        $company->trialBalanceTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'incomeStatement.html');
        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Income Statement';
        $template->description = 'The layout of the income statement report';
        $template->source = 'Accounts';
        $template->contents = $contents;

        $template->save();
        $company->incomeStatementTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'balanceSheet.html');
        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Balance Sheet';
        $template->description = 'The layout of the balance sheet report';
        $template->source = 'Accounts';
        $template->contents = $contents;

        $template->save();
        $company->balanceSheetTemplateId = $template->id;

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Report Email';
        $template->description = 'Email message when sending a report as an attachment';
        $template->source = 'Report';
        $template->contents = file_get_contents($templatePath.'reportEmail.html');

        $template->save();

        $company->reportEmailTemplateId = $template->id;

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Parties Email';
        $template->description = 'Email message when sending an email to multiple Parties';
        $template->source = 'Parties';
        $template->contents = file_get_contents($templatePath.'partiesEmail.html');

        $template->save();

        $company->partiesEmailTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'documentEmail.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Document Attachment Email';
        $template->description = 'Email message when sending a document as an attachment';
        $template->source = 'Documents';
        $template->contents = $contents;

        $template->save();

        $company->documentEmailTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'letter.html');
        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Letter Example';
        $template->description = 'Example of a letter to a Party';
        $template->source = 'Party';
        $template->contents = $contents;

        $template->save();

        /*  19 April 2021 - Reports are now done as Word Templates

                $contents = file_get_contents($templatePath . 'parties.html');
                $template = new Template;
                $template->employeeId = 1;
                $template->password = time();
                $template->title = 'List Example 1';
                $template->description = 'Parties and their contact details';
                $template->source = 'Parties';
                $template->contents = $contents;

                $template->save();

                $contents = file_get_contents($templatePath . 'matters.html');
                $template = new Template;
                $template->employeeId = 1;
                $template->password = time();
                $template->title = 'List Example 2';
                $template->description = 'Matters with their Trust Account balances';
                $template->source = 'Matters';
                $template->contents = $contents;

                $template->save();

        */
        $contents = file_get_contents($templatePath.'invoice.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Invoice';
        $template->description = 'Invoice, Proforma and/or Quotation';
        $template->source = 'Invoice';
        $template->contents = $contents;
        $template->footer = '<hr><component class="text-center" is="bankDetailsLine"></component>';
        $template->bottomMargin = '20';

        $template->save();

        $company->invoiceTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'invoiceEmail.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Invoice Email';
        $template->description = 'Email message when sending an invoice to a Client as an attachment';
        $template->source = 'Invoice';
        $template->contents = $contents;

        $template->save();

        $company->invoiceEmailTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'payment.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Payment';
        $template->description = 'Payment details';
        $template->source = 'Payment';
        $template->contents = $contents;

        $template->save();

        $company->paymentTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'paymentEmail.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Payment Email';
        $template->description = 'Email message when sending a payment to a Creditor as an attachment';
        $template->source = 'Payment';
        $template->contents = $contents;

        $template->save();

        $company->paymentEmailTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'receipt.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Receipt';
        $template->description = 'Client Receipt';
        $template->source = 'Receipt';
        $template->contents = $contents;

        $template->save();

        $company->receiptTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'receiptEmail.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Receipt Email';
        $template->description = 'Email message when sending a receipt as an attachment';
        $template->source = 'Receipt';
        $template->contents = $contents;

        $template->save();

        $company->receiptEmailTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'statementEmail.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Statement Email';
        $template->description = 'Email message when sending a statement as an attachment';
        $template->source = 'Statement';
        $template->contents = $contents;

        $template->save();

        $company->statementEmailTemplateId = $template->id;

        $contents = file_get_contents($templatePath.'statement.html');

        $template = new Template;
        $template->employeeId = 1;
        $template->password = time();
        $template->title = 'Statement';
        $template->description = 'Client Statement';
        $template->source = 'Statement';
        $template->contents = $contents;
        $template->footer = '<hr><component class="text-center" is="bankDetailsLine"></component>';
        $template->bottomMargin = '20';

        $template->save();

        $company->statementTemplateId = $template->id;

        $company->save();
    }
}
