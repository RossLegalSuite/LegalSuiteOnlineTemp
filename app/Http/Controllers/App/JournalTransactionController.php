<?php

namespace App\Http\Controllers\App;

use App\Models\JournalTransaction;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Custom\Utils;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidNumber;

class JournalTransactionController extends Controller {


    private function addColumns(&$query)
    {

        $query->addSelect('journal_transactions.id');
        $query->addSelect('journal_transactions.accountId');
        $query->addSelect('journal_transactions.journalId');
        $query->addSelect('journal_transactions.type');

        $query->addSelect(DB::raw( "FORMAT(journal_transactions.amount, 2, 'en_" . session('countryCode')  . "') as amount") );

        $query->addSelect('journals.posted as journalPosted');

        $query->addSelect( DB::raw("CASE WHEN journals.posted = 1 THEN 1 ELSE 0 END as readOnly") );

        $query->addSelect('accounts.id as accountId');
        $query->addSelect('accounts.code as accountCode');
        $query->addSelect('accounts.description as accountDescription');
        $query->addSelect('accounts.category as accountCategory');


    
    }

    public function get(Request $request)
    {

        $query = DB::table('journal_transactions')
        ->join('journals', 'journals.id', '=', 'journal_transactions.journalId')
        ->join('accounts', 'accounts.id', '=', 'journal_transactions.accountId');

        $this->addColumns($query);

        if ($request->id) $query->where('journal_transactions.id',$request->id);

        if ($request->parentId) $query->where('journal_transactions.journalId',$request->parentId);

        if ($request->accountId) $query->where('journal_transactions.accountId',$request->accountId);

        DataTablesHelper::AddCommonWhereClauses($query, $request);

        return DataTablesHelper::ReturnData($query, $request);

    }


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'journalId' => 'required',
            'accountId' => 'required',
            'type' => 'required',
            'amount' => new ValidNumber,
        ];

        $messages = [
            'accountId.required' => 'Please select an Account',
        ];



        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            
   
        }        

        try {

            $record = ( isset($request->id) ) ? JournalTransaction::findOrFail($request->id) : new JournalTransaction;
        
            $record->journalId = $request->journalId;
            $record->accountId = $request->accountId;
            $record->type = $request->type;
            $record->amount = $request->amount;


            $record->save();

            return json_encode($record);

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

    public function destroy(Request $request)
    {
        return DataTablesHelper::destroy($request, JournalTransaction::class);
    }


}
