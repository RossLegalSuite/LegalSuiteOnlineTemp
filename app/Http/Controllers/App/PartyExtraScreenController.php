<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PartyExtraScreenController extends Controller
{
    private function addColumns(&$query)
    {
        $query->addSelect('party_extra_screens.id as id');
        $query->addSelect('party_extra_screens.extraScreenId as extraScreenId');
        $query->addSelect('party_extra_screens.partyId as partyId');
        $query->addSelect('party_extra_screens.name as name');
        $query->addSelect('party_extra_screens.value as value');
        $query->addSelect('extra_screen_fields.type as type');
    }

    private function tableJoins(&$query)
    {
        $query->join('extra_screen_fields', function ($join) {
            $join->on('extra_screen_fields.extraScreenId', '=', 'party_extra_screens.extraScreenId')
                ->on('extra_screen_fields.name', '=', 'party_extra_screens.name');
        });
    }

    public function get(Request $request)
    {
        $query = DB::table('party_extra_screens');

        $this->addColumns($query);

        $this->tableJoins($query);

        if ($request->id) {
            $query->where('party_extra_screens.id', $request->id);
        }

        if ($request->extraScreenId) {
            $query->where('party_extra_screens.extraScreenId', $request->extraScreenId);
        }

        if ($request->parentId) {
            $query->where('party_extra_screens.partyId', $request->parentId);
        }

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }
}
