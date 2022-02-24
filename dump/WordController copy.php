<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Custom\DocumentAssembly;
use PhpOffice\PhpWord\TemplateProcessor;
use PhpOffice\PhpWord\Settings;
use App\Custom\Utils;
use App\Http\Controllers\MatterController;



class WordController extends Controller {

    protected $templateProcessor;
    protected $returnData;
    protected $tables = array();
    protected $fields = array();
    protected $paras = array();
    

    protected $employee = array();
    protected $company = array();
    protected $matter = array();

    public function merge(Request $request)
    {

        $this->returnData = new \stdClass();
        $this->returnData->error = '';

        $this->returnData->sourcePath = strtolower( session('companyCode') . '/' . $request->sourceFolder);
        $this->returnData->destinationPath = strtolower( session('companyCode') . '/' . $request->destinationFolder);

        $source = 'uploads/' .  $this->returnData->sourcePath . '/' . $request->sourceFileName;
        $destination = 'uploads/' .  $this->returnData->destinationPath . '/' . $request->destinationFileName;

        //Don't need this in production because the user can never open the file on the Server
        if ( !Utils::isWritable($destination) ) {

            $this->returnData->error = $request->destinationFileName . ' is being used by another program';

            return json_encode($this->returnData);            

        }

        Settings::setOutputEscapingEnabled(true);        
        
        $this->templateProcessor = new DocumentAssembly($source);

        $this->templateProcessor->prepareIfBlocks();

        $this->analyzeDocument();

        $this->getRequiredData();
        
        $this->replaceIfBlocks();

        $this->replaceFields();

        $this->templateProcessor->saveAs($destination);

        return json_encode($this->returnData);

    }

    protected function analyzeDocument() {

        $this->fields = $this->returnData->fields = $this->templateProcessor->getVariables();
        
        foreach($this->fields as $field) {
        
            if ( preg_match('/(\w+)-&gt;(\w+)/', $field, $splitField) ) {

                if ( property_exists($this, $splitField[1]) && !in_array($splitField[1], $this->tables)) array_push($this->tables, $splitField[1]);

            }

        }

        $ifBlocks = $this->templateProcessor->getIfBlocks();

        foreach ($ifBlocks as $ifBlock) {

            preg_match_all('/(\w+)-&gt;(\w+)/', $ifBlock['contents'], $splitFields);

            foreach ($splitFields[1] as $field) {

                if ( property_exists($this, $field) && !in_array($field, $this->tables) ) array_push($this->tables, $field);

            }

        }

        $this->returnData->tables = $this->tables;   

    }


    protected function getRequiredData() {

        foreach($this->tables as $table) {

            if ( $table === 'employee') {

                $this->employee = array(
                    'employee-&gt;name' => session('employeeName'), 
                    'employee-&gt;email' => session('employeeEmail') 
                );

            } else if ( $table === 'company') {

                $companyRequest = new Request;
                $companyRequest->dataFormat = 'mergeArray';

                $CompanyController = new CompanyController;
                $data = $CompanyController->get($companyRequest);
                $this->company = (array) $data[0];

            } else if ( $table === 'matter') {

                $matterRequest = new Request;
                $matterRequest->id = '2';
                $matterRequest->dataFormat = 'mergeArray';

                $MatterController = new MatterController;
                $data = $MatterController->get($matterRequest);
                $this->matter = (array) $data[0];

            }
        }
    }


    protected function replaceFields() {

        foreach($this->tables as $table) {

            if ( $table === 'employee') {

                $this->templateProcessor->setValues($this->employee);

            } else if ( $table === 'company') {

                $this->templateProcessor->setValues($this->company);

            } else if ( $table === 'matter') {

                $this->templateProcessor->setValues($this->matter);

            }
        }

    }

