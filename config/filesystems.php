<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Default Filesystem Disk
    |--------------------------------------------------------------------------
    |
    | Here you may specify the default filesystem disk that should be used
    | by the framework. The "local" disk, as well as a variety of cloud
    | based disks are available to your application. Just store away!
    |
    */

    'default' => env('FILESYSTEM_DISK', 'local'),

    'cloud' => env('FILESYSTEM_CLOUD', 's3'),

    /*
    |--------------------------------------------------------------------------
    | Filesystem Disks
    |--------------------------------------------------------------------------
    |
    | Here you may configure as many filesystem "disks" as you wish, and you
    | may even configure multiple disks of the same driver. Defaults have
    | been setup for each driver as an example of the required options.
    |
    | Supported Drivers: "local", "ftp", "sftp", "s3"
    |
    */

    'disks' => [

        'local' => [
            'driver' => 'local',
            'root' => storage_path('app'),
        ],

        'public' => [
            'driver' => 'local',
            'root' => storage_path('app/public'),
            'url' => env('APP_URL').'/storage',
            'visibility' => 'public',
        ],

        'documents' => [
            'driver' => 'local',
            'root' => 'documents',
            'url' => env('APP_URL').'/documents',
            'visibility' => 'public',
        ],

        'uploads' => [
            'driver' => 'local',
            'root' => 'uploads',
            'url' => env('APP_URL').'/uploads',
            'visibility' => 'public',
        ],

        's3' => [
            'driver' => 's3',
            'key' => env('AWS_ACCESS_KEY_ID'),
            'secret' => env('AWS_SECRET_ACCESS_KEY'),
            'region' => env('AWS_DEFAULT_REGION'),
            'bucket' => env('AWS_BUCKET'),
            'url' => env('AWS_URL'),
            'endpoint' => env('AWS_ENDPOINT'),
            'use_path_style_endpoint' => env('AWS_USE_PATH_STYLE_ENDPOINT', false),
        ],

        'af-south-1' => [
            'driver' => 's3',
            'key' => env('AF_SOUTH_1_ACCESS_KEY_ID'),
            'secret' => env('AF_SOUTH_1_SECRET_ACCESS_KEY'),
            'region' => env('AF_SOUTH_1_DEFAULT_REGION'),
            'bucket' => env('AF_SOUTH_1_BUCKET'),
            'url' => env('AF_SOUTH_1_URL'),
        ],

        'us-east-1' => [
            'driver' => 's3',
            'key' => env('US_EAST_1_ACCESS_KEY_ID'),
            'secret' => env('US_EAST_1_SECRET_ACCESS_KEY'),
            'region' => env('US_EAST_1_DEFAULT_REGION'),
            'bucket' => env('US_EAST_1_BUCKET'),
            'url' => env('US_EAST_1_URL'),
        ],

        'us-west-1' => [
            'driver' => 's3',
            'key' => env('US_WEST_1_ACCESS_KEY_ID'),
            'secret' => env('US_WEST_1_SECRET_ACCESS_KEY'),
            'region' => env('US_WEST_1_DEFAULT_REGION'),
            'bucket' => env('US_WEST_1_BUCKET'),
            'url' => env('US_WEST_1_URL'),
        ],

        'eu-west-2' => [
            'driver' => 's3',
            'key' => env('EU_WEST_2_ACCESS_KEY_ID'),
            'secret' => env('EU_WEST_2_SECRET_ACCESS_KEY'),
            'region' => env('EU_WEST_2_DEFAULT_REGION'),
            'bucket' => env('EU_WEST_2_BUCKET'),
            'url' => env('EU_WEST_2_URL'),
        ],

        'ap-southeast-2' => [
            'driver' => 's3',
            'key' => env('AP_SOUTHEAST_2_ACCESS_KEY_ID'),
            'secret' => env('AP_SOUTHEAST_2_SECRET_ACCESS_KEY'),
            'region' => env('AP_SOUTHEAST_2_DEFAULT_REGION'),
            'bucket' => env('AP_SOUTHEAST_2_BUCKET'),
            'url' => env('AP_SOUTHEAST_2_URL'),
        ],

        'ca-central-1' => [
            'driver' => 's3',
            'key' => env('CA_CENTRAL_1_ACCESS_KEY_ID'),
            'secret' => env('CA_CENTRAL_1_SECRET_ACCESS_KEY'),
            'region' => env('CA_CENTRAL_1_DEFAULT_REGION'),
            'bucket' => env('CA_CENTRAL_1_BUCKET'),
            'url' => env('CA_CENTRAL_1_URL'),
        ],

    ],

    /*
    |--------------------------------------------------------------------------
    | Symbolic Links
    |--------------------------------------------------------------------------
    |
    | Here you may configure the symbolic links that will be created when the
    | `storage:link` Artisan command is executed. The array keys should be
    | the locations of the links and the values should be their targets.
    |
    */

    'links' => [
        public_path('storage') => storage_path('app/public'),
    ],

];
