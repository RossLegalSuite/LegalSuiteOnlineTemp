<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\Country;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CountryController extends Controller
{
    public function getCountries(Request $request)
    {
        $columns = 'countries.id';
        $columns .= ', countries.code';
        $columns .= ', countries.description';

        $query = DB::table('countries')->selectRaw($columns);

        if ($request->id) {
            $query->where('countries.id', $request->id);
        }

        if ($request->code) {
            $query->where('countries.code', $request->code);
        }

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

    public function show(Country $country)
    {
        //
    }

    public function edit(Country $country)
    {
        return $country;
    }

    public function update(Request $request, Country $country)
    {
        //
    }

    public function destroy(Country $country)
    {
        //
    }
}
