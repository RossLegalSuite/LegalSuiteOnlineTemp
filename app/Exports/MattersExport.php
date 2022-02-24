<?php

namespace App\Exports;

use App\Http\Controllers\App\MatterController;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\Exportable;
use Illuminate\Http\Request;

// Note: You need to have the zip php extension installed and enabled. XLSX has some compression on it. 
// Otherwise you get this message in the console: "Resource interpreted as Document but transferred with MIME type application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
// See: https://github.com/Maatwebsite/Laravel-Excel/issues/740

class MattersExport implements FromQuery//, WithHeadings
{
    use Exportable;

    // public function __construct(array $columns = [])
    // {
    //     $this->columns = $columns;
    // }    

    // public function headings(): array
    // {

    //     return $this->columns;
    //     // return [
    //     //     '#',
    //     //     'User',
    //     //     'Date',
    //     // ];
    // }


    public function query()
    {

        $newRequest = new Request;
        $newRequest->tableColumns = true;
        $newRequest->dataFormat = 'query';

        $matterController = new MatterController;

        return $matterController->get($newRequest);


    }

}

