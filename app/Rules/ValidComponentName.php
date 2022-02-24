<?php

namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;

class ValidComponentName implements Rule
{

    protected $value;

    public function __construct()
    {
        
    }

    public function passes($attribute, $value)
    {

        return  preg_match('/\s/',$value) ? false : true;

    }


    public function message()
    {

        return 'A component name cannot contain spaces';

    }
}
