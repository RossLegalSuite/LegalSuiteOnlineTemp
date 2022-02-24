<?php

namespace App\Custom;

class DocumentAssembly extends \PhpOffice\PhpWord\TemplateProcessor

{

    /*******************************************************************************/
    //  Inherited & extended certian methods in \PhpOffice\PhpWord\TemplateProcessor
    /*******************************************************************************/

    protected function fixBrokenMacros($documentPart)
    {

        

        // Note: This is called in the Constructor
        
        // 31 May 2020 - Taken out because it was finding actual Docx XML between {(.*){ and [(.*)[ and breaking the document
        //$documentPart = $this->fixBrokenBrackets($documentPart);

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
        
        // protected function fixBrokenBrackets($documentPart)
        // {
            
        //     // Remove any XML between {...{, }...}, [...[, ]...]
            
        //     return preg_replace_callback(
        //         '/\{(?:.*)\{|}(?:[^{]*)}|\[(?:.*)\[|](?:[^[]*)]/U',
        //         function ($match) {
        //         logger('Stripping out between {...{, }...}, [...[, ]...]',[substr($match[0],0,100) ]);
        //         return strip_tags($match[0]);
        //     },
        //     $documentPart
        // );
    


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

    // public function findField($search, $offset = 0)
    // {
    //     $search = static::ensureMacroCompleted($search);
    //     $pos = strpos($this->tempDocumentMainPart, $search, $offset);

    //     return ($pos === false) ? -1 : $pos;
    // }


    /*********************************************
    * END OVERRIDES
    **********************************************/

    public function getPart( $part ) {

        if ( $part === 'Main') {

            return $this->tempDocumentMainPart;

        } else if ( $part === 'Headers') {

            return $this->tempDocumentHeaders;

        } else if ( $part === 'Footers') {

            return $this->tempDocumentFooters;

        }
        
    }

    public function setPart( $part, $xml, $index = 1 ) {

        if ( $part === 'Main') {

            $this->tempDocumentMainPart = $xml;

        } else if ( $part === 'Headers') {

            $this->tempDocumentHeaders[$index] = $xml;

        } else if ( $part === 'Footers') {

            $this->tempDocumentFooters[$index] = $xml;

        }
        
    }



}
