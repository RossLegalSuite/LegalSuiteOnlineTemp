<?php

namespace App\Custom;

use DB;

class DataTablesHelper
{
    public static function AddPartyJoins(&$query)
    {
        $query
        ->leftJoin('marriage_types', 'parties.marriageId', '=', 'marriage_types.id')
        ->leftJoin('party_entities', 'parties.entityId', '=', 'party_entities.id')
        ->leftJoin('party_types', 'parties.typeId', '=', 'party_types.id')
        ->leftJoin('provinces as physicalProvince', 'parties.physicalProvinceId', '=', 'physicalProvince.id')
        ->leftJoin('provinces as postalProvince', 'parties.postalProvinceId', '=', 'postalProvince.id')
        ->leftJoin('countries as physicalCountry', 'parties.physicalCountryId', '=', 'physicalCountry.id')
        ->leftJoin('countries as postalCountry', 'parties.postalCountryId', '=', 'postalCountry.id')

        ->leftJoin('party_numbers as emailAddress', function ($join) {
            $join->on('parties.id', '=', 'emailAddress.partyId')
                ->whereRaw('emailAddress.id IN (select max(id) from party_numbers WHERE methodId = '.session('emailMethodId').' AND partyId = parties.id AND defaultFlag = 1 group by methodId)');
        })
        ->leftJoin('party_numbers as mobileNumber', function ($join) {
            $join->on('parties.id', '=', 'mobileNumber.partyId')
                ->whereRaw('mobileNumber.id IN (select max(id) from party_numbers WHERE methodId = '.session('mobileMethodId').' AND partyId = parties.id AND defaultFlag = 1 group by methodId)');
        });
    }

    public static function AddMatterJoins(&$query)
    {
        $query
        ->leftJoin('fee_sheets', 'matters.feeSheetId', '=', 'fee_sheets.id')
        ->leftJoin('branches', 'matters.branchId', '=', 'branches.id')
        ->leftJoin('document_sets', 'matters.documentSetId', '=', 'document_sets.id')
        ->leftJoin('matter_types', 'matters.matterTypeId', '=', 'matter_types.id')

        ->leftJoin('accounts as incomeAccount', 'matters.incomeAccountId', '=', 'incomeAccount.id')
        ->leftJoin('accounts as trustBankAccount', 'matters.trustBankAccountId', '=', 'trustBankAccount.id')

        ->leftJoin('matter_parties as clientParty', function ($join) {
            $join->on('matters.id', '=', 'clientParty.matterId')
                ->where('clientParty.roleId', session('clientRoleId'))
                ->where('clientParty.rank', 1);
        })
        ->leftJoin('parties as client', 'clientParty.partyId', '=', 'client.id')

        ->leftJoin('matter_employees as ownerEmployee', function ($join) {
            $join->on('matters.id', '=', 'ownerEmployee.matterId')
                ->where('ownerEmployee.roleId', session('ownerRoleId'))
                ->where('ownerEmployee.rank', 1);
        })

        ->leftJoin('employees as owner', 'ownerEmployee.employeeId', '=', 'owner.id');
    }

    public static function AddCommonWhereClauses(&$query, $request, $orderBy = true)
    {
        if ($request->where) {
            $query->where($request->where['column'], $request->where['value']);
        }

        if ($request->where2) {
            $query->where($request->where2['column'], $request->where2['value']);
        }

        if ($request->whereIn) {
            $query->whereIn($request->whereIn['column'], $request->whereIn['value']);
        }

        if ($request->whereNull) {
            $query->whereNull($request->whereNull);
        }

        if ($request->whereRaw) {
            $query->whereRaw($request->whereRaw);
        }

        if ($request->tableFilter) {
            $query->whereRaw($request->tableFilter);
        }

        if ($request->tableHaving) {
            $query->havingRaw($request->tableHaving);
        }

        if ($request->whereClause) {
            $query->whereRaw($request->whereClause);
        }

        // Optional - e.g. AccountsController forces the order

        if ($orderBy) {
            if (isset($request->orderBy)) {
                if (is_array($request->orderBy)) {
                    $query->orderBy($request->orderBy['column'], $request->orderBy['direction']);
                } else {
                    $query->orderBy($request->orderBy);
                }
            }
        }
    }

