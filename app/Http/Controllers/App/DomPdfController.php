<?php

namespace App\Http\Controllers\App;


use PDF;
use Illuminate\Http\Request;


class DomPdfController extends Controller {

    public function create(Request $request)
    {

        $returnData = new \stdClass();

        $html = <<<EOT
        <!DOCTYPE html>
        <html lang="en" class="no-js">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://d22oktazhmwkct.cloudfront.net/custom.css" rel="stylesheet">
            <link href="https://d22oktazhmwkct.cloudfront.net/colors.css" rel="stylesheet">
        </head>
        <body style="padding:15px">
        $request->html
        </body>
        </html>        
EOT;

        //PDF::loadHTML($html)->setPaper('a4', 'landscape')->setWarnings(false)->save('myfile.pdf')
        $returnData->response = PDF::loadHTML($html)->save('aaaa1-test.pdf');

        return json_encode($returnData);
        

    }

}
