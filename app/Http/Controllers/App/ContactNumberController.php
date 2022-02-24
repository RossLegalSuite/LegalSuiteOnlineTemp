<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use App\Custom\Utils;


class ContactNumberController extends Controller {



    public function get(Request $request)
    {

        $query = DB::table('contact_numbers');

        $query->addSelect("contact_numbers.id")
        ->addSelect("contact_numbers.code")
        ->addSelect("contact_numbers.name")
        ->addSelect("contact_numbers.description")
        ->addSelect("contact_numbers.entity")
        ->addSelect("contact_numbers.type");

        if ($request->type) {
            $query->where('contact_numbers.type',$request->type);
        }    

        DataTablesHelper::AddCommonWhereClauses($query, $request);
        
        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            // if ($keyword = $request->get('search')['value'] ) {

            //     $datatables->filterColumn('billNumber', function($query, $keyword) {
            //         $sql = "CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END like ?";
            //         $query->whereRaw($sql, ["%{$keyword}%"]);
            //     })

            //     ->filterColumn('account', function($query, $keyword) {
            //         $sql = "CONCAT(accounts.code, ' - ', accounts.description) OR CONCAT(matters.fileRef, ' - ', matters.description) like ?";
            //         $query->whereRaw($sql, ["%{$keyword}%"]);
            //     });

            // }

            return $datatables->make(true);

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }

    }




}
