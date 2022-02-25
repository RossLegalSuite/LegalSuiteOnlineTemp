<?php

// use App\Party;
// use App\Matter;
// use App\Custom\PartyHelper;
// use App\Custom\MatterHelper;
// use App\Custom\DataTablesHelper;
// use App\Custom\Utils;
//use Illuminate\Http\Request;
use App\Http\Controllers\App\ColDebitController;
use App\Http\Controllers\App\ContactNumberController;
use App\Http\Controllers\App\EmailController;
use App\Http\Controllers\App\EmployeeController;
use App\Http\Controllers\App\ExtraScreenController;
use App\Http\Controllers\App\ExtraScreenFieldController;
use App\Http\Controllers\App\FileController;
use App\Http\Controllers\App\GenericTableController;
use App\Http\Controllers\App\HelpController;
use App\Http\Controllers\App\LibraryController;
use App\Http\Controllers\App\LibreController;
use App\Http\Controllers\App\MatterExtraScreenController;
use App\Http\Controllers\App\MatterPartyController;
use App\Http\Controllers\App\MatterPartyExtraScreenController;
use App\Http\Controllers\App\PartyExtraScreenController;
use App\Http\Controllers\App\PdfController;
use App\Http\Controllers\App\PermissionController;
use App\Http\Controllers\App\ReportController;
use App\Http\Controllers\App\UtilsController;
use Illuminate\Support\Facades\Route;

Route::post('/logout', [\App\Http\Controllers\Auth\LoginController::class, 'logout'])->name('logout');

Route::get('/checkSession', function () {
    return session()->has('companyCode') ? 'true' : 'false';
});
Route::get('/killSession', function () {
    session()->flush();

    return 'Session killed';
});

Route::middleware(['loggedout'])->group(function () {
    Route::post('/login', [\App\Http\Controllers\Auth\LoginController::class, 'login'])->name('login');
    Route::post('/register', [\App\Http\Controllers\Auth\RegisterController::class, 'register'])->name('register');
    Route::post('/generateCompanyCode', [\App\Http\Controllers\Auth\RegisterController::class, 'generateCompanyCode']);
    Route::post('/checkRegister', [\App\Http\Controllers\Auth\RegisterController::class, 'checkRegister'])->name('checkRegister');
});

Route::get('/', function () {
    return view('welcome');
}); //->name('welcome');

Route::get('/login/{firmcode}', function () {
    return view('client');
});

