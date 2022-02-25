<?php

use App\Http\Controllers\App\Auth;
use App\Http\Controllers\App\ContactMethodController;
use App\Http\Controllers\App\CountryController;
use App\Http\Controllers\App\EmployeeController;
use App\Http\Controllers\App\HomeController;
use App\Http\Controllers\App\MarriageTypeController;
use App\Http\Controllers\App\MatterController;
use App\Http\Controllers\App\PartyController;
use App\Http\Controllers\App\PartyEntityController;
use App\Http\Controllers\App\PartyNumberController;
use App\Http\Controllers\App\PartyRoleController;
use App\Http\Controllers\App\PartyTypeController;
use App\Http\Controllers\App\ProvinceController;
use Illuminate\Support\Facades\Route;

//logger('web.php session->all()',[session()->all()]);

Route::get('/', function () {
    return view('welcome');
})->name('welcome')->middleware('loggedout');

Route::get('/login', [Auth\LoginController::class, 'showLoginForm'])->middleware('loggedout');
Route::post('/login', [Auth\LoginController::class, 'login'])->name('login');
Route::post('/logout', [Auth\LoginController::class, 'logout'])->name('logout')->middleware('loggedin');

Route::get('/register', [Auth\RegisterController::class, 'showRegistrationForm'])->middleware('loggedout');
Route::post('/register', [Auth\RegisterController::class, 'register'])->name('register');

Route::get('/home', [HomeController::class, 'index'])->name('home')->middleware('loggedin');
Route::get('/filofax', [HomeController::class, 'filofax'])->middleware('loggedin');

Route::resource('employees', EmployeeController::class)->except(['index']);
Route::post('/get-employees', [EmployeeController::class, 'getEmployees']);

//PARTIES
Route::get('/parties', [PartyController::class, 'index']);
Route::post('/get-parties', [PartyController::class, 'getParties']);
Route::get('/parties/{id}', [PartyController::class, 'getParty']);
//Route::get('/parties/create', [PartyController::class, 'create']);
Route::post('/parties/store', [PartyController::class, 'store']);
//Route::post('/parties/create', [PartyController::class, 'store']);
//Route::get('/parties/{party}/edit', [PartyController::class, 'edit']);
//Route::patch('/parties/{party}/edit', [PartyController::class, 'store']);
Route::delete('/parties/{party}', [PartyController::class, 'destroy']);
Route::post('/parties/storePartyNumbers', [PartyController::class, 'storePartyNumbers']);

//MATTERS
Route::get('/matters', [MatterController::class, 'index']);
Route::post('/get-matters', [MatterController::class, 'getMatters']);
Route::get('/matters/create', [MatterController::class, 'create']);
Route::post('/matters/create', [MatterController::class, 'store']);
Route::get('/matters/{party}/edit', [MatterController::class, 'edit']);
Route::patch('/matters/{party}/edit', [MatterController::class, 'store']);
Route::delete('/matters/{party}', [MatterController::class, 'destroy']);

Route::resource('party_roles', PartyRoleController::class)->except(['index']);
Route::post('/getPartyRoles', [PartyRoleController::class, 'getPartyRoles']);

Route::resource('party_entities', PartyEntityController::class)->except(['index']);
Route::post('/getPartyEntities', [PartyEntityController::class, 'getPartyEntities']);

Route::resource('party_types', PartyTypeController::class)->except(['index']);
Route::post('/getPartyTypes', [PartyTypeController::class, 'getPartyTypes']);

Route::resource('marriage_types', MarriageTypeController::class)->except(['index']);
Route::post('/getMarriageTypes', [MarriageTypeController::class, 'getMarriageTypes']);

Route::resource('countries', CountryController::class)->except(['index']);
Route::post('/getCountries', [CountryController::class, 'getCountries']);

Route::resource('provinces', ProvinceController::class)->except(['index']);
Route::post('/getProvinces', [ProvinceController::class, 'getProvinces']);

Route::resource('contact_methods', ContactMethodController::class)->except(['index']);
Route::post('/getContactMethods', [ContactMethodController::class, 'getContactMethods']);

Route::resource('party_numbers', PartyNumberController::class)->except(['index']);
Route::post('/getPartyNumbers', [PartyNumberController::class, 'getPartyNumbers']);
Route::post('/storePartyNumber', [PartyNumberController::class, 'storePartyNumber']);
Route::post('/deletePartyNumber', [PartyNumberController::class, 'deletePartyNumber']);

Route::get('/chat', function () {
    return view('chat');
});
Route::get('/mail', function () {
    return view('mail');
});
Route::get('/dual-register', function () {
    return view('dual-register');
});
