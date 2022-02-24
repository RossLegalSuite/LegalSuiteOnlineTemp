<?php

namespace App\Http\Controllers\App;

use App\Models\ContactMethod;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Support\Facades\Validator;

class ContactMethodController extends Controller {


    public function get(Request $request)
    {

        $columns = "contact_methods.id";
        $columns .= ", contact_methods.type";
        $columns .= ", contact_methods.description";

        $query = DB::table('contact_methods')->selectRaw($columns);

        if ($request->id) $query->where('contact_methods.id',$request->id);

        if ($request->type) $query->where('contact_methods.type',$request->type);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }
}
