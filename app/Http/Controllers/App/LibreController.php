<?php

namespace App\Http\Controllers\App;

use Illuminate\Support\Str;
use Illuminate\Http\File;
use Illuminate\Http\Request;
use App\Custom\Utils;
use Storage;

class LibreController extends Controller {



    public function replaceLetterHead(Request $request) 
    {

        //https://superuser.com/questions/1135850/how-do-i-run-a-libreoffice-macro-from-the-command-line-without-the-gui

        $this->returnData = new \stdClass();
        $this->returnData->error = '';

        try {

            chdir(config('libreOffice.programLocation')); // Change to the LibreOffice program directory

            $searchFor = !isset($request->letterHeadField) ? '{company.letterhead}' : $request->letterHeadField;

            // Examples
            // $document = 'https://ettorney.s3.af-south-1.amazonaws.com/acme/1/templates/Client+Letter.docx';
            // $letterhead = 'https://ettorney.s3.af-south-1.amazonaws.com/acme/1/letterhead/Acme+Letterhead.docx';

            $uniqueFileName = 'letterhead-inserted-' . date('Y-m-d-His') . '.docx';

            //Where the macro will save the new docx with the letterhead in it.
            $saveAs = public_path() . '/storage/'.  $uniqueFileName;
            
            $saveAs = str_replace('\\', '/', $saveAs);

            $this->returnData->savedAs = $saveAs; // Need this "plain path" to delete the file afterwards

            $saveAs = 'file:///' . $saveAs; /// Need it like this for the macro

            //A url to the saved document - so docxTemplater can re=load it
            $saveUrl = Storage::disk('public')->url('/'.  $uniqueFileName); 
            // E.g. https://ettorney/public/storage/2021-03-17-031655.docx

            $this->returnData->url = $saveUrl;

            $macro = 'macro:///Ettorney.Macros.ReplaceLetterHead';
            $macro .= '("' . $searchFor . '"';
            $macro .= ',"' . $request->document . '"';
            $macro .= ',"' . $request->letterhead . '"';
            $macro .= ',"' . $saveAs . '")';

            $libreOfficeCommand = 'soffice --headless ' . $macro;

            $this->returnData->libreOfficeCommand = $libreOfficeCommand;

            $this->returnData->result = exec($libreOfficeCommand);

        } catch (Exception $e) {

            $this->returnData->error = $e->getMessage();

        }

        return json_encode($this->returnData);            

    }


    public function replaceLetterHeadNotHeadless(Request $request) 
    {

        $this->returnData = new \stdClass();
        $this->returnData->error = '';

        try {

            chdir(config('libreOffice.programLocation')); // Change to the LibreOffice program directory

            $searchFor = !isset($request->letterHeadField) ? '{company.letterhead}' : $request->letterHeadField;

            // Examples
            // $document = 'https://ettorney.s3.af-south-1.amazonaws.com/acme/1/templates/Client+Letter.docx';
            // $letterhead = 'https://ettorney.s3.af-south-1.amazonaws.com/acme/1/letterhead/Acme+Letterhead.docx';
            // $saveAs = 'file:///D:/Rick/Documents/ClientLetter999.docx';

            //$uniqueFileName = urldecode( pathinfo($request->saveAs, PATHINFO_FILENAME) . '-' . date('Y-m-d-His') . '.docx');
            //$uniqueFileName = pathinfo($request->saveAs, PATHINFO_FILENAME) . '-' . date('Y-m-d-His') . '.docx';
            $uniqueFileName = 'letterhead-inserted-' . date('Y-m-d-His') . '.docx';

            $saveAs = 'file:///' . public_path() . '/storage/'.  $uniqueFileName;

            // $saveAs = 'file:///' . storage_path('app/public') . '/';
            // $saveAs .= strtolower( session('companyCode')) . '/' . session('employeeId') . '/temp';
            // $saveAs .= '/' .  $uniqueFileName;

            $saveAs = str_replace('\\', '/', $saveAs);

            $this->returnData->saveAs = $saveAs;

            //$saveUrl = Storage::disk('public')->url('/app/public/' .strtolower( session('companyCode')) . '/' . session('employeeId') . '/temp/'.  $uniqueFileName);
            $saveUrl = Storage::disk('public')->url('/'.  $uniqueFileName); 
            // E.g. https://ettorney/storage/2021-03-17-031655.docx

            $this->returnData->url = $saveUrl;

            $macro = 'macro:///Ettorney.Macros.ReplaceLetterHead';
            $macro .= '("' . $searchFor . '"';
            $macro .= ',"' . $request->letterhead . '"';
            $macro .= ',"' . $saveAs . '")';
            

            $libreOfficeCommand = 'soffice --minimized ' . $request->document . ' ' . $macro;

            $this->returnData->libreOfficeCommand = $libreOfficeCommand;

            $this->returnData->result = exec($libreOfficeCommand);

        } catch (Exception $e) {

            $this->returnData->error = $e->getMessage();

        }

        return json_encode($this->returnData);            

    }

