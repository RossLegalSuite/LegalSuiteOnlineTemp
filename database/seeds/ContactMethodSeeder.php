<?php

use Illuminate\Database\Seeder;


class ContactMethodSeeder extends Seeder
{

    public function run()
    {
        DB::table('contact_methods')->insert(['type' => 'Email', 'description' => 'Email', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Mobile', 'description' => 'Mobile', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Work', 'description' => 'Work', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Home', 'description' => 'Home', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Twitter', 'description' => 'Twitter', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'FaceBook', 'description' => 'FaceBook', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Google', 'description' => 'Google', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Instagram', 'description' => 'Instagram', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Whatsapp', 'description' => 'Whatsapp', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Fax', 'description' => 'Fax', 'created_at' => date("Y-m-d H:i:s")]);
        DB::table('contact_methods')->insert(['type' => 'Other', 'description' => 'Other', 'created_at' => date("Y-m-d H:i:s")]);

    }
}
