@extends('layouts.filofax')

@section('title', '')

<script>
    var loggedIn = true;
</script>


@section('styles')

    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/css/datatables-select.css">
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/summernote/summernote-bs4.min.css">

<!-- In Production: Take out of WebPack and uncomment this
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/datatables-22-07-2020.css">
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/modal-23-07-2020.css">
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/form.css">
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/datatables-custom.css"> -->

    <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.contextMenu.min.css"> -->
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/css/jquery.contextMenu.min.css">


    <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.3.0/codemirror.min.css"> -->
    <link rel="stylesheet" href="https://d22oktazhmwkct.cloudfront.net/css/codemirror.min.css">


@endsection

@section('scripts')

    <script src="https://d22oktazhmwkct.cloudfront.net/summernote/summernote-bs4.min.js" defer></script>
    <script src="https://d22oktazhmwkct.cloudfront.net/js/codemirror.min.js" defer></script>
    <script src="https://d22oktazhmwkct.cloudfront.net/js/codemirror-xml.min.js" defer></script>

    <script src="https://d22oktazhmwkct.cloudfront.net/js/jquery.contextMenu.min.js" defer></script>
    
    <script src="https://d22oktazhmwkct.cloudfront.net/dataTables.select.js" defer></script>
    <script src="https://d22oktazhmwkct.cloudfront.net/dataTables.treegrid.js" defer></script>
    <script src="https://d22oktazhmwkct.cloudfront.net/jquery.highlight.js" defer></script>
    <script src="https://d22oktazhmwkct.cloudfront.net/tab-guard.js" defer></script>

    <!-- <script src="https://d22oktazhmwkct.cloudfront.net/js/form-builder.min.js" defer></script>
    <script src="https://d22oktazhmwkct.cloudfront.net/js/form-render.min.js" defer></script> -->

    <!-- Adjustments for injected Form Builder styles-->
    <!-- <style type="text/css">
        .row { display: flex; }
        .rendered-form label { font-weight: 600; }
        .form-wrap.form-builder .frmb li .close-field {
            bottom: -5px;
            border: 1px solid mediumvioletred;
            border-radius: 3px;
            background: indianred;
            color: white;
            padding: 2px 8px;
        }
        
        .form-wrap.form-builder .frmb li .close-field:before {
            font: normal normal normal 14px/1 FontAwesome;
            content: "\F057";
            margin-right: 5px;
        }        
    </style> -->

    <!-- Adjustments for injected MultiSelect styles-->
    <style type="text/css">
        .multiselect, .multiselect__input, .multiselect__single {
            font-size: 0.7vw !important;
            margin-bottom: 2px !important;
        }
        .multiselect__placeholder {
            margin-bottom: 0px !important;
            padding-top: 0px !important;
        }
    </style>


@endsection