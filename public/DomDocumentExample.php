<?php
//$source = __DIR__ . '\uploads\acme\documents\block.docx';
$source = __DIR__ . '\uploads\acme\documents\matters.docx';
echo $source . "<br/>";
$zip = new ZipArchive;
$zip->open($source);

if (($index = $zip->locateName("word/document.xml")) !== false) {
    $text = $zip->getFromIndex($index);
    $domDocument = new \DOMDocument;
    $xml = $domDocument->loadXML($text, LIBXML_PARSEHUGE | LIBXML_NOENT | LIBXML_XINCLUDE | LIBXML_NOERROR | LIBXML_NOWARNING);
}

$xpath = new DOMXpath($domDocument);
$zip->close();

echo $domDocument->saveXML();
//$start = $domDocument->documentElement;

//fc($start);

// Easy function for basic output of XML file via DOM parsing
function fc($node) {
  $child = $node->childNodes;
  foreach($child as $item) {
    if ($item->nodeType == XML_TEXT_NODE) {
      if (strlen(trim($item->nodeValue))) echo trim($item->nodeValue)."<br/>";
    }
    else if ($item->nodeType == XML_ELEMENT_NODE) fc($item);
  }
}
