<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\DocumentTemplate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class DocumentTemplateController extends Controller
{
    private function addColumns(&$query)
    {
        $query->addSelect('document_templates.*')

        // 13 Apr 2021 - Put back if adding Document Templates to Extra Screens and Document Sets
        // ->addSelect(DB::raw('CASE
        // WHEN !ISNULL(document_templates.documentSetId) THEN "Document Set"
        // WHEN !ISNULL(document_templates.extraScreenId) THEN "Extra Screen"
        // ELSE "Document Template" END as templateType'))

        ->addSelect(DB::raw('CASE 
        WHEN !ISNULL(document_templates.documentSetId) THEN document_sets.description
        WHEN !ISNULL(document_templates.extraScreenId) THEN extra_screens.description
        ELSE source END as sourceDescription'));
    }

    public function get(Request $request)
    {
        $query = DB::table('document_templates')
        ->leftJoin('extra_screens', 'extra_screens.id', '=', 'document_templates.extraScreenId')
        ->leftJoin('document_sets', 'document_sets.id', '=', 'document_templates.documentSetId')
        ->join('employees', 'employees.id', '=', 'document_templates.employeeId');

        $this->addColumns($query);

        if ($request->id) {
            $query->where('document_templates.id', $request->id);
        }

        if ($request->type) {
            $query->where('document_templates.type', $request->type);
        }

        if ($request->documentSetId) {
            $query->where('document_templates.documentSetId', $request->documentSetId);
        }

        if ($request->extraScreenId) {
            $query->where('document_templates.extraScreenId', $request->extraScreenId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'idArray') {
            $query->orderBy('document_templates.title');

            return $query->get()->toArray();
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    // public function getAllTemplates(Request $request)
    // {

    //     $query = DB::table('all_templates');

    //     $query->addSelect('all_templates.*');

    //     DataTablesHelper::AddCommonWhereClauses($query, $request);

    //     return DataTablesHelper::ReturnData($query, $request);

    // }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'description' => 'required',
            'employeeId' => 'required',
            'source' => 'required',
            'type' => 'required',
            'path' => 'required',
            'fileName' => 'required',
            'pdfFile' => 'required',
            'docxFile' => 'required',
        ];

        $rules['title'] = isset($request->id) ? ['required', Rule::unique('document_templates')->ignore($request->id)] : ['required', Rule::unique('document_templates')];

        $messages = [
            'pdfFile.required' => 'No PDF file found',
            'docxFile.required' => 'No DOCX file found',
            'title.unique' => 'A Template with this title already exists.',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? DocumentTemplate::findOrFail($request->id) : new DocumentTemplate;

            $record->employeeId = $request->employeeId;
            $record->documentSetId = $request->documentSetId;
            $record->extraScreenId = $request->extraScreenId;
            $record->title = $request->title;
            $record->description = $request->description;
            $record->path = $request->path;
            $record->fileName = $request->fileName;
            $record->source = $request->source;
            $record->type = $request->type;
            $record->pdfFile = $request->pdfFile;
            $record->docxFile = $request->docxFile;

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
        return DataTablesHelper::destroy($request, DocumentTemplate::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('document_templates')
        ->where('title', '<', $request->title)
        ->orderBy('title')
        ->count();
    }
}
