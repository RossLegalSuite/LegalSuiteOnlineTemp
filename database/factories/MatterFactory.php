<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */
use App\Matter;
use Illuminate\Support\Str;
use Faker\Generator as Faker;

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| This directory should contain each of the model factory definitions for
| your application. Factories provide a convenient way to generate new
| model instances for testing / seeding your application's database.
|
*/

$factory->define(Matter::class, function (Faker $faker) {
    return [

        'fileRef' => Str::upper( $faker->word) . '/' . $faker->randomNumber(7),
        'description' => $faker->realText(100),
        'instructed' => now(),
        'matterTypeId' => $faker->numberBetween(1,4),
        'documentSetId' => $faker->numberBetween(1,4),
        'branchId' => 1,
        'revenueAccountId' => 15,
        'trustBankAccountId' => 2,
    ];
});
