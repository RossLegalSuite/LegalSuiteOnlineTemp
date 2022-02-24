<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class FeeNoteTestSeeder extends Seeder
{
    /**
     * Run at the command prompt
     * php artisan db:seed --class=FeeNoteTestSeeder
     */
    public function run()
    {

        $db = 'acme';
        $user = $db . '_user';
        $password = $db . '_1024';


        config(['database.default' => 'ettorney']);
        
        config(['database.connections.ettorney' =>
        [
            'driver' =>     'mysql',
            
            "host" =>       '127.0.0.1',
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


        factory(App\FeeNote::class, 1000)->create();

    }
}