<?php

namespace App\Custom;

class DocumentAssembly extends \PhpOffice\PhpWord\TemplateProcessor

{

    /*******************************************************************************/
    //  Inherited & extended certian methods in \PhpOffice\PhpWord\TemplateProcessor
    /*******************************************************************************/

    protected $ifBlocks = array();

    /*********************************************
    * OVERRIDES
    **********************************************/

    protected function fixBrokenMacros($documentPart)
    {

        // Note: This is called in the Constructor
        // ORIGINAL REGEX FROM TemplateProcessor   '/\{(?:\{|[^{]*\>\{)[^}]*\}\}/U',

        $documentPart = $this->fixBrokenBrackets($documentPart);

        $documentPart = $this->fixBrokenBlocks($documentPart);

        // Remove any XML between {{...}}

        return preg_replace_callback(
            '/\{\{(.*)\}\}/U',
            function ($match) {
                return strip_tags($match[0]);
            },
            $documentPart
        );
    }

    protected function fixBrokenBrackets($documentPart)
    {

        // Remove any XML between {...{, }...}, [...[, ]...]

        return preg_replace_callback(
            '/\{(?:.*)\{|}(?:[^{]*)}|\[(?:.*)\[|](?:[^[]*)]/U',
            function ($match) {
                return strip_tags($match[0]);
            },
            $documentPart
        );
    }


    protected function fixBrokenBlocks($documentPart)
    {

        // Remove any XML between [[...]]

        return preg_replace_callback(
            '/\[\[(.*)]]/U',
            function ($match) {
                return strip_tags($match[0]);
            },
            $documentPart
        );

    }


    protected function getVariablesForPart($documentPartXML)
    {

        preg_match_all('/\{\{(.*?)}}/', $documentPartXML, $matches);
        
        return $matches[1];
    }

    protected static function ensureMacroCompleted($macro)
    {
        if (substr($macro, 0, 2) !== '{{' && substr($macro, -2) !== '}}') {
            $macro = '{{' . $macro . '}}';
        }

        return $macro;
    }



    /*********************************************
    * END OVERRIDES
    **********************************************/


    public function getIfBlocks()
    {
        return $this->ifBlocks;
    }

    public function prepareIfBlocks()
    {
        
        $this->tempDocumentMainPart = $this->prepareIfBlock($this->tempDocumentMainPart, 'MainPart');
        
    }

    protected function prepareIfBlock($documentPart, $location)
    {


        $regex = '/\[\[if\(([^[]*)\)]]/';

        return preg_replace_callback(

            $regex,

            function ($match) use ($location) {

                static $id = 0;

                $id++;

                $this->ifBlocks[] = array('id' => $id, 'contents' => strip_tags($match[1]), 'location' => $location);

                return '[[if(' . $id . ')]]';

            },

            $documentPart
        );

    }



    public function toggleIfBlock($blockId, $method)
    {

        //logger('------------------ toggleIfBlock ---------------------------');

        //$regex = '/\[\[if\(' . $blockId . '\)\]\](.*)\[\[endif\]\]/U';
        
        //*********ABOVE NOT WORKING - UNGREEDY MATCHES THE ENDIF OF THE NESTED IF **********************************************************

        //Nested example: Some text[[if(target1)]]no children in here[[endif]]Some text[[if(target2)]]some text[[if(target3)]]Nested inside another target[[endif]]some text [[endif]]Some other text[[if(target4)]]no children in here[[endif]]some other text

        //See: https://regex101.com/r/AgGQSl/3

        //27 May 2020: Used CodeMentor (https://www.codementor.io/@wiktor.stribizew) to get a regex expert to design recursive regex to solve getting nested IF BLOCKS

        // He provided this regex101 test case
        //https://regex101.com/r/AgGQSl/4 - working example

        // He also provided the solution to test in PHP:
        // $blockId = "target2";
        // $text = "Some text[[if(target1)]]no children in here[[endif]]Some text[[if(target2)]]some text[[if(target3)]]Nested inside another target[[endif]]some text [[endif]]Some other text[[if(target4)]]no children in here[[endif]]some other text";
        // $regex = "~(?=\[\[if\(" . $blockId . "\)]])(\[\[if\(target\d+\)]]((?:(?!\[\[if\().|(?1))*?)\[\[endif]])~s";
        // if (preg_match($regex, $text, $match)) {
        //   echo $match[2];
        // }

        //******************************************************************************************************************************

        $regex = '~(?=\[\[if\(' . $blockId . '\)]])(\[\[if\(\d+\)]]((?:(?!\[\[if\().|(?1))*?)\[\[endif]])~s';

        if ( preg_match($regex, $this->tempDocumentMainPart, $match) ) {

            //logger('Found the If Block TO TOGGLE $match',[$match[1],$match[2]]);

            if ($method === 'enable') {

                $this->tempDocumentMainPart = str_replace($match[1], $match[2], $this->tempDocumentMainPart);

            } else if ($method === 'delete') {

                $this->tempDocumentMainPart = str_replace($match[1], '', $this->tempDocumentMainPart);

            }

        } else {

            logger('Could not ' . $method . ' if(' . $blockId . ')???',[$regex, $this->tempDocumentMainPart]);
        }

        //logger('$this->tempDocumentMainPart',[$this->tempDocumentMainPart]);

    }

