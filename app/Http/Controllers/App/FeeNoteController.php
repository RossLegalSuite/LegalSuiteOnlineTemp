<?php

namespace App\Http\Controllers\App;

use App\Custom\DataTablesHelper;
use App\Custom\Utils;
use App\Models\FeeNote;
use App\Rules\ValidDate;
use App\Rules\ValidNumber;
use Datatables;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Maatwebsite\Excel\Concerns\Exportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeExport;
use Maatwebsite\Excel\Facades\Excel;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

class FeeNoteController extends Controller
{
    private function addColumns(&$query, $request)
    {
        $query->addSelect('fee_notes.id');
        $query->addSelect('fee_notes.date');
        $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(fee_notes.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') as dateFormatted"));
        $query->addSelect('created.name as createdEmployeeName');

        $query->addSelect('fee_notes.description');
        $query->addSelect('matters.fileRef as matterFileRef');

        $query->addSelect(DB::raw("CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id  END as invoiceNumber"));

        if ($request->dataFormat === 'export') {
            $query->orderBy('fee_notes.date');

            $query->addSelect('fee_notes.taxAmount');
            $query->addSelect('fee_notes.amount');
            $query->addSelect('fee_notes.totalAmount');
        } else {
            if ($request->dataFormat === 'dataTables') {
                $query->addSelect(DB::raw("FORMAT(amount, 2, 'en_".session('countryCode')."') as amount"));
                $query->addSelect(DB::raw("FORMAT(taxAmount, 2, 'en_".session('countryCode')."') as taxAmount"));
                $query->addSelect(DB::raw("FORMAT(totalAmount, 2, 'en_".session('countryCode')."') as totalAmount"));
            } else {
                $query->addSelect('amount');
                $query->addSelect('taxAmount');
                $query->addSelect('totalAmount');
            }

            $query->addSelect(DB::raw("DATE_FORMAT( CONVERT_TZ(fee_notes.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateTimeFormat()."') as dateTime"));

            $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
            $query->addSelect('matters.id as matterId');
            $query->addSelect('matters.description as matterDescription');

            $query->addSelect('fee_notes.taxRateId');
            $query->addSelect(DB::raw('CASE WHEN invoices.posted = 1 THEN 1 ELSE 0 END as invoicePosted'));

            $query->addSelect('fee_notes.createdById');
            $query->addSelect('fee_notes.allocatedToId');
            $query->addSelect('created.id as createdEmployeeId');
            $query->addSelect('allocated.id as allocatedEmployeeId');
            $query->addSelect('allocated.name as allocatedEmployeeName');

            $query->addSelect('fee_notes.invoiceId');

            $query->addSelect(DB::raw('CASE WHEN ISNULL(fee_notes.invoiceId) THEN 0 ELSE 1 END as readOnly'));
        }
    }

    private function addTableJoins(&$query)
    {
        $query
        ->join('matters', 'matters.id', '=', 'fee_notes.matterId')
        ->join('employees as created', 'created.id', '=', 'fee_notes.createdById')
        ->join('employees as allocated', 'allocated.id', '=', 'fee_notes.allocatedToId')
        ->leftJoin('invoices', 'invoices.id', '=', 'fee_notes.invoiceId');
    }

    public function get(Request $request)
    {
        $returnData = new \stdClass();

        if (isset($request->id)) {
            $id = $request->id;
        }

        unset($request['id']);

        try {
            if (isset($id)) {
                $apiUrl = "/feenote/{$id}?".urldecode(http_build_query($request->all()));
            } else {
                $apiUrl = '/feenote?'.urldecode(http_build_query($request->all()));
            }

            $response = Utils::SetCurlParams($apiUrl);

            return json_encode($response);
        } catch (\Exception $e) {
            $returnData->errors = $e->getMessage();

            return json_encode($returnData);
        }
    }

    public function get_Ettorney(Request $request)
    {
        $query = DB::table('fee_notes');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->invoiced) {
            $query->where('invoices.posted', 1);
        }

        if ($request->id) {
            $query->where('fee_notes.id', $request->id);
        } elseif ($request->matterId) {
            $query->where('fee_notes.matterId', $request->matterId);
        } elseif ($request->employeeId) {
            $query->where('fee_notes.allocatedToId', $request->employeeId);
        } elseif ($request->createdById) {
            $query->where('fee_notes.createdById', $request->createdById);
        } elseif ($request->invoiceId) {
            $query->where('fee_notes.invoiceId', $request->invoiceId);
        }

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        if ($request->dataFormat === 'dataTables') {
            $datatables = Datatables::of($query);

            if ($keyword = $request->get('search')['value']) {
                $datatables->filterColumn('date', function ($query, $keyword) {
                    $sql = "DATE_FORMAT( CONVERT_TZ(fee_notes.date,'+00:00','".session('timeZone')."'), '".Utils::sqlDateFormat()."') like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('invoiceNumber', function ($query, $keyword) {
                    $sql = "CASE WHEN invoices.id < 10000 THEN LPAD(invoices.id,5,'0') ELSE invoices.id END like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                })
                ->filterColumn('matter', function ($query, $keyword) {
                    $sql = "CONCAT(matters.fileRef, ' - ', matters.description) like ?";
                    $query->whereRaw($sql, ["%{$keyword}%"]);
                });
            }

            return $datatables->make(true);
        } else {
            return DataTablesHelper::ReturnData($query, $request);
        }
    }

    public function store(Request $request)
    {
        $returnData = new \stdClass();

        $rules = [
            'matterId' => 'required',
            'createdById' => 'required',
            'allocatedToId' => 'required',
            'taxRateId' => 'required',
            'description' => 'required',
            'amount' => new ValidNumber,
            'dateTime' => new ValidDate,
        ];

        $messages = [
            'matterId.required' => 'Please select a Matter',
            'createdById.required' => 'Please select an Employee',
            'allocatedToId.required' => 'Please select an Employee',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            $returnData->errors = $validator->errors();

            return json_encode($returnData);
        }

        try {
            $record = (isset($request->id)) ? FeeNote::findOrFail($request->id) : new FeeNote;

            $record->date = Utils::convertDateTime($request->dateTime);
            $record->matterId = $request->matterId;
            $record->createdById = $request->createdById;
            $record->allocatedToId = $request->allocatedToId;
            $record->invoiceId = $request->invoiceId;
            $record->taxRateId = $request->taxRateId;
            $record->description = $request->description;
            $record->amount = $request->amount;
            $record->taxAmount = $request->taxAmount;

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

    public function allocateInvoiceFeeNotes(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $returnData->result = DB::table('fee_notes');

            if (isset($request->ids)) {
                $returnData->result->whereIn('id', $request->ids);
            } else {
                $returnData->result->where('matterId', $request->matterId);
            }

            $returnData->result->update(['invoiceId' => $request->invoiceId]);

            return json_encode($returnData);
        } catch (\Illuminate\Database\QueryException $e) {
            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);
        }
    }

    public function unallocateInvoiceFeeNote(Request $request)
    {
        $returnData = new \stdClass();

        try {
            $returnData->result = DB::table('fee_notes')
            ->where('id', $request->id)
            ->update(['invoiceId' => null]);

            return json_encode($returnData);
        } catch (\Illuminate\Database\QueryException $e) {
            $returnData->error = Utils::MySqlError($e);

            return json_encode($returnData);
        }
    }

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, FeeNote::class);
    }

    public function getTablePosition(Request $request)
    {
        return DB::table('fee_notes')
        ->where('date', '<', $request->date)
        ->orderBy('date')
        ->count();
    }

    public function export(Request $request)
    {
        $newRequest = new Request;
        $newRequest->tableColumns = false;
        $newRequest->dataFormat = 'export';
        $query = $this->get($newRequest);

        Utils::SetExcelMacros();

        return Excel::download(new class($query) implements FromQuery, WithHeadings, WithEvents, ShouldAutoSize {
            public function __construct($query)
            {
                $this->query = $query;
            }

            public function headings(): array
            {
                return [
                    'Id',
                    'Date',
                    'Created By',
                    'Type',
                    'Description',
                    'Matter',
                    'Invoice No',
                    'Net Amount',
                    'Tax',
                    'Amount',
                ];
            }

            public function registerEvents(): array
            {
                return [
                    AfterSheet::class => function (AfterSheet $event) {
                        $event->sheet->styleCells(
                            'A8:A10',
                            [
                                'alignment' => [
                                    'horizontal' => Alignment::HORIZONTAL_RIGHT,
                                ],
                            ]
                        );
                    },

                    BeforeExport::class => function (BeforeExport $event) {
                        $event->writer->getProperties()->setTitle('Fee Notes');
                        $event->writer->getProperties()->setCreator(session('employeeName'));
                        $event->writer->getProperties()->setCompany(session('companyName'));
                    },

                ];
            }

            public function query()
            {
                return $this->query;
            }
        }, 'feenotes.xlsx');
    }
}
