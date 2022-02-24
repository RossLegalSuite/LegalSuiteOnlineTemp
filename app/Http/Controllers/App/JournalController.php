<?php

namespace App\Http\Controllers\App;

use App\Models\AccountTransaction;
use App\Models\Batch;
use App\Models\JournalTransaction;
use App\Models\Journal;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidDate;
use App\Custom\Utils;

class JournalController extends Controller {


    private function addColumns(&$query)
    {

        $format1 = "FORMAT( ";
        $format2 = ", 2, 'en_" . session('countryCode')  . "')";

        $query->addSelect('journals.id');
        $query->addSelect( DB::raw("CASE WHEN journals.id < 10000 THEN LPAD(journals.id,5,'0') ELSE journals.id  END as number") );
        $query->addSelect('journals.posted');

        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(journals.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as date") ); 
        
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(journals.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 

        $query->addSelect( DB::raw("CASE WHEN journals.posted = 1 THEN 1 ELSE 0 END as readOnly") );

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(journal_transactions.amount){$format2} FROM journal_transactions
            WHERE journal_transactions.journalId = journals.id AND journal_transactions.type = 'Debit'
            GROUP BY journal_transactions.journalId), 0.00) as debits") );

        $query->addSelect(DB::raw("IFNULL( 
            (SELECT {$format1}SUM(journal_transactions.amount){$format2} FROM journal_transactions
            WHERE journal_transactions.journalId = journals.id AND journal_transactions.type = 'Credit'
            GROUP BY journal_transactions.journalId), 0.00) as credits") );

    
    }

    public function get(Request $request)
    {

        $query = DB::table('journals');

        $this->addColumns($query);

        if ($request->posted) $query->where('posted',1);

        if ($request->id) $query->where('journals.id',$request->id);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        //Utils::LogSqlQuery($query);        

        return DataTablesHelper::ReturnData($query, $request);

    }

    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [];

        if ( isset($request->id) )  {

            $rules = [
                'dateTime' => new ValidDate,
            ];


        }        

        $validator = Validator::make($request->all(), $rules); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        }        

        try {

            return DB::transaction( function() use ($request)
            {

                $record = ( isset($request->id) ) ? Journal::findOrFail($request->id) : new Journal;

                $record->date = Utils::convertDateTime($request->dateTime);
                $record->posted = $request->posted;
                $record->employeeId = session('employeeId');

                $record->save();  

                if ( isset($request->id) ) {

                    $batch = Batch::create([
                        'date' => $record->date,
                        'employeeId' => session('employeeId'),
                        'type' => 'Journal',
                        'reference' => 'Journal: ' . $record->id,
                    ]);

                    $transactions = JournalTransaction::where('journalId', $request->id)->get();

                    foreach ($transactions as $transaction) {

                        AccountTransaction::create([
                            'batchId' => $batch->id,
                            'type' =>  $transaction->type,
                            'accountId' => $transaction->accountId,
                            'journalId' => $record->id,
                            'amount' => $transaction->amount,
                        ]);

                    }                    

                }

                return json_encode($record);

            });

        } catch (\Illuminate\Database\QueryException $e) {

            $validator->errors()->add('general', Utils::MySqlError($e));
            $returnData->errors = $validator->errors();
            return json_encode($returnData);            

        } catch(\Exception $e)  {

            $validator->errors()->add('general', $e->getMessage());
            $returnData->errors = $validator->errors();
            return json_encode($returnData);

        }

    }

    public function getTablePosition(Request $request)
    {
        return DB::table('journals')
        ->where('id','<',$request->column)
        ->orderBy('id')
        ->count();
    }


}

