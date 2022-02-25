<?php

namespace App\Http\Controllers\App;

use Illuminate\Http\File;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Storage;

class FileController extends Controller
{
    private function remoteFileExists($url)
    {

        //https://stackoverflow.com/questions/981954/how-can-one-check-to-see-if-a-remote-file-exists-using-php
        $curl = curl_init($url);

        //don't fetch the actual page, you only want to check the connection is ok
        curl_setopt($curl, CURLOPT_NOBODY, true);

        //do request
        $result = curl_exec($curl);

        $ret = false;

        //if request did not fail
        if ($result !== false) {
            //if request was ok, check response code
            $statusCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);

            if ($statusCode == 200) {
                $ret = true;
            }
        }

        curl_close($curl);

        return $ret;
    }

    public function checkIfRemoteFileExists(Request $request)
    {
        $returnData['result'] = $this->remoteFileExists(str_replace(' ', '%20', $request->url));

        // $result = $this->remoteFileExists( str_replace(' ', '%20', $request->url) );

        // $returnData['result'] = $result;

        // if ( $result ) {

        //     $returnData['url'] = str_replace(' ', '%20', $request->url);

        // } else {

        //     $returnData['url'] = '';

        // }

        return json_encode($returnData);
    }

    public function exists(Request $request)
    {
        $returnData = new \stdClass();

        $cloudStorage = Storage::disk(session('region'));

        //$cloudStorage = Storage::disk('af-south-1');
        //$returnData->result = $cloudStorage->exists('acme/1/statements/Statements-2020-06-22-08-42-24.pdf');

        try {
            $returnData->result = $cloudStorage->exists($request->path.'/'.$request->fileName);

            if ($returnData->result) {
                $returnData->url = $cloudStorage->url($request->path.'/'.$request->fileName);
            } else {
                $returnData->url = '';
            }

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function selected(Request $request)
    {

        // The file has been uploaded to the user's tmp directory on their device
        // Vue-Dropzone will execute the function defined in "vdropzone-success"
        // This is just a placeholder function

        // See: https://www.dropzonejs.com/#usage
        // See: https://www.startutorial.com/articles/view/how-to-build-a-file-upload-form-using-dropzonejs-and-php
    }

    public function uploadFile(Request $request)
    {
        $returnData = new \stdClass();

        try {

            // Note: $request->remoteFolder must have a unique path (e.g. id or date) in case of duplicate file names

            $localPath = '/storage/'.strtolower(session('companyCode')).'/'.session('employeeId').'/'.$request->localFolder;

            $localFile = str_replace('\\', '/', public_path()).$localPath.'/'.$request->fileName;

            if (! file_exists($localFile)) {
                $returnData->error = 'File not found: '.$localFile;

                return json_encode($returnData);
            }

            if (($file = fopen($localFile, 'r+')) === false) {

                //throw new \Exception('Unable to open file: ' . $localFile);
                $returnData->error = 'Unable to open file: '.$localFile;

                return json_encode($returnData);
            }

            $cloudStorage = Storage::disk(session('region'));

            $returnData->path = strtolower(session('companyCode').'/'.session('employeeId').'/'.$request->remoteFolder);

            $returnData->url = $cloudStorage->url($returnData->path.'/'.$request->fileName);

            //$cloudStorage->putFileAs($returnData->path, $file, $request->fileName, 'public');
            $cloudStorage->put($returnData->path.'/'.$request->fileName, $file, 'public');

            fclose($file);

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function upload(Request $request)
    {
        $returnData = new \stdClass();

        $cloudStorage = Storage::disk(session('region'));

        $returnData->fileName = $request->fileName;

        $returnData->path = strtolower(session('companyCode').'/'.session('employeeId').'/'.$request->folder);

        $returnData->url = $cloudStorage->url($returnData->path.'/'.$returnData->fileName);

        try {
            $cloudStorage->putFileAs($returnData->path, $request->file, $returnData->fileName, 'public');

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function save(Request $request)
    {
        $returnData = new \stdClass();

        $localStorage = Storage::disk('public');

        try {
            $returnData->result = $localStorage->putFile($request->path, $request->file);

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->error = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function convertDocxToPdf(Request $request)
    {
        $this->returnData = new \stdClass();
        $this->returnData->error = '';

        // Example:
        // $request->destinationPath: "merged"
        // $request->docxFileName: "General Test.docx"
        // $request->source: "acme/1/temp/VtEnOBmGuuQH9Zeby7gVIoOTc8Muo6S0GBTBNlZW.docx"
        // $request->sourceLocation: "cloud | local"

        // Local path where Libre Ofice saves the pdf
        $convertToPath = storage_path('app/public').'/'.strtolower(session('companyCode')).'/'.session('employeeId').'/temp';

        // The name Libre Office will save the PDF as
        $convertedPdfFileName = urldecode(pathinfo($request->source, PATHINFO_FILENAME).'.pdf');

        // Path on the cloud to save the converted PDF
        $cloudPath = strtolower(session('companyCode')).'/'.session('employeeId').'/'.$request->destinationPath;

        if ($request->sourceLocation === 'local') {
            $sourcePath = storage_path('app/public').'/'.$request->source;
        } else {
            $sourcePath = $request->source;
        }

        try {

            // *******************************************
            // Use Libre Office to convert the DOCX to PDF
            // *******************************************
            chdir(config('libreOffice.programLocation')); // Change to the LibreOffice program directory

            $libreOfficeCommand = 'soffice --headless --convert-to pdf "'.$sourcePath.'" --outdir "'.$convertToPath.'"';

            //https://superuser.com/questions/627266/convert-file-to-pdf-using-libreoffice-under-user-apache-i-e-when-using-php

            if (App::environment('production')) {
                $libreOfficeCommand = 'HOME=/tmp && '.$libreOfficeCommand;
            }

            $this->returnData->result = exec($libreOfficeCommand);

            // **************************************
            // Save the PDf to the cloud
            // **************************************

            if (isset($request->uniqueFileName) && $request->uniqueFileName === true) {
                $cloudFileName = str_replace('.'.pathinfo($request->docxFileName, PATHINFO_EXTENSION), ' '.date('Y-m-d-His').'.pdf', $request->docxFileName);
            } else {
                $cloudFileName = $convertedPdfFileName;
            }

            $pdfFile = new File($convertToPath.'/'.$convertedPdfFileName);

            $cloudStorage = Storage::disk(session('region'));

            $cloudStorage->putFileAs($cloudPath, $pdfFile, $cloudFileName, 'public');

            // *******************************************
            // Delete the local PDF file Libre created
            // *******************************************
            $convertedFile = strtolower(session('companyCode')).'/'.session('employeeId').'/temp/'.$convertedPdfFileName;

            $localStorage = Storage::disk('public');

            if ($localStorage->exists($convertedFile)) {
                $result = $localStorage->delete($convertedFile);
            }

            // **********************************************
            // Delete the local DOCX used to make the PDF
            // **********************************************

            if ($request->sourceLocation === 'local') {
                if ($localStorage->exists($request->source)) {
                    $localStorage->delete($request->source);
                }
            }

            $this->returnData->path = $cloudPath;
            $this->returnData->url = $cloudStorage->url($cloudPath.'/'.$cloudFileName);
            $this->returnData->fileName = $cloudFileName;

            return json_encode($this->returnData);
        } catch (\Exception $e) {
            $this->returnData->error = $e->getMessage();

            return json_encode($this->returnData);
        }
    }

    public function download(Request $request)
    {
        $cloudStorage = Storage::disk(session('region'));
        $localStorage = Storage::disk('public');

        $localStorage->put($request->path.'/'.$request->fileName, $cloudStorage->get($request->path.'/'.$request->fileName));
    }

    public function delete(Request $request)
    {
        if (is_writable($request->filePath)) {
            $deleted = unlink($request->filePath);
            //logger('deleted',[$request->filePath,$deleted]);
        }
    }
}