    protected function replaceIfBlocks() {

        $ifBlocks = $this->templateProcessor->getIfBlocks();

        foreach ($ifBlocks as $ifBlock) {

            $contents = $ifBlock['contents'];

            if ( $this->checkIfBlockValid($contents) ) {

                $contents = $this->convertSmartQuotes($contents);

                $contents = $this->convertEqualsSign($contents);

                $contents = $this->replaceDataReferences($contents);

                $result = eval('return ' . $contents . ';');

                logger('Eval result',[$contents,$result]);

                if ( is_bool($result) ) {

                    if ($result) {

                        $this->templateProcessor->toggleIfBlock($ifBlock['id'], 'enable');

                    } else {

                        $this->templateProcessor->toggleIfBlock($ifBlock['id'], 'delete');

                    }

                } else {

                    $this->returnData->error .= '<br>An error was found in the following if statement.<br><br><strong>' . $ifBlock['contents'] . '</strong><br><br>It must return true or false.';
                }

            } else {

                $this->templateProcessor->toggleIfBlock($ifBlock['id'], 'delete');

            }

        }      

    }

    protected function checkIfBlockValid($ifBlockContents)
    {

        $returnValue = true;

        // For security purposes:
        // 1) Don't allow $_ ; or || or die( or exit( or fopen(
        // 2) Don't allow HereDoc <<< i.e. &lt;&lt;&lt;

        

        // Using this regex to get all the fields in an IfBlock:

        // #STEP 1 - Find all ???->???
        // preg_match_all('/\w+-&gt;\w+/', $input_lines, $output_array);$output_array;
        // => [
        //      [
        //        "matter-&gt;branchId",
        //        "foo-&gt;fileRef",
        //      ],
        //    ]

        // #STEP 2 - loop through the list
        // preg_match('/(\w+)-&gt;(\w+)/', $output_array[0][0],$output_array0);$output_array0
        // => [
        //      "matter-&gt;branchId",
        //      "matter",
        //      "branchId",
        //    ]
        // >>> preg_match('/(\w+)-&gt;(\w+)/', $output_array[0][1],$output_array0);$output_array0
        // => [
        //      "foo-&gt;fileRef",
        //      "foo",
        //      "fileRef",
        //    ]        

        preg_match_all('/\w+-&gt;\w+/', $ifBlockContents, $allIfBlockFields);

        $ifBlockFields = $allIfBlockFields[0];

        foreach ($ifBlockFields as $ifBlockField) {

            preg_match('/(\w+)-&gt;(\w+)/', $ifBlockField, $splitField);

            //logger('CHECKING IfBlock field '. $splitField[1] . '->' . $splitField[2]);

            if ( property_exists($this, $splitField[1]) ) {

                if ( !isset( $this->{$splitField[1]}[$splitField[1] . '-&gt;' . $splitField[2]] ) ) {
                    
                    logger( $splitField[2] . ' is not a field in ' . $splitField[1]  );

                    return false;

                }

            } else {

                logger($splitField[1] . ' is not a table');

                return false;

            }

        }

        return $returnValue;

    } 

    protected function replaceDataReferences($string) 
    {
        
        //Example: $ifBlock = "matter->branchDescription = "Head Office" OR matter->branchDescription = "Durban"

        //$string = preg_replace('/([a-zA-Z]*)-&gt;([a-zA-Z]*)/', '$this->$1["$1.$2"]', $string);
        $string = preg_replace('/(\w+)-&gt;(\w+)/', '$this->$1["$1-&gt;$2"]', $string);
        

        return $string;

    }

    protected function convertEqualsSign($string) 
    { 

        // Use preg_replace to make this more flexible
        $string = preg_replace('/([a-zA-Z0-9 ]*+)(?:=)([a-zA-Z0-9 ]*+)/', '$1 == $2', $string);

        // OLD WAY:
        //$string = str_replace(' = ', ' == ', $string);

        return $string;

    }

    protected function convertSmartQuotes($string) 
    { 

        $search = array('‘', '’', '“', '”');
        $replace = array("'", "'",'"', '"');

        $string = str_replace($search, $replace, $string); 

        return $string;

    }

        /*********************TESTING REPEAT ************************ */

        // $replacements = array(
        //     array('matter.fileRef' => 'Batman', 'matter.description' => 'Gotham City'),
        //     array('matter.fileRef' => 'Superman', 'matter.description' => 'Metropolis'),
        // );
        // $this->templateProcessor->cloneBlock(preg_quote('repeat(Matter)'), 0, true, false, $replacements);  

        /********************************************* */

}
