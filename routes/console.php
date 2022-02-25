<?php

use Illuminate\Foundation\Inspiring;

/*
|--------------------------------------------------------------------------
| Console Routes
|--------------------------------------------------------------------------
|
| This file is where you may define all of your Closure based console
| commands. Each Closure is bound to a command instance allowing a
| simple approach to interacting with each command's IO methods.
|
*/

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->describe('Display an inspiring quote');

// Increment the verion number in \config\version.yml
// See: https://github.com/antonioribeiro/version

// Do this manually using C:\...>php artisan increment:major
Artisan::command('increment:major', function () {
    Artisan::call('config:cache');
    Artisan::call('version:timestamp');
    Artisan::call('version:major');
})->describe('Increase major version number');

// Do this manually using C:\...>php artisan increment:major
Artisan::command('increment:minor', function () {
    Artisan::call('config:cache');
    Artisan::call('version:timestamp');
    Artisan::call('version:minor');
})->describe('Increase minor version number');

// Note: Calling this on every git commit in C:\laragon\www\ettorney\.git\hooks\post-commit
Artisan::command('increment:patch', function () {
    Artisan::call('config:cache');
    Artisan::call('version:timestamp');
    Artisan::call('version:patch');
})->describe('Increase patch version number');
