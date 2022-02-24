<?php

namespace App\Http\Controllers\App;

use App\Models\MatterEmployee;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Support\Facades\Validator;
//use Illuminate\Validation\Rule;


class MatterEmployeeController extends Controller {

    private function addColumns(&$query)
    {

        $query->addSelect('matter_employees.*');
            
        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
        $query->addSelect( "employees.name as name");
        $query->addSelect( "employee_roles.description as role");

    }

    public function get(Request $request)
    {

        $query = DB::table('matter_employees')
        ->join('matters', 'matters.id', '=', 'matter_employees.matterId')
        ->join('employees', 'employees.id', '=', 'matter_employees.employeeId')
        ->join('employee_roles', 'employee_roles.id', '=', 'matter_employees.roleId');
    
        $this->addColumns($query);

        if ($request->id) $query->where('matter_employees.id',$request->id);

        if ($request->matterId) $query->where('matter_employees.matterId',$request->matterId);

        if ($request->employeeId) $query->where('matter_employees.employeeId',$request->employeeId);

        if ($request->roleId) $query->where('matter_employees.roleId',$request->roleId);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }

    public function moveUp(Request $request)
    {

        $returnData = new \stdClass();
        $returnData->error = null;

        try {

            return DB::transaction( function() use ($returnData, $request)
            {

                $matterEmployee1 = MatterEmployee::find($request->id);
        
                $matterEmployee2 = MatterEmployee::where('matterId',$matterEmployee1->matterId)
                ->where('roleId',$matterEmployee1->roleId)
                ->where('rank',$matterEmployee1->rank - 1)
                ->first();

                if ( !$matterEmployee1 ) {

                    $returnData->error = 'First Employee not found';

                } else if ( !$matterEmployee2 ) {

                    $returnData->error = 'Second Employee not found';

                } else {
        
                    $rank1 = $matterEmployee1->rank;
                    $rank2 = $matterEmployee2->rank;

                    // Not needed because in a Transaction
                    // $matterEmployee2->rank = 0;
                    // $matterEmployee2->save();
            
                    $matterEmployee1->rank = $rank2;
                    $matterEmployee1->save();
            
                    $matterEmployee2->rank = $rank1;
                    $matterEmployee2->save();

                }

                return json_encode($returnData);

            });
    
        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = Utils::MySqlError($e);
            return json_encode($returnData);            

        }




    }

    public function store(Request $request)
    {

        $returnData = new \stdClass();
        
        $data = $request->all();

        $rules = [
            'matterId' => 'required',
            'employeeId' => 'required',
            'roleId' => 'required',
            'rank' => 'numeric|required',
        ];
        
        $messages = [
            'matterId.required' => 'No Matter was specified',
            'employeeId.required' => 'Please select a Employee',
            'roleId.required' => 'Please select a Role for this Employee',
            'rank.required' => 'Please provide a Rank for this Employee',
            'rank.numeric' => 'The Rank must be numeric',
        ];


        $validator = Validator::make($data, $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            
           
        }


        // Check if adding a second Owner

        //$ownerRole = DB::table('employee_roles')->where('code', 'OWNER')->first();

        if ( $request->roleId == session('ownerRoleId') ) {

            $query = MatterEmployee::where('matterId',$request->matterId)
            ->where('roleId',$request->roleId);

            if ( isset($request->id) ) $query->where('id','<>',$request->id);
            
            $existingOwnerRole = $query->first();
    
            if ( $existingOwnerRole ) {

                $validator->errors()->add('duplicate', '<p>This Matter already has a Owner assigned to it.</p><p>A Matter can only have one Owner.</p>');

                $returnData->errors = $validator->errors();
    
                return json_encode($returnData);            
    
            }

        }

        // Check for duplicate Employee Roles
        $query = MatterEmployee::where('matterId',$request->matterId)
        ->where('employeeId',$request->employeeId)
        ->where('roleId',$request->roleId);

        if ( isset($request->id) ) $query->where('id','<>',$request->id);

        $existingEmployeeRole  = $query->first();

        if ( $existingEmployeeRole ) {

            $validator->errors()->add('duplicate', 'This Employee has already been assigned this Role on this Matter');

            $returnData->errors = $validator->errors();

            return json_encode($returnData);            

        }


        try {
        
            if ( isset($request->id) ) {
                $matterEmployee = MatterEmployee::find($request->id);
            } else {
                $matterEmployee = new MatterEmployee;
            }

            $matterEmployee->matterId = $request->matterId;
            $matterEmployee->employeeId = $request->employeeId;
            $matterEmployee->roleId = $request->roleId;
            $matterEmployee->rank = $request->rank;

            $matterEmployee->save();


            $matterEmployees = MatterEmployee::where('matterId',$request->matterId)
            ->orderBy('roleId')
            ->orderBy('rank')
            ->get();

            $correctRank = 0;
            $thisRoleId = null;

            foreach ($matterEmployees as $matterEmployee) {

                //logger('$matterEmployee roleId/rank',[$matterEmployee->roleId,$matterEmployee->rank]);

                if ( (int) $matterEmployee->roleId !== $thisRoleId) {
                    $thisRoleId = $matterEmployee->roleId;
                    $correctRank = 0;
                }

                $correctRank++;

                if ( (int) $matterEmployee->rank !== $correctRank) {

                    //logger('Would have corrected',[$matterEmployee->roleId,$matterEmployee->rank, $correctRank]);

                    $matterEmployee->rank = $correctRank;
                    $matterEmployee->save();

                }
                
            }        



            return json_encode($matterEmployee);

        } catch (\Illuminate\Database\QueryException $e) {

            $validator->errors()->add('general', Utils::MySqlError($e));

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        


    }



    public function destroy(Request $request)
    {

        $returnData = new \stdClass();
        $returnData->error = null;

        try {

            return DB::transaction( function() use ($returnData, $request)
            {

                MatterEmployee::findOrFail($request->id)->delete();

                // Adjust the ranking of the other Employees with this Role
                $matterEmployees = MatterEmployee::where('matterId',$request->matterId)
                ->where('roleId',$request->roleId)
                ->orderBy('rank')
                ->get();

                $correctRank = 0;
    
                foreach ($matterEmployees as $matterEmployee) {

                    $correctRank++;

                    if ( (int) $matterEmployee->rank !== $correctRank) {

                        $matterEmployee->rank = $correctRank;
                        $matterEmployee->save();

                    }
                    
                }        

                return json_encode($returnData);

            });
            
        } catch (\Illuminate\Database\QueryException $e) {

            $returnData->error = Utils::MySqlError($e);
            return json_encode($returnData);            

        } catch (\Exception $e) {

            $returnData->error = $e->getMessage();
            return json_encode($returnData);            

        }

    }


    public function getTablePosition(Request $request)
    {

        return DB::table('matter_employees')
        ->where('matterId', $request->matterId)
        ->where('rank', '<' , $request->rank)
        ->orderBy('employeeId')
        ->orderBy('roleId')
        ->count();

    }    

}
