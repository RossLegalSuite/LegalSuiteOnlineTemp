<?php

    // 18 Oct 2020
    // Problem: env('DB_HOST') is null in General.php
    // Solution: https://stackoverflow.com/questions/34263107/get-environment-value-in-controller
    return [
        'dbhost' => env('DB_HOST',null),
        'environment' => env('APP_ENV','not found'),
    ];
        