    public function getPart( $part ) {

        if ( $part === 'Main') {

            return $this->tempDocumentMainPart;

        } else if ( $part === 'Headers') {

            return $this->tempDocumentHeaders;

        } else if ( $part === 'Footers') {

            return $this->tempDocumentFooters;

        }
        
    }

    public function setPart( $part, $xml ) {

        if ( $part === 'Main') {

            $this->tempDocumentMainPart = $xml;

        } else if ( $part === 'Headers') {

            $this->tempDocumentHeaders = $xml;

        } else if ( $part === 'Footers') {

            $this->tempDocumentFooters = $xml;

        }
        
    }


    //********************************************************************************************** */
    // Deprecate???
    //********************************************************************************************** */
    // public function getAllParagraphs()
    // {

    //     preg_match_all('/\<w:p .*\<\/w:p\>/U', $this->tempDocumentMainPart, $matches);
        
    //     return $matches[0];
        
    // }

    // protected function getIfBlockContentsForPart($documentPartXML)
    // {

    //     preg_match_all('/\[\[if\(([^[]*)\)\]\]/', $documentPartXML, $matches); 

    //     return $matches[1];

    // }

    // public function getIfBlockContents()
    // {
    //     $ifBlocks = $this->getIfBlockContentsForPart($this->tempDocumentMainPart);

    //     foreach ($this->tempDocumentHeaders as $headerXML) {
    //         $ifBlocks = array_merge(
    //             $ifBlocks,
    //             $this->getIfBlockContentsForPart($headerXML)
    //         );
    //     }

    //     foreach ($this->tempDocumentFooters as $footerXML) {
    //         $ifBlocks = array_merge(
    //             $ifBlocks,
    //             $this->getIfBlockContentsForPart($footerXML)
    //         );
    //     }

    //     return $ifBlocks;
    // }

    // public function fixBrokenBlocks()
    // {
    //     $this->tempDocumentMainPart = $this->fixBrokenBlock($this->tempDocumentMainPart);

    //     foreach ($this->tempDocumentHeaders as $headerXML) {
    //         $headerXML = $this->fixBrokenBlock($headerXML);
    //     }

    //     foreach ($this->tempDocumentFooters as $footerXML) {
    //         $footerXML = $this->fixBrokenBlock($footerXML);
    //     }
    // }

    // public function replaceBlock($blockname, $replacement)
    // {
    //     // Source code version can fail if there are <w:pPr> elements above
    //     //'/(<\?xml.*)(<w:p.*>\${' . $blockname . '}<\/w:.*?p>)(.*)(<w:p.*\${\/' . $blockname . '}<\/w:.*?p>)/is',

    //     // Tried this and it failed to pick up the parent <w:p> causing malformed XML
    //     //(<\?xml.*)(<w:p.*>\${branch}<\/w:.*?p>)(.*)(<w:p.*\${\/branch}<\/w:.*?p>)

    //     // Modified to this which works better
    //     //(<\?xml.*)(<w:p .*>.*<w:t>\${branch}<\/w:.*?p>)(.*)(<w:p.*\${\/branch}<\/w:.*?p>)

    //     //logger('BEFORE $this->tempDocumentMainPart',[$this->tempDocumentMainPart]);

    //     $matches = array();
    //     preg_match(
    //         '/(<\?xml.*)(<w:p .*>.*<w:t>\{\{' . $blockname . '}}<\/w:.*?p>)(.*)(<w:p.*\{\{\/' . $blockname . '}}<\/w:.*?p>)/is',
    //         $this->tempDocumentMainPart,
    //         $matches
    //     );

    //     if (isset($matches[3])) {
    //         $this->tempDocumentMainPart = str_replace(
    //             $matches[2] . $matches[3] . $matches[4],
    //             $replacement,
    //             $this->tempDocumentMainPart
    //         );
    //     }

    //     //logger('AFTER $this->tempDocumentMainPart',[$this->tempDocumentMainPart]);
    // }


        /************Regex Used****************
        \[
        (?:.*)\[
        (?:
        (?:.*)i
        (?:.*)f
        (?:.*)\(
        |
        (?:.*)e
        (?:.*)n
        (?:.*)d
        (?:.*)i
        (?:.*)f
        )
        (?:[^[]*)\]
        (?:.*)\]        
        ****************************/


}