    public static function ReturnData(&$query, $request)
    {
        if ($request->dataFormat === 'dataTables') {
            return datatables()->of($query)->toJson();
        } elseif ($request->dataFormat === 'get') {
            return $query->get();
        } elseif ($request->dataFormat === 'mergeArray' || $request->dataFormat === 'idArray' || $request->dataFormat === 'array') {
            return $query->get()->toArray();
        } elseif ($request->dataFormat === 'export') {
            return $query;
        } else {
            return $query->get()->toJson();
        }
    }

    public static function destroy($requestId, $apiUrl)
    {
        $returnData = new \stdClass();

        if (is_array($requestId)) {
            foreach ($requestId as $id) {
                try {
                    $response = Utils::SetCurlParams($apiUrl.$id, 'DELETE');
                } catch (\Exception $e) {
                    $returnData->errors = $e->getMessage();

                    return json_encode($returnData);
                }
            }

            return json_encode($returnData);
        } else {
            try {
                $response = Utils::SetCurlParams($apiUrl.$requestId, 'DELETE');

                return json_encode($response);
            } catch (\Exception $e) {
                $returnData->errors = $e->getMessage();

                return json_encode($returnData);
            }
        }
    }

    public static function destroy_Ettorney($request, $model)
    {
        $returnData = new \stdClass();

        if (is_array($request->id)) {
            foreach ($request->id as $id) {
                try {
                    $model::destroy($id);
                    //$model::findOrFail($id)->delete();
                } catch (\Exception $e) {
                    $returnData->errors[] = $id;
                }
            }

            return json_encode($returnData);
        } else {
            try {
                $model::destroy($request->id);
                //$model::findOrFail($request->id)->delete();
            } catch (\Illuminate\Database\QueryException $e) {
                $returnData->error = Utils::MySqlError($e);

                return json_encode($returnData);
            } catch (\Exception $e) {
                $returnData->error = $e->getMessage();

                return json_encode($returnData);
            }
        }
    }

    // public static function AddMaunualSearchFilter(&$query, $request)
    // {
    //     if ( $searchFor = $request->input('searchFor') ) {

    //         $helperClass = new \Yajra\DataTables\Utilities\Request;

    //         // Must you use a sub query function here so it puts brackets around this where clause
    //         $query->where(function ($query) use ($helperClass, $searchFor) {

    //             $searchableColumns = $helperClass->searchableColumnIndex();
    //             $counter = 0;
    //             foreach ($searchableColumns as $column) {
    //                 if (!$counter) {
    //                     $query->where($helperClass->columnName($column), 'like', "%" . $searchFor . "%");
    //                 } else {
    //                     $query->orWhere($helperClass->columnName($column), 'like', "%" . $searchFor . "%");
    //                 }
    //                 $counter++;
    //             }
    //         });
    //     }
    // }

/*
    public static function ColumnFilter(&$query, $request)
    {

        //$searchBy = $request->input('searchBy');
        $searchFor = $request->input('searchFor');

        if (!$searchFor || !$searchBy) return;

        $helperClass = new \Yajra\DataTables\Utilities\Request;

        // if ($searchBy === 'All' || $searchBy === 'Mobile') {

        //     // Must you use a sub query function here so it puts brackets around this where clause
        //     $query->where(function ($query) use ($helperClass, $searchFor) {

        //         $searchableColumns = $helperClass->searchableColumnIndex();
        //         $counter = 0;
        //         foreach ($searchableColumns as $column) {

        //             if (!$counter) {
        //                 $query->where($helperClass->columnName($column), 'like', "%" . $searchFor . "%");
        //             } else {
        //                 $query->orWhere($helperClass->columnName($column), 'like', "%" . $searchFor . "%");
        //             }
        //             $counter++;
        //         }
        //     });
        // } else {

            $query->where($helperClass->columnName((int)$searchBy), 'like', "%" . $searchFor . "%");
        //}
    }
*/
}
