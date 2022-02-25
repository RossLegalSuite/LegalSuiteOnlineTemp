<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use Illuminate\Http\Request;

class GenericTableController extends Controller
{
    public function get(Request $request, $tableName, $id = null)
    {
        try {

            // If these are sent in the request
            if (isset($request->tableName)) {
                $tableName = $request->tableName;
            }
            if (isset($request->recordid)) {
                $id = $request->recordid;
            }

            $apiUrl = '/'.strtolower($tableName).'/get';

            if (isset($id)) {
                $apiUrl .= '/'.$id;
            }

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function store(Request $request, $tableName)
    {
        $apiUrl = '/'.strtolower($tableName).'/';

        if (isset($request->recordid)) {
            $apiUrl .= 'update';
        } else {
            $apiUrl .= 'store';
        }

        $postFields = http_build_query($request->all());

        $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

        return json_encode($response);
    }

    public function storeRecords(Request $request, $tableName)
    {
        $apiUrl = '/'.strtolower($tableName).'/storerecords';

        // http_build_query ignores nulls
        //$postFields = http_build_query($request->all());

        // Using this custom buildQuery function instead
        $postFields = $this->buildQuery($request->all());

        $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

        return json_encode($response);
    }

    public function update(Request $request, $tableName)
    {
        $apiUrl = '/'.strtolower($tableName).'/update';

        // http_build_query ignores nulls
        //$postFields = http_build_query($request->all());

        // Using this custom buildQuery function instead
        $postFields = $this->buildQuery($request->all());

        $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

        return json_encode($response);
    }

    private function buildQuery($input, $numeric_prefix = '', $arg_separator = '&', $enc_type = 2, $keyvalue_separator = '=', $prefix = '')
    {

        //https://stackoverflow.com/questions/2930592/http-build-query-ignores-the-key-if-the-value-is-an-empty-array-how-is-this-not

        if (is_array($input)) {
            $arr = [];
            foreach ($input as $key => $value) {
                $name = $prefix;
                if (strlen($prefix)) {
                    $name .= '[';
                    if (! is_numeric($key)) {
                        $name .= $key;
                    }
                    $name .= ']';
                } else {
                    if (is_numeric($key)) {
                        $name .= $numeric_prefix;
                    }
                    $name .= $key;
                }
                if ((is_array($value) || is_object($value)) && count($value)) {
                    $arr[] = $this->buildQuery($value,$numeric_prefix,
                            $arg_separator,$enc_type,
                            $keyvalue_separator, $name);
                } else {
                    if ($enc_type === 2) {
                        $arr[] = rawurlencode($name)
                            .$keyvalue_separator
                            .rawurlencode($value ?: '');
                    } else {
                        $arr[] = urlencode($name)
                            .$keyvalue_separator
                            .urlencode($value ?: '');
                    }
                }
            }

            return implode($arg_separator, $arr);
        } else {
            if ($enc_type === 2) {
                return rawurlencode($input);
            } else {
                return urlencode($input);
            }
        }
    }

    public function getTemplateData(Request $request, $tableName, $id)
    {
        try {
            $apiUrl = '/'.strtolower($tableName).'/gettemplatedata/'.$id;

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function first(Request $request, $tableName)
    {
        try {
            $apiUrl = '/'.strtolower($tableName).'/first';

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function copy(Request $request, $tableName)
    {
        try {
            $apiUrl = '/'.strtolower($tableName).'/copy';

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function delete(Request $request, $tableName, $id)
    {
        try {
            $apiUrl = '/'.strtolower($tableName).'/delete/'.$id;

            $postFields = http_build_query($request->all());

            $response = Utils::SetCurlParams($apiUrl, 'POST', $postFields);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData['errors'] = $e->getMessage();

            return json_encode($returnData);
        }
    }
}
