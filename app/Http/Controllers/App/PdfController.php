<?php

namespace App\Http\Controllers\App;

use Barryvdh\Snappy\Facades\SnappyPdf;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use mikehaertl\pdftk\Pdf;

// Using php-pdftk (https://github.com/mikehaertl/php-pdftk)
// Note: Pdftk binary must be installed and in the web server path
// See: https://www.pdflabs.com/docs/install-pdftk-on-redhat-or-centos/

/***************************
Need these settings in the php.ini

upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 300
memory_limit = 1024M

****************************/

class PdfController extends Controller
{
    private function generateHtml($html)
    {
        $css = file_get_contents(base_path().'/public/css/program.css');

        return <<<EOT
        <!DOCTYPE html>
        <html lang="en" class="no-js">
            <head>
                <meta charset="utf-8">
                <style>$css</style>
            </head>
            <body style="background-color: white">$html</body>
        </html>        
EOT;
    }

    public function htmlToPdf(Request $request)
    {
        try {
            $returnData = new \stdClass();

            $relativePath = strtolower(session('companyCode')).'/'.session('employeeId').'/'.$request->folder;
            $realPath = storage_path('app/public').'/'.$relativePath;

            $cloudStorage = Storage::disk(session('region'));
            $localStorage = Storage::disk('public');

            $saveAs = $realPath.'/'.$request->fileName;

            // Increase timeout for large documents
            SnappyPdf::setTimeOut(300);

            // Fix bug in SnappyPdf::loadHTML - an <hr> in the Html causes images to not render correctly (for some strange reason)
            $html = str_replace('<hr>', '<div style="border: 1px solid darkgrey; margin: 5px 0px"></div>', $request->bodyHtml);

            $pdf = SnappyPdf::loadHTML($this->generateHtml($html));

            $pdf->setPaper($request->paperSize, $request->orientation);

            if (isset($request->headerHtml)) {
                $pdf->setOption('header-html', $this->generateHtml($request->headerHtml));
            }
            if (isset($request->footerHtml)) {
                $pdf->setOption('footer-html', $this->generateHtml($request->footerHtml));
            }

            if (isset($request->topmargin)) {
                $pdf->setOption('margin-top', $request->topmargin);
            }
            if (isset($request->bottommargin)) {
                $pdf->setOption('margin-bottom', $request->bottommargin);
            }
            if (isset($request->leftmargin)) {
                $pdf->setOption('margin-left', $request->leftmargin);
            }
            if (isset($request->rightmargin)) {
                $pdf->setOption('margin-right', $request->rightmargin);
            }

            $pdf->save($saveAs, true);

            if (isset($request->password) && isset($request->allow)) {
                $pdfToolkit = new Pdf($saveAs);

                $pdfToolkit->setPassword($request->password);

                $pdfToolkit->allow($request->allow);

                if (! $pdfToolkit->saveAs($saveAs)) {
                    $returnData->errors = $pdfToolkit->getError();
                }
            }

            if (! isset($returnData->error)) {
                $cloudStorage->put($relativePath.'/'.$request->fileName, $localStorage->get($relativePath.'/'.$request->fileName), 'public');

                $returnData->path = $relativePath;

                $returnData->url = $cloudStorage->url($relativePath.'/'.$request->fileName);

                $localStorage->delete($relativePath.'/'.$request->fileName);
            }

            return json_encode($returnData);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function combine(Request $request)
    {

        /* THIS WORKS
        use mikehaertl\pdftk\Pdf;
        $pdf = new Pdf();
        $pdf->addFile('C:\laragon\www\legalsuiteonline\storage\app\public\acme01\5\documents\Document1.pdf','AAA');
        $pdf->addFile('C:\laragon\www\legalsuiteonline\storage\app\public\acme01\5\documents\Document2.pdf','BBB');
        $pdf->addFile('C:\laragon\www\legalsuiteonline\storage\app\public\acme01\5\documents\Document3.pdf','CCCC');
        $pdf->addFile('C:\laragon\www\legalsuiteonline\storage\app\public\acme01\5\documents\Document4.pdf','DDDDDDD');
        $pdf->cat('AAA BBB CCCC DDDDDDD');
        $pdf->getError();
        $pdf->saveAs( 'C:\laragon\www\legalsuiteonline\storage\app\public\acme01\5\documents\CombinedDocument.pdf');
        $pdf->getError();
        */

        $returnData = new \stdClass();
        $returnData->errors = null;

        $relativePath = strtolower(session('companyCode')).'/'.session('employeeId').'/'.$request->folder;
        $realPath = storage_path('app/public').'/'.$relativePath;

        $cloudStorage = Storage::disk(session('region'));
        $localStorage = Storage::disk('public');

        $counter = 0;
        $handles = '';

        $files = json_decode($request->pdfFiles);

        $pdf = new Pdf();

        foreach ($files as $file) {
            $counter++;
            //$handle = $this->getHandle($counter);
            $handle = $this::getColName($counter);

            // Download a copy of the file to the local public storage directory (so pdftk can combine them)
            $localStorage->put($relativePath.'/'.$file->fileName, $cloudStorage->get($file->path.'/'.$file->fileName));

            $pdf->addFile(storage_path('app/public').'/'.$relativePath.'/'.$file->fileName, $handle);

            $handles .= $handle.' ';
        }

        if (! $pdf->cat(trim($handles))) {
            $returnData->errors = $pdf->getError();
        }

        if (! isset($returnData->errors)) {
            if (! $pdf->saveAs($realPath.'/'.$request->saveAs)) {
                $returnData->errors = $pdf->getError();
            } else {
                $cloudStorage->put($relativePath.'/'.$request->saveAs, $localStorage->get($relativePath.'/'.$request->saveAs), 'public');

                $returnData->path = $relativePath;

                $returnData->url = $cloudStorage->url($relativePath.'/'.$request->saveAs);

                // Delete the local files
                foreach (json_decode($request->pdfFiles) as $file) {
                    $localStorage->delete($relativePath.'/'.$file->fileName);
                }

                $localStorage->delete($relativePath.'/'.$request->saveAs);
            }
        }

        return json_encode($returnData);
    }

    //https://stackoverflow.com/questions/25958518/how-to-list-from-a-to-z-in-php-and-then-on-to-aa-ab-ac-etc
    public static $alpha = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

    public static function getColName($index)
    {
        $index--;
        $nAlphabets = 26;
        $f = floor($index / pow($nAlphabets, 0)) % $nAlphabets;
        $s = (floor($index / pow($nAlphabets, 1)) % $nAlphabets) - 1;
        $t = (floor($index / pow($nAlphabets, 2)) % $nAlphabets) - 1;

        $f = $f < 0 ? '' : self::$alpha[$f];
        $s = $s < 0 ? '' : self::$alpha[$s];
        $t = $t < 0 ? '' : self::$alpha[$t];

        return trim("{$t}{$s}{$f}");
    }

    /*
        private function generateHtml_Bootstrap_Cdn($html) {

            return <<<EOT
            <!DOCTYPE html>
            <html lang="en" class="no-js">
            <head>
                <meta charset="utf-8">
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
            </head>
            <body style="background-color: white">
            $html
            </body>
            </html>
    EOT;

        }


        private function generateHtml_Cloud_Css($html) {

            //Using full program CSS

            $url = config('cloud.cdnUrl');

            return <<<EOT
            <!DOCTYPE html>
            <html lang="en" class="no-js">
            <head>
                <meta charset="utf-8">
                <link href="$url/program.css" rel="stylesheet">
            </head>
            <body style="background-color: white">
            $html
            </body>
            </html>
    EOT;

        }
    */

    /*private function getHandle($counter)
    {

        $letters = range('A', 'Z'); //['A','B' ... 'Z']
        $returnData = '';
        $chunks = 0;

        if ($counter <= 25 ) {

            $returnData = $letters[$counter];

        } else {

            $chunks = intdiv($counter,25) + 1;

            $letter =  ($counter % 25) - 1;

            for ($i=0; $i < $chunks; $i++) {

                $returnData .= $letters[$letter];

            }

        }

        return $returnData;

    }*/

    // public function setPassword(Request $request)
    // {

    //     $returnData = new \stdClass();
    //     $returnData->errors = null;

    //     $pdfToolkit = new Pdf($request->fileName);

    //     $pdfToolkit->setPassword($request->password);
    //     $pdfToolkit->allow($request->allow);

    //     if ( !$pdfToolkit->saveAs($request->fileName) ) {

    //         $returnData->errors = $pdfToolkit->getError();

    //     }

    // }

        /****** Allow options *******************
        Printing – Top Quality Printing
        DegradedPrinting – Lower Quality Printing
        ModifyContents – Also allows Assembly
        Assembly
        CopyContents – Also allows ScreenReaders
        ScreenReaders
        ModifyAnnotations – Also allows FillIn
        FillIn
        AllFeatures – Allows the user to perform all of the above, and top quality printing.
       ******************************************/
}
