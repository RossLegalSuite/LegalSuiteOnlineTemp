<?php

namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;

class ValidNumber implements Rule
{
    protected $value;

    public function __construct()
    {
    }

    public function passes($attribute, $value)
    {
        $this->value = $value;

        return is_numeric($value) && $value > 0;
    }

    public function message()
    {
        if (is_numeric($this->value) && $this->value < 0) {
            return 'Please enter a positive amount';
        } else {
            return 'Please enter an amount';
        }
    }
}
