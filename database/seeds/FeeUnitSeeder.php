<?php

use Illuminate\Database\Seeder;


class FeeUnitSeeder extends Seeder
{

    public function run()
    {
        DB::table('fee_units')->insert(['code' => 'page', 'description' => 'Page', 'singular' => 'page', 'plural' => 'pages', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'folio', 'description' => 'Folio', 'singular' => 'folio', 'plural' => 'folios', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'letter', 'description' => 'Letter', 'singular' => 'letter', 'plural' => 'letters', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'document', 'description' => 'Document', 'singular' => 'document', 'plural' => 'documents', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'attachment', 'description' => 'Attachment', 'singular' => 'attachment', 'plural' => 'attachments', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'emailMessage', 'description' => 'Email Message', 'singular' => 'email message', 'plural' => 'email messages', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'message', 'description' => 'Message', 'singular' => 'message', 'plural' => 'messages', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'km', 'description' => 'Kilometre', 'singular' => 'kilometre', 'plural' => 'kilometres', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'mile', 'description' => 'Mile', 'singular' => 'mile', 'plural' => 'miles', 'timeBasedFlag' => 0 ]);
        DB::table('fee_units')->insert(['code' => 'minute', 'description' => 'Minute', 'singular' => 'minute', 'plural' => 'minutes', 'timeBasedFlag' => 1, 'minutesPerUnit' => 1]);
        DB::table('fee_units')->insert(['code' => 'hour', 'description' => 'Hour', 'singular' => 'hour', 'plural' => 'hours', 'timeBasedFlag' => 1, 'minutesPerUnit' => 60]);
        DB::table('fee_units')->insert(['code' => 'fiveMinutes', 'description' => 'Five Minutes', 'singular' => 'five minute', 'plural' => 'five minutes', 'timeBasedFlag' => 1, 'minutesPerUnit' => 15]);
        DB::table('fee_units')->insert(['code' => 'fifteenMinutes', 'description' => 'Fifteen Minutes', 'singular' => 'quarter hour', 'plural' => 'quarter hours', 'timeBasedFlag' => 1, 'minutesPerUnit' => 15]);
        DB::table('fee_units')->insert(['code' => 'thirtyMinutes', 'description' => 'Thirty Minutes', 'singular' => 'half hour', 'plural' => 'half hours', 'timeBasedFlag' => 1, 'minutesPerUnit' => 30]);
    }
}
