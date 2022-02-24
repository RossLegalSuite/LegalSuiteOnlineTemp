<?php

// use App\Party;
// use App\Matter;
// use App\Custom\PartyHelper;
// use App\Custom\MatterHelper;
// use App\Custom\DataTablesHelper;
// use App\Custom\Utils;
//use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::post('/logout', '\App\Http\Controllers\Auth\LoginController@logout')->name('logout');

Route::get('/checkSession', function () {  return session()->has('companyCode') ? 'true' : 'false'; });
Route::get('/killSession', function () {  session()->flush(); return 'Session killed'; });

Route::middleware(['loggedout'])->group(function () {

    Route::post('/login', '\App\Http\Controllers\Auth\LoginController@login')->name('login');
    Route::post('/register', '\App\Http\Controllers\Auth\RegisterController@register')->name('register');
    Route::post('/generateCompanyCode', '\App\Http\Controllers\Auth\RegisterController@generateCompanyCode');
    Route::post('/checkRegister', '\App\Http\Controllers\Auth\RegisterController@checkRegister')->name('checkRegister');

});

Route::get('/', function () {  
    return view('welcome'); 
});//->name('welcome');

Route::get('/login/{firmcode}', function () {  
    return view('client'); 
});


Route::middleware(['loggedin'])->group(function () {

    
    Route::get('/home', function () {  return view('app'); })->name('home');

    Route::get('/{any}', function () { return redirect('/home'); });//->where('any','.*');

    //***************************************************************/
    // Extra Screens
    //***************************************************************/
    Route::prefix('extrascreens')->group(function () {
        Route::post('store', 'ExtraScreenController@store');
    });
    
    //***************************************************************/
    // Extra Screen Fields
    //***************************************************************/
    Route::prefix('extra_screen_fields')->group(function () {
        Route::post('get', 'ExtraScreenFieldController@get');
        Route::post('store', 'ExtraScreenFieldController@store');
        Route::post('delete', 'ExtraScreenFieldController@destroy');
    });
    

    //***************************************************************/
    // Matter Extra Screen Data
    //***************************************************************/
    Route::prefix('matter_extra_screens')->group(function () {
        Route::post('get', 'MatterExtraScreenController@get');
    });
    
    //***************************************************************/
    // Party Extra Screen Data
    //***************************************************************/
    Route::prefix('party_extra_screens')->group(function () {
        Route::post('get', 'PartyExtraScreenController@get');
    });
    
    //***************************************************************/
    // Matter Party Extra Screen Data
    //***************************************************************/
    Route::prefix('matter_party_extra_screens')->group(function () {
        Route::post('get', 'MatterPartyExtraScreenController@get');
    });
    

    //***************************************************************/
    // Contact Numbers
    //***************************************************************/
    Route::prefix('contact_numbers')->group(function () {
        Route::post('get', 'ContactNumberController@get');
    });

    //***************************************************************/
    // DocLog
    //***************************************************************/

    Route::post('doclog/upload/{recordid}', 'UtilsController@uploadDocLogDocument');

    
    //***************************************************************/
    // Utils Controller
    //***************************************************************/
    Route::prefix('utils')->group(function () {
        Route::post('call/{method}', 'UtilsController@call');
        Route::post('getapikey', 'UtilsController@getApiKey');
        Route::post('getFeeItems', 'UtilsController@getFeeItems');
        Route::post('getIncomeAccount', 'UtilsController@getIncomeAccount');
        Route::post('getBasicData', 'UtilsController@getBasicData');
        Route::post('getFileType', 'UtilsController@getFileType');
        Route::post('getMimeType', 'UtilsController@getMimeType');
        Route::post('deleteTagged', 'UtilsController@deleteTagged');
        Route::post('clearTagged', 'UtilsController@clearTagged');
        Route::post('deleteEmployeeTags', 'UtilsController@deleteEmployeeTags');
        Route::get('initializeData', 'UtilsController@initializeData');
        Route::get('getCollCommPercentAndLimit', 'UtilsController@getCollCommPercentAndLimit');
    });

    //***************************************************************/
    // Lookup Library
    //***************************************************************/
    // Route::prefix('library')->group(function () {
    //     Route::post('store', 'LibraryController@store');
    //     Route::post('getTablePosition', 'LibraryController@getTablePosition');
    // });

    //***************************************************************/
    // ColDebit
    //***************************************************************/
    Route::prefix('coldebits')->group(function () {
        Route::post('get', 'ColDebitController@get');
    });

    //***************************************************************/
    // Matter Parties
    //***************************************************************/
    Route::prefix('matter_parties')->group(function () {
        Route::post('store', 'MatterPartyController@store');
        Route::post('checkSorter', 'MatterPartyController@checkSorter');
        Route::post('getTablePosition', 'MatterPartyController@getTablePosition');
    });
    
    //***************************************************************/
    // Employees
    //***************************************************************/

    Route::prefix('employees')->group(function () {
        Route::post('saveSmtpDetails', 'EmployeeController@saveSmtpDetails');
        Route::get('get-current', 'EmployeeController@getCurrent');
    });

    //***************************************************************/
    // Permissions
    //***************************************************************/
    // Route::prefix('permissions')->group(function () {
    //     Route::post('get', 'PermissionController@get');
    //     Route::post('store', 'PermissionController@store');
    // });

    //***************************************************************/
    // Emails
    //***************************************************************/
    Route::prefix('mail')->group(function () {
        Route::post('testIncomingServer', 'EmailController@testIncomingServer');
        Route::post('testOutgoingServer', 'EmailController@testOutgoingServer');
        Route::post('sendEmail', 'EmailController@sendEmail');
        Route::post('getMessages', 'EmailController@getMessages');
        Route::post('getMessageBody', 'EmailController@getMessageBody');
        Route::post('getFolders', 'EmailController@getFolders');
        Route::post('saveAttachments', 'EmailController@saveAttachments');
        Route::post('uploadEmailMessage', 'EmailController@uploadEmailMessage');
        Route::post('getCorrespondenceEmail', 'EmailController@getCorrespondenceEmail');
    });



    //***************************************************************/
    // Reports
    //***************************************************************/

    // Route::prefix('reports')->group(function () {
    //     Route::post('get', 'ReportController@get');
    //     Route::post('store', 'ReportController@store');
    //     Route::post('delete', 'ReportController@destroy');
    //     Route::post('getTablePosition', 'ReportController@getTablePosition');
    //     Route::post('trial-balance', 'ReportController@trialBalance');
    //     Route::post('income-statement', 'ReportController@incomeStatement');
    //     Route::post('balance-sheet', 'ReportController@balanceSheet');
    // });

    //***************************************************************/
    // LibreOffice
    //***************************************************************/
    // Route::prefix('libre')->group(function () {
    //     Route::post('testMacro', 'LibreController@testMacro');
    //     Route::post('replaceLetterHead', 'LibreController@replaceLetterHead');
    // });


    //***************************************************************/
    // Pdf
    //***************************************************************/
    
    Route::prefix('pdf')->group(function () {
        Route::get('combine', 'PdfController@combine');
        Route::post('combine', 'PdfController@combine');
        Route::post('htmlToPdf', 'PdfController@htmlToPdf');
    });


    //***************************************************************/
    // Files
    //***************************************************************/
    Route::prefix('file')->group(function () {
        Route::post('checkIfRemoteFileExists', 'FileController@checkIfRemoteFileExists');
        Route::post('exists', 'FileController@exists');
        Route::post('selected', 'FileController@selected');
        Route::post('uploadFile', 'FileController@uploadFile');
        Route::post('upload', 'FileController@upload');
        Route::post('save', 'FileController@save');
        Route::post('delete', 'FileController@delete');
        Route::post('convertDocxToPdf', 'FileController@convertDocxToPdf');
    });

    //***************************************************************/
    // Help
    //***************************************************************/
    Route::prefix('help')->group(function () {
        Route::post('get', 'HelpController@get');
    });

    //***************************************************************/
    // All other tables
    //***************************************************************/
    Route::post('{tablename}/get/{recordid?}', 'GenericTableController@get');
    Route::post('{tablename}/store', 'GenericTableController@store');
    Route::post('{tablename}/update', 'GenericTableController@update');
    Route::post('{tablename}/delete/{recordid}', 'GenericTableController@delete');
    Route::post('{tablename}/first', 'GenericTableController@first');
    Route::post('{tablename}/copy', 'GenericTableController@copy');
    Route::post('{tablename}/getTemplateData/{recordid?}', 'GenericTableController@getTemplateData');
    Route::post('{tablename}/storeRecords', 'GenericTableController@storeRecords');

});