    public function testMacro(Request $request) 
    {

        $this->returnData = new \stdClass();
        $this->returnData->error = '';

        try {

            chdir(config('libreOffice.programLocation')); // Change to the LibreOffice program directory

            /*Test at Command Prompt:
            c:\laragon\www\program>
            soffice https://ettorney.s3.af-south-1.amazonaws.com/acme/1/templates/Client+Letter.docx macro:///Ettorney.Macros.ReplaceLetterHead("{company.letterhead}","https://ettorney.s3.af-south-1.amazonaws.com/acme/1/letterhead/Acme+Letterhead.docx","file:///D:/Rick/Documents/Client%20Letter5.docx")
            */

            $document = 'https://ettorney.s3.af-south-1.amazonaws.com/acme/1/templates/Client+Letter.docx';
            $searchFor = '{company.letterhead}';
            $letterhead = 'https://ettorney.s3.af-south-1.amazonaws.com/acme/1/letterhead/Acme+Letterhead.docx';
            $saveAs = 'file:///D:/Rick/Documents/ClientLetter999.docx';

            //$macro = 'macro:///Ettorney.Macros.ReplaceLetterHeadTest';
            $macro = 'macro:///Ettorney.Macros.ReplaceLetterHead';
            $macro .= '("' . $searchFor . '"';
            $macro .= ',"' . $letterhead . '"';
            $macro .= ',"' . $saveAs . '")';

            $libreOfficeCommand = 'soffice ' . $document . ' ' . $macro;

            //$this->returnData->$libreOfficeCommand = $libreOfficeCommand;
            $this->returnData->result = exec ($libreOfficeCommand);
            return json_encode($this->returnData);            

        } catch (Exception $e) {

            $this->returnData->error = $e->getMessage();

            return json_encode($this->returnData);            

        }


    }

/***************************************************************************
LibreOffice Macro
***************************************************************************
// See: https://wiki.openoffice.org/wiki/Documentation/BASIC_Guide/StarDesktop
// For guide to writing macros (or just record a macro and look at its source)
sub ReplaceLetterHead(searchFor as String, letterHead as String, saveAs as String)

document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

Dim testLetterHead as String
Dim testSaveAs as String
Dim testSearchFor as String

testLetterHead = "https://ettorney.s3.af-south-1.amazonaws.com/acme/1/letterhead/Acme+Letterhead.docx"
testSaveAs = "file:///C:/laragon/www/ettorney/storage/app/public/acme/1/temp/2021-03-17-031655.docx"
testSearchFor = "{company.letterhead}"

Dim letterheadArgs(1) as new com.sun.star.beans.PropertyValue
letterheadArgs(0).Name = "Name"
letterheadArgs(0).Value =  letterhead
'letterheadArgs(0).Value =  testLetterHead
letterheadArgs(1).Name = "Filter"
letterheadArgs(1).Value = "MS Word 2007 XML"

Dim saveArgs(0) as new com.sun.star.beans.PropertyValue
saveArgs(0).Name = "FilterName"
saveArgs(0).Value = "MS Word 2007 XML"

Dim oDescriptor 'The search descriptor
Dim oFound 'The found range

oDescriptor = ThisComponent.createSearchDescriptor()
With oDescriptor
.SearchString = searchFor
.SearchWords = true
.SearchCaseSensitive = False
End With

oFound = ThisComponent.findFirst(oDescriptor)

If IsNull(oFound) THEN 

'Do nothing

ELSE

dispatcher.executeDispatch(document, ".uno:InsertDoc", "", 0, letterheadArgs())

oFound.setString("")

oFound = ThisComponent.findNext(oFound.End, oDescriptor)

'ThisComponent.storeToURL(testSaveAs,saveArgs())
ThisComponent.storeToURL(saveAs,saveArgs())

END IF

document.close(true)

End Sub

       */



}
