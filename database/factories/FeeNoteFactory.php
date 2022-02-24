<?php

use App\FeeNote;
use Illuminate\Support\Str;
use Faker\Generator as Faker;


$factory->define(FeeNote::class, function (Faker $faker) {

    $amount = $faker->randomFloat(2,0,10000);
    $taxAmount = $amount * 0.15;

    return [

        'date' => $faker->dateTimeBetween('-3 years'),
        'description' => $faker->paragraph(),
        'matterId' => $faker->numberBetween(1,5),
        'createdById' => $faker->numberBetween(1,4),
        'type' => $faker->randomElement($array = array ('Fee', 'Disbursement')),
        'amount' => $amount,
        'taxAmount' => $taxAmount,
        'taxRateId' => 1,


    ];
});
