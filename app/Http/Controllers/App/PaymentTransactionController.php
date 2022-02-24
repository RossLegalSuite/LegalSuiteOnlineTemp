<?php

namespace App\Http\Controllers\App;

use App\Models\PaymentTransaction;
use App\Custom\DataTablesHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Datatables;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Rules\ValidNumber;
use App\Rules\ValidDate;
use App\Custom\Utils;


class PaymentTransactionController extends Controller {

    private function addColumns(&$query, $request)
    {

        $query->addSelect('payment_transactions.id');
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payment_transactions.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as date") ); 
        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(payment_transactions.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateTimeFormat() . "') as dateTime") ); 

        $query->addSelect( 'payments.type as description');
        $query->addSelect( 'payments.type as paymentType');

        $query->addSelect('payment_transactions.billId');
        $query->addSelect('payment_transactions.paymentId');
        $query->addSelect('payment_transactions.matterId');
        $query->addSelect('payment_transactions.ledgerAccountId');
        
        $query->addSelect(DB::raw("CONCAT(matters.fileRef, ' - ', matters.description) as matter"));
        $query->addSelect(DB::raw("CONCAT(accounts.code, ' - ', accounts.description) as account"));

        $query->addSelect( DB::raw("DATE_FORMAT( CONVERT_TZ(bills.date,'+00:00','" . session('timeZone') . "'), '" . Utils::sqlDateFormat() . "') as billDate") ); 
        $query->addSelect( DB::raw("CASE WHEN bills.id < 10000 THEN LPAD(bills.id,5,'0') ELSE bills.id END as billNumber") );
        $query->addSelect('bills.reference as billReference');

        $query->addSelect(DB::raw( "FORMAT(payment_transactions.amount, 2, 'en_" . session('countryCode')  . "') as amount") );

        $query->addSelect('payment_transactions.amount as amountRaw');

    }

    private function addTableJoins(&$query)
    {

        $query
        ->join('payments', 'payments.id', '=', 'payment_transactions.paymentId')
        ->leftJoin('bills', 'bills.id', '=', 'payment_transactions.billId')
        ->leftJoin('matters', 'matters.id', '=', 'payment_transactions.matterId')
        ->leftJoin('accounts', 'accounts.id', '=', 'payment_transactions.ledgerAccountId');

    }


    public function get(Request $request)
    {

        $query = DB::table('payment_transactions');

        $this->addColumns($query, $request);

        $this->addTableJoins($query);

        if ($request->parentId) {

            $query->where('payment_transactions.paymentId',$request->parentId);

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


    public function store(Request $request)
    {

        $returnData = new \stdClass();

        $rules = [
            'dateTime' => new ValidDate,
            'description' => 'required',
            'amount' => new ValidNumber,
        ];


        if ( $request->type === 'Disbursement' ) {
            $rules['matterId'] = 'required';
        } else if ( $request->type === 'Expense' || $request->type === 'Asset' ) {
            $rules['ledgerAccountId'] = 'required';
        }

        $messages = [
            'matterId.required' => 'Please select a Matter',
            'ledgerAccountId.required' => 'Please select an Account',
        ];


        $validator = Validator::make($request->all(), $rules, $messages); 
        
        if ($validator->fails()) {

            $returnData->errors = $validator->errors();
            return json_encode($returnData);            
        }        

        try {

            $record = ( isset($request->id) ) ? PaymentTransaction::findOrFail($request->id) : new PaymentTransaction;
        
            $record->createdById = $request->createdById;
            $record->date = Utils::convertDateTime($request->dateTime);

            $record->paymentId = $request->paymentId;
            $record->matterId = $request->matterId;
            $record->ledgerAccountId = $request->ledgerAccountId;

            $record->description = $request->description;
            
            $record->taxRateId = $request->taxRateId;

            $record->amount = $request->amount;

            // **************************************
            // Put this in Utils as a helper function
            // **************************************
            $taxRate = DB::table('tax_rates')
            ->select('rate')
            ->find( $request->taxRateId);
            
            if ( $taxRate ) {

                $record->taxAmount = round( (float) $request->amount * ( (float) $taxRate->rate / 100 ) ,2);

            } else {

                $record->taxAmount = 0;
            }

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
        return DataTablesHelper::destroy($request, PaymentTransaction::class);
    }



    public function getTablePosition(Request $request)
    {

        return DB::table('payment_transactions')
        ->where('id', '<' , $request->id)
        ->orderBy('id')
        ->count();

    }    


}
