<?php

use Illuminate\Database\Seeder;


class DocumentTemplateSeeder extends Seeder
{
    public function run()
    {
        DB::table('document_templates')->insert([
            'employeeId' => 1,
            'source' => 'Parties',
            'type' => 'Template',
            'title' => 'Party Letter',
            'description' => 'Example of a letter to a Party (or Parties)',
            'path' => 'acme/templates',
            'fileName' => 'Party Letter.docx',
            'docxFile' => 'https://ettorney-users.s3.af-south-1.amazonaws.com/acme/1/templates/MatterExample.docx',
            'pdfFile' => 'https://ettorney-users.s3.af-south-1.amazonaws.com/acme/1/templates/MatterExample.pdf',
        ]);
        
    }
}
