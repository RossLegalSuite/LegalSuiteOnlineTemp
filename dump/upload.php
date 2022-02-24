<?php

    try {

        $url = 'https://legalsuitestaging.co.za/utils/uploaddocumenttodoclog';

        $apiToken = "+KSOwaTiDrKED7pa3O6vkhQCx7GL8F2movnEAvlJ8odRGzcyBMW69tyufTboc0gXqnMEe7nTctMfIZi4GEL38A==";
    
        $fileContents = file_get_contents($_FILES["fileToUpload"]["tmp_name"]);

        $fields = array(
            'matterfileref'=> $_POST["fileRef"],
            'employeelogin'=> $_POST["employeeLogin"],
            'description'=> $_POST["description"],
            'filename' => $_FILES["fileToUpload"]["name"],
            'filecontents'=> $fileContents,
        );
    
        $postFields = http_build_query($fields);

        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30000,
            CURLOPT_CONNECTTIMEOUT => 30000,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $postFields,
            CURLOPT_HTTPHEADER => array(
                'Authorization: Bearer ' . $apiToken,
                'Content-Type: application/x-www-form-urlencoded',
                'Expect: 100-continue'
            ),
        ));

        $curlResponse = curl_exec($curl);

        if ( curl_errno($curl) ) {
        
            echo 'Could not connect to ' . $url; 
            curl_close($curl); 

        } else {

            echo $curlResponse;

        }

        curl_close($curl);

    } catch(\Exception $e)  {

        echo 'Error on line '.$e->getLine().' in '.$e->getFile() .': <br/>'.$e->getMessage();

    }

?>