<?php

use App\Models\FeeCode;
use App\Models\FeeItem;
use App\Models\FeeSheet;
use Illuminate\Database\Seeder;

class FeeSheetSeeder extends Seeder
{
    public function run()
    {
        $feeSheet = new FeeSheet;
        $feeSheet->code = 'attorneyClient';
        $feeSheet->description = 'Attorney Client';
        $feeSheet->save();

        //******* Drafting *****************/
        $feeCode = new FeeCode;
        $feeCode->feeSheetId = $feeSheet->id;
        $feeCode->code = 'drafting';
        $feeCode->description = 'Drafting';
        $feeCode->save();

        $feeItem = new FeeItem;
        $feeItem->feeCodeId = $feeCode->id;
        $feeItem->description = 'Drafting document';
        $feeItem->type = 'Fee';
        $feeItem->taxRateId = 5;
        $feeItem->amount = 300;
        $feeItem->taxAmount = $feeItem->amount * 0.15;
        $feeItem->unitsFlag = 1;
        $feeItem->unitsId = 1;
        $feeItem->unitsFactor = 1;
        $feeItem->sorter = 1;
        $feeItem->save();

        //******* Perusing a Document by page *****************/
        $feeCode = new FeeCode;
        $feeCode->feeSheetId = $feeSheet->id;
        $feeCode->code = 'perusing';
        $feeCode->description = 'Perusing (by page)';
        $feeCode->save();

        $feeItem = new FeeItem;
        $feeItem->feeCodeId = $feeCode->id;
        $feeItem->description = 'Perusing document';
        $feeItem->type = 'Fee';
        $feeItem->taxRateId = 5;
        $feeItem->amount = 150;
        $feeItem->taxAmount = $feeItem->amount * 0.15;
        $feeItem->unitsFlag = 1;
        $feeItem->unitsId = 1;
        $feeItem->unitsFactor = 1;
        $feeItem->sorter = 1;
        $feeItem->save();

        //******* Perusing a Documents by documents *****************/
        $feeCode = new FeeCode;
        $feeCode->feeSheetId = $feeSheet->id;
        $feeCode->code = 'perusing1';
        $feeCode->description = 'Perusing Documents';
        $feeCode->save();

        $feeItem = new FeeItem;
        $feeItem->feeCodeId = $feeCode->id;
        $feeItem->description = 'Perusing documents';
        $feeItem->type = 'Fee';
        $feeItem->taxRateId = 5;
        $feeItem->amount = 150;
        $feeItem->taxAmount = $feeItem->amount * 0.15;
        $feeItem->unitsFlag = 1;
        $feeItem->unitsId = 4;
        $feeItem->unitsFactor = 1;
        $feeItem->sorter = 1;
        $feeItem->save();
    }
}
