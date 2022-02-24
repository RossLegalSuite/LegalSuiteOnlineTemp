<?php

use Illuminate\Database\Seeder;


class TemplateFieldSeeder extends Seeder
{

    public function run()
    {

        $data = array(

           


            array('title' => 'Company Letterhead', 'contents' => '<component is="letterhead"></component>', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party\'s Postal Address', 'contents' => '<component is="partyPostal"></component>', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party\'s Physical Address', 'contents' => '<component is="partyPhysical"></component>', 'created_at' => date("Y-m-d H:i:s")),


            array('title' => 'Matter File Reference', 'contents' => '{{matter.fileRef}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Description', 'contents' => '{{matter.description}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Date Instructed', 'contents' => '{{matter.instructed}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Client Ref', 'contents' => '{{matter.theirRef}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Client Code', 'contents' => '{{matter.clientCode}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Client Name', 'contents' => '{{matter.clientName}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Full Description', 'contents' => '{{matter.matter}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Client', 'contents' => '{{matter.client}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Employee', 'contents' => '{{matter.employeeName}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Branch', 'contents' => '{{matter.branchDescription}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Document Set', 'contents' => '{{matter.documentSetDescription}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Matter Type', 'contents' => '{{matter.matterTypeDescription}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Total Debits', 'contents' => '{{matter.debits}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Total Credits', 'contents' => '{{matter.credits}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Trust Credits', 'contents' => '{{matter.trustCredits}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Business Credits', 'contents' => '{{matter.businessCredits}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Unposted Fees', 'contents' => '{{matter.unpostedFees}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Unposted Disbursements', 'contents' => '{{matter.unpostedDisbursements}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Unposted Tax', 'contents' => '{{matter.unpostedTax}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Unposted Total', 'contents' => '{{matter.unpostedTotal}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Posted Fees', 'contents' => '{{matter.postedFees}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Posted Disbursements', 'contents' => '{{matter.postedDisbursements}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Posted Tax', 'contents' => '{{matter.postedTax}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Matter Posted Total', 'contents' => '{{matter.postedTotal}}', 'created_at' => date("Y-m-d H:i:s")),

            
            array('title' => 'Party Code', 'contents' => '{{party.code}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Full Name', 'contents' => '{{party.name}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party First Name', 'contents' => '{{party.firstName}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Last Name', 'contents' => '{{party.lastName}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Title', 'contents' => '{{party.title}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Friendly Name', 'contents' => '{{party.friendlyName}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Salutation', 'contents' => '{{party.salutation}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party ID Number', 'contents' => '{{party.idNumber}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party ID Ttype', 'contents' => '{{party.id_type}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Birth / Registration Date', 'contents' => '{{party.birthDate}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Line1', 'contents' => '{{party.physicalLine1}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Line2', 'contents' => '{{party.physicalLine2}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Line3', 'contents' => '{{party.physicalLine3}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Postal Code', 'contents' => '{{party.physicalCode}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Postal Line1', 'contents' => '{{party.postalLine1}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Postal Line2', 'contents' => '{{party.postalLine2}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Postal Line3', 'contents' => '{{party.postalLine3}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Postal Postal Code', 'contents' => '{{party.postalCode}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Vat Vendor', 'contents' => '{{party.vatVendor}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Vat Number', 'contents' => '{{party.vatNumber}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Entity', 'contents' => '{{party.entity}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Type', 'contents' => '{{party.type}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Marriage Code', 'contents' => '{{party.marriageCode}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Marriage Description', 'contents' => '{{party.marriage}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Province Code', 'contents' => '{{party.physicalProvince}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Province', 'contents' => '{{party.physicalProvince}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Physical Country', 'contents' => '{{party.physicalCountry}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Postal Province', 'contents' => '{{party.postalProvince}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Party Postal Country', 'contents' => '{{party.postalCountry}}', 'created_at' => date("Y-m-d H:i:s")),


            array('title' => 'Invoice Number', 'contents' => '{{invoice.number}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Date', 'contents' => '{{invoice.date}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Date Due', 'contents' => '{{invoice.dueDate}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Posted', 'contents' => '{{invoice.posted}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Matter', 'contents' => '{{invoice.matter}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Client', 'contents' => '{{invoice.party}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Fees', 'contents' => '{{invoice.fees}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Disbursements', 'contents' => '{{invoice.disbursements}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Tax', 'contents' => '{{invoice.tax}}', 'created_at' => date("Y-m-d H:i:s")),
            array('title' => 'Invoice Total', 'contents' => '{{invoice.total}}', 'created_at' => date("Y-m-d H:i:s")),


        );

        DB::table('template_fields')->insert($data);       
        
    }
}
