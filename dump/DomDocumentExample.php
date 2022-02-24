<?php
// Load from a docx
$source = __DIR__ . '\public\uploads\acme\documents\block.docx';
$zip = new ZipArchive;
$zip->open($source);

if (($index = $zip->locateName("word/document.xml")) !== false) {
    $text = $zip->getFromIndex($index);
    $domDocument = new \DOMDocument;
    $xml = $domDocument->loadXML($text, LIBXML_PARSEHUGE | LIBXML_NOENT | LIBXML_XINCLUDE | LIBXML_NOERROR | LIBXML_NOWARNING);
}
$zip->close();

//... OR load from text
$domDocument = new \DOMDocument;
$text = '<w:body><w:p w14:paraId="694099BC" w14:textId="57E9CA6C" w:rsidR="00F00753" w:rsidRDefault="00F91FF8" w:rsidP="00F91FF8"><w:r><w:t>**</w:t></w:r><w:r w:rsidRPr="00DB4D73"><w:rPr><w:b/><w:bCs/><w:color w:val="00B050"/></w:rPr><w:t>[</w:t></w:r><w:r w:rsidRPr="00C458B0"><w:rPr><w:b/><w:bCs/></w:rPr><w:t>[</w:t></w:r><w:r w:rsidRPr="007E1AF5"><w:rPr><w:color w:val="FF0000"/></w:rPr><w:t>if(matter-&gt;branch</w:t></w:r><w:r w:rsidR="00902E1A" w:rsidRPr="007E1AF5"><w:rPr><w:color w:val="FF0000"/></w:rPr><w:t>Description = “</w:t></w:r><w:r w:rsidR="00902E1A" w:rsidRPr="00231C04"><w:rPr><w:color w:val="FF0000"/><w:highlight w:val="yellow"/></w:rPr><w:t>Head</w:t></w:r><w:r w:rsidR="00902E1A" w:rsidRPr="007E1AF5"><w:rPr><w:color w:val="FF0000"/></w:rPr><w:t xml:space="preserve"> Office”</w:t></w:r><w:r w:rsidRPr="007E1AF5"><w:rPr><w:color w:val="FF0000"/></w:rPr><w:t>)</w:t></w:r><w:r w:rsidRPr="00C458B0"><w:rPr><w:u w:val="single"/></w:rPr><w:t>]]</w:t></w:r><w:r w:rsidR="00231C04"><w:rPr><w:u w:val="single"/></w:rPr><w:t xml:space="preserve"> aaaaaa</w:t></w:r><w:r w:rsidR="00231C04" w:rsidRPr="00DB4D73"><w:rPr><w:color w:val="7030A0"/></w:rPr><w:t xml:space="preserve"></w:t></w:r><w:r w:rsidRPr="00DB4D73"><w:rPr><w:color w:val="7030A0"/></w:rPr><w:t>[</w:t></w:r><w:r><w:t>[</w:t></w:r><w:r w:rsidRPr="00DB4D73"><w:rPr><w:color w:val="C00000"/></w:rPr><w:t>endif]</w:t></w:r><w:r><w:t>]**</w:t></w:r></w:p><w:p w14:paraId="4CFC9FD5" w14:textId="7727A68C" w:rsidR="00FE5666" w:rsidRDefault="00FE5666" w:rsidP="00FE5666"><w:r w:rsidRPr="00FE5666"><w:rPr><w:highlight w:val="yellow"/></w:rPr><w:t>{</w:t></w:r><w:r><w:t>{employee-&gt;name</w:t></w:r><w:r w:rsidRPr="00FE5666"><w:rPr><w:color w:val="C00000"/></w:rPr><w:t>}</w:t></w:r><w:r><w:t>}</w:t></w:r><w:r w:rsidRPr="00FE5666"><w:rPr><w:highlight w:val="yellow"/></w:rPr><w:t>{</w:t></w:r><w:r><w:t>{employee-&gt;</w:t></w:r><w:r><w:t>email</w:t></w:r><w:r w:rsidRPr="00FE5666"><w:rPr><w:color w:val="C00000"/></w:rPr><w:t>}</w:t></w:r><w:r><w:t>}</w:t></w:r></w:p><w:p w14:paraId="3F076382" w14:textId="128C9063" w:rsidR="00FE5666" w:rsidRDefault="00FE5666" w:rsidP="00F91FF8"/><w:sectPr w:rsidR="00FE5666"><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/><w:cols w:space="708"/><w:docGrid w:linePitch="360"/></w:sectPr></w:body>';
$xml = $domDocument->loadXML($text, LIBXML_PARSEHUGE | LIBXML_NOENT | LIBXML_XINCLUDE | LIBXML_NOERROR | LIBXML_NOWARNING);



$xpath = new DOMXpath($domDocument);

echo $domDocument->saveXML();
$start = $domDocument->documentElement;
$child = $start->childNodes;
$zip->close();


// Easy function for basic output of XML file via DOM parsing

fc($start);

function fc($node) {
  $child = $node->childNodes;
  foreach($child as $item) {
    if ($item->nodeType == XML_TEXT_NODE) {
      if (strlen(trim($item->nodeValue))) echo trim($item->nodeValue)."<br/>";
    }
    else if ($item->nodeType == XML_ELEMENT_NODE) fc($item);
  }
}
