<?php

use App\Party;
use Faker\Generator as Faker;
use Illuminate\Support\Str;

$factory->define(Party::class, function (Faker $faker) {
    $firstName = $faker->firstName();
    $lastName = $faker->lastName();

    return [

        //'code' => Str::upper( substr($lastName, 0, 3) . $faker->randomLetter() . $faker->randomLetter()) . $faker->numberBetween(1,100),
        'code' => Str::upper(substr($lastName, 0, 3).$faker->randomLetter()).$faker->numberBetween(1, 1000),
        'name' => $firstName.' '.$lastName,
        'firstName' => $firstName,
        'lastName' => $lastName,
        'title' => $faker->title(),
        'salutation' => 'Dear Sir/Madam',

        'marriageId' => 1,
        'typeId' => 1,
        'entityId' => 1,

        'physicalLine1' => $faker->streetAddress(),
        'physicalLine2' => $faker->city(),
        'physicalProvinceId' => $faker->numberBetween(1, 8),
        'physicalCountryId' => 1,

        'postalLine1' => $faker->streetAddress(),
        'postalLine2' => $faker->city(),
        'postalProvinceId' => $faker->numberBetween(1, 8),
        'postalCountryId' => 1,
    ];
});
