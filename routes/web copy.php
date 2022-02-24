<?php

//logger('web.php session->all()',[session()->all()]);


Route::get('/', function () {return view('welcome');})->name('welcome')->middleware('loggedout');

Route::get('/login', 'Auth\LoginController@showLoginForm')->middleware('loggedout');
Route::post('/login', 'Auth\LoginController@login')->name('login');
Route::post('/logout', 'Auth\LoginController@logout')->name('logout')->middleware('loggedin');

Route::get('/register', 'Auth\RegisterController@showRegistrationForm')->middleware('loggedout');
Route::post('/register', 'Auth\RegisterController@register')->name('register');

Route::get('/home', 'HomeController@index')->name('home')->middleware('loggedin');
Route::get('/filofax', 'HomeController@filofax')->middleware('loggedin');


Route::resource('employees', 'EmployeeController')->except(['index']);
Route::post('/get-employees', 'EmployeeController@getEmployees');

//PARTIES
Route::get('/parties', 'PartyController@index');
Route::post('/get-parties', 'PartyController@getParties');
Route::get('/parties/{id}', 'PartyController@getParty');
//Route::get('/parties/create', 'PartyController@create');
Route::post('/parties/store', 'PartyController@store');
//Route::post('/parties/create', 'PartyController@store');
//Route::get('/parties/{party}/edit', 'PartyController@edit');
//Route::patch('/parties/{party}/edit', 'PartyController@store');
Route::delete('/parties/{party}', 'PartyController@destroy');
Route::post('/parties/storePartyNumbers', 'PartyController@storePartyNumbers');

//MATTERS
Route::get('/matters', 'MatterController@index');
Route::post('/get-matters', 'MatterController@getMatters');
Route::get('/matters/create', 'MatterController@create');
Route::post('/matters/create', 'MatterController@store');
Route::get('/matters/{party}/edit', 'MatterController@edit');
Route::patch('/matters/{party}/edit', 'MatterController@store');
Route::delete('/matters/{party}', 'MatterController@destroy');


Route::resource('party_roles', 'PartyRoleController')->except(['index']);
Route::post('/getPartyRoles', 'PartyRoleController@getPartyRoles');

Route::resource('party_entities', 'PartyEntityController')->except(['index']);
Route::post('/getPartyEntities', 'PartyEntityController@getPartyEntities');

Route::resource('party_types', 'PartyTypeController')->except(['index']);
Route::post('/getPartyTypes', 'PartyTypeController@getPartyTypes');

Route::resource('marriage_types', 'MarriageTypeController')->except(['index']);
Route::post('/getMarriageTypes', 'MarriageTypeController@getMarriageTypes');

Route::resource('countries', 'CountryController')->except(['index']);
Route::post('/getCountries', 'CountryController@getCountries');

Route::resource('provinces', 'ProvinceController')->except(['index']);
Route::post('/getProvinces', 'ProvinceController@getProvinces');

Route::resource('contact_methods', 'ContactMethodController')->except(['index']);
Route::post('/getContactMethods', 'ContactMethodController@getContactMethods');

Route::resource('party_numbers', 'PartyNumberController')->except(['index']);
Route::post('/getPartyNumbers', 'PartyNumberController@getPartyNumbers');
Route::post('/storePartyNumber', 'PartyNumberController@storePartyNumber');
Route::post('/deletePartyNumber', 'PartyNumberController@deletePartyNumber');

Route::get('/chat', function () { return view('chat'); } );
Route::get('/mail', function () { return view('mail'); } );
Route::get('/dual-register', function () { return view('dual-register'); } );

