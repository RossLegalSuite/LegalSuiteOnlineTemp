<?php

namespace App\Http\Controllers\App;

use App\Models\Province;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Support\Facades\Validator;

class ProvinceController extends Controller {


    public function getProvinces(Request $request)
    {

        $columns = "provinces.id";
        $columns .= ", provinces.code";
        $columns .= ", provinces.description";
        $columns .= ", provinces.countryCode";

        $query = DB::table('provinces')->selectRaw($columns);

        if ($request->id) $query->where('provinces.id',$request->id);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }

    public function create()
    {
        //
    }


    public function store(Request $request)
    {
        //
    }

    public function show(Province $province)
    {
        //
    }

    public function edit(Province $province)
    {

        
    }

    public function update(Request $request, Province $province)
    {
        //
    }

    public function destroy(Province $province)
    {
        //
    }
}
