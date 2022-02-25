<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\TaxRateComponent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class TaxRateComponentController extends Controller
{
    public function get(Request $request)
    {
        $columns = 'tax_rate_components.*';
        $columns .= ', tax_components.description as component_description';
        $columns .= ', tax_components.rate as component_rate';

        $query = DB::table('tax_rate_components')
        ->selectRaw($columns)
        ->join('tax_components', 'tax_components.id', '=', 'tax_rate_components.taxComponentId');

        if ($request->id) {
            $query->where('tax_rate_components.id', $request->id);
        }

        if ($request->parentId) {
            $query->where('tax_rate_components.taxRateId', $request->parentId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required',
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? SalesTaxRate::findOrFail($request->id) : new SalesTaxRate;

            $record->description = $request->description;

            $record->save();

            return json_encode($record);
        } catch (\Illuminate\Database\QueryException $e) {
            $validator->errors()->add('general', Utils::MySqlError($e));
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        } catch (\Exception $e) {
            $validator->errors()->add('general', $e->getMessage());
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, TaxRateComponent::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('tax_rate_components')
        ->where('description', '<', $request->description)
        ->orderBy('description')
        ->count();
    }
}
