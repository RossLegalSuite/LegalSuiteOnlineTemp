<?php

namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;

class ValidDate implements Rule
{
    /**
     * Create a new rule instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Determine if the validation rule passes.
     *
     * @param  string  $attribute
     * @param  mixed  $value
     * @return bool
     */

    public function passes($attribute, $date)
    {
     
        
        //https://stackoverflow.com/questions/2891937/strtotime-doesnt-work-with-dd-mm-yyyy-format
        
        if ( session('dateFormat') === 'DD/MM/YYYY') {

            $date = str_replace('/', '-', $date);

        } else if ( session('dateFormat') === 'MM-DD-YYYY') {   

            $date = str_replace('-', '/', $date);
        }

        return strtotime( $date ) === false ? false : true;


    }

    /**
     * Get the validation error message.
     *
     * @return string
     */

    public function message()
    {
        return 'Please enter a valid date in the format: ' . session('dateFormat');
    }
}