Route::middleware(['loggedin'])->group(function () {
    Route::get('/home', function () {
        return view('app');
    })->name('home');

    Route::get('/{any}', function () {
        return redirect('/home');
    }); //->where('any','.*');

    //***************************************************************/
    // Extra Screens
    //***************************************************************/
    Route::prefix('extrascreens')->group(function () {
        Route::post('store', [ExtraScreenController::class, 'store']);
    });

    //***************************************************************/
    // Extra Screen Fields
    //***************************************************************/
    Route::prefix('extra_screen_fields')->group(function () {
        Route::post('get', [ExtraScreenFieldController::class, 'get']);
        Route::post('store', [ExtraScreenFieldController::class, 'store']);
        Route::post('delete', [ExtraScreenFieldController::class, 'destroy']);
    });

    //***************************************************************/
    // Matter Extra Screen Data
    //***************************************************************/
    Route::prefix('matter_extra_screens')->group(function () {
        Route::post('get', [MatterExtraScreenController::class, 'get']);
    });

    //***************************************************************/
    // Party Extra Screen Data
    //***************************************************************/
    Route::prefix('party_extra_screens')->group(function () {
        Route::post('get', [PartyExtraScreenController::class, 'get']);
    });

    //***************************************************************/
    // Matter Party Extra Screen Data
    //***************************************************************/
    Route::prefix('matter_party_extra_screens')->group(function () {
        Route::post('get', [MatterPartyExtraScreenController::class, 'get']);
    });

    //***************************************************************/
    // Contact Numbers
    //***************************************************************/
    Route::prefix('contact_numbers')->group(function () {
        Route::post('get', [ContactNumberController::class, 'get']);
    });

    //***************************************************************/
    // DocLog
    //***************************************************************/

    Route::post('doclog/upload/{recordid}', [UtilsController::class, 'uploadDocLogDocument']);

    //***************************************************************/
    // Utils Controller
    //***************************************************************/
    Route::prefix('utils')->group(function () {
        Route::post('call/{method}', [UtilsController::class, 'call']);
        Route::post('getapikey', [UtilsController::class, 'getApiKey']);
        Route::post('getFeeItems', [UtilsController::class, 'getFeeItems']);
        Route::post('getIncomeAccount', [UtilsController::class, 'getIncomeAccount']);
        Route::post('getBasicData', [UtilsController::class, 'getBasicData']);
        Route::post('getFileType', [UtilsController::class, 'getFileType']);
        Route::post('getMimeType', [UtilsController::class, 'getMimeType']);
        Route::post('deleteTagged', [UtilsController::class, 'deleteTagged']);
        Route::post('clearTagged', [UtilsController::class, 'clearTagged']);
        Route::post('deleteEmployeeTags', [UtilsController::class, 'deleteEmployeeTags']);
        Route::get('initializeData', [UtilsController::class, 'initializeData']);
        Route::get('getCollCommPercentAndLimit', [UtilsController::class, 'getCollCommPercentAndLimit']);
    });

    //***************************************************************/
    // Lookup Library
    //***************************************************************/
    // Route::prefix('library')->group(function () {
    //     Route::post('store', [LibraryController::class, 'store']);
    //     Route::post('getTablePosition', [LibraryController::class, 'getTablePosition']);
    // });

    //***************************************************************/
    // ColDebit
    //***************************************************************/
    Route::prefix('coldebits')->group(function () {
        Route::post('get', [ColDebitController::class, 'get']);
    });

    //***************************************************************/
    // Matter Parties
    //***************************************************************/
    Route::prefix('matter_parties')->group(function () {
        Route::post('store', [MatterPartyController::class, 'store']);
        Route::post('checkSorter', [MatterPartyController::class, 'checkSorter']);
        Route::post('getTablePosition', [MatterPartyController::class, 'getTablePosition']);
    });

    //***************************************************************/
    // Employees
    //***************************************************************/

    Route::prefix('employees')->group(function () {
        Route::post('saveSmtpDetails', [EmployeeController::class, 'saveSmtpDetails']);
        Route::get('get-current', [EmployeeController::class, 'getCurrent']);
    });

    //***************************************************************/
    // Permissions
    //***************************************************************/
    // Route::prefix('permissions')->group(function () {
    //     Route::post('get', [PermissionController::class, 'get']);
    //     Route::post('store', [PermissionController::class, 'store']);
    // });

    //***************************************************************/
    // Emails
    //***************************************************************/
    Route::prefix('mail')->group(function () {
        Route::post('testIncomingServer', [EmailController::class, 'testIncomingServer']);
        Route::post('testOutgoingServer', [EmailController::class, 'testOutgoingServer']);
        Route::post('sendEmail', [EmailController::class, 'sendEmail']);
        Route::post('getMessages', [EmailController::class, 'getMessages']);
        Route::post('getMessageBody', [EmailController::class, 'getMessageBody']);
        Route::post('getFolders', [EmailController::class, 'getFolders']);
        Route::post('saveAttachments', [EmailController::class, 'saveAttachments']);
        Route::post('uploadEmailMessage', [EmailController::class, 'uploadEmailMessage']);
        Route::post('getCorrespondenceEmail', [EmailController::class, 'getCorrespondenceEmail']);
    });

    //***************************************************************/
    // Reports
    //***************************************************************/

    // Route::prefix('reports')->group(function () {
    //     Route::post('get', [ReportController::class, 'get']);
    //     Route::post('store', [ReportController::class, 'store']);
    //     Route::post('delete', [ReportController::class, 'destroy']);
    //     Route::post('getTablePosition', [ReportController::class, 'getTablePosition']);
    //     Route::post('trial-balance', [ReportController::class, 'trialBalance']);
    //     Route::post('income-statement', [ReportController::class, 'incomeStatement']);
    //     Route::post('balance-sheet', [ReportController::class, 'balanceSheet']);
    // });

    //***************************************************************/
    // LibreOffice
    //***************************************************************/
    // Route::prefix('libre')->group(function () {
    //     Route::post('testMacro', [LibreController::class, 'testMacro']);
    //     Route::post('replaceLetterHead', [LibreController::class, 'replaceLetterHead']);
    // });

    //***************************************************************/
    // Pdf
    //***************************************************************/

    Route::prefix('pdf')->group(function () {
        Route::get('combine', [PdfController::class, 'combine']);
        Route::post('combine', [PdfController::class, 'combine']);
        Route::post('htmlToPdf', [PdfController::class, 'htmlToPdf']);
    });

    //***************************************************************/
    // Files
    //***************************************************************/
    Route::prefix('file')->group(function () {
        Route::post('checkIfRemoteFileExists', [FileController::class, 'checkIfRemoteFileExists']);
        Route::post('exists', [FileController::class, 'exists']);
        Route::post('selected', [FileController::class, 'selected']);
        Route::post('uploadFile', [FileController::class, 'uploadFile']);
        Route::post('upload', [FileController::class, 'upload']);
        Route::post('save', [FileController::class, 'save']);
        Route::post('delete', [FileController::class, 'delete']);
        Route::post('convertDocxToPdf', [FileController::class, 'convertDocxToPdf']);
    });

    //***************************************************************/
    // Help
    //***************************************************************/
    Route::prefix('help')->group(function () {
        Route::post('get', [HelpController::class, 'get']);
    });

    //***************************************************************/
    // All other tables
    //***************************************************************/
    Route::post('{tablename}/get/{recordid?}', [GenericTableController::class, 'get']);
    Route::post('{tablename}/store', [GenericTableController::class, 'store']);
    Route::post('{tablename}/update', [GenericTableController::class, 'update']);
    Route::post('{tablename}/delete/{recordid}', [GenericTableController::class, 'delete']);
    Route::post('{tablename}/first', [GenericTableController::class, 'first']);
    Route::post('{tablename}/copy', [GenericTableController::class, 'copy']);
    Route::post('{tablename}/getTemplateData/{recordid?}', [GenericTableController::class, 'getTemplateData']);
    Route::post('{tablename}/storeRecords', [GenericTableController::class, 'storeRecords']);
});
