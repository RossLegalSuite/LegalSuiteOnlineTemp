<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;

class MatterExtraScreenController extends Controller {
    
    private function addColumns(&$query)
    {
        $query->addSelect('matter_extra_screens.id');
        $query->addSelect('matter_extra_screens.extraScreenId');
        $query->addSelect('matter_extra_screens.matterId');
        $query->addSelect('matter_extra_screens.name');
        $query->addSelect('matter_extra_screens.value');
        $query->addSelect('extra_screen_fields.type');

    }

    private function tableJoins(&$query)
    {

        $query->join('extra_screen_fields', function ($join) {
            $join->on('extra_screen_fields.extraScreenId', '=', 'matter_extra_screens.extraScreenId')
                ->on('extra_screen_fields.name', '=', 'matter_extra_screens.name');
        });

    }    

    public function get(Request $request)
    {

        $query = DB::table('matter_extra_screens');

        $this->addColumns($query);

        $this->tableJoins($query);

        if ($request->id) {
            $query->where('matter_extra_screens.id',$request->id);
        } 
        
        if ($request->extraScreenId) {
            $query->where('matter_extra_screens.extraScreenId',$request->extraScreenId);
        }    

        if ($request->parentId) {
            $query->where('matter_extra_screens.matterId',$request->parentId);
        }    

        if ($request->dataFormat === "dataTables") {

            $datatables = Datatables::of($query);

            return $datatables->make(true);

        } else  {

            return DataTablesHelper::ReturnData($query, $request);
        }
    }


}
