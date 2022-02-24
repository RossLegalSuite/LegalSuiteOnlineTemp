<!DOCTYPE html>

<html lang="en" class="no-js leather-background">

<head>
    <!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="keywords" content="Online, Software, SAS, Service, Legal, Lawyer, Attorney, Advocate, Barrister, Counsel, Matters, Clients, Accounting, Billing, Document Assembly ">
    <meta name="description" content="Online practive management and accounting system for legal practitioners">
    <meta name="author" content="LegalSuite Online">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>LegalSuite Online @yield('title')</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="/favicon.png">

    <link href="/css/program.css" rel="stylesheet">

    @yield('styles')

    <!-- IE Shim -->
    <!--[if IE]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->    

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <script src="/js/app.js" defer></script> 

    <script src="/js/program.js" defer></script> 


</head>

<body>
    
    <div id="app" class="stitched-border">
        
        {{-- Tabs --}}
        <div class="d-lg-flex filofax-tabs-container">
            
            <div class="filofax-left-tabs">

                <div class="d-flex d-none align-items-end"> 

                    <div class="d-table tab-item router-link-active home-bg">

                        <div class="d-table-row">
                            <div class="d-table-cell tab-item-icon">
                                <span class="fa fa-user mr-2"></span>
                            </div>
                            <div class="d-table-cell">
                                Login
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        
            <div class="filofax-right-tabs" id="filofax-right-tabs">
                
                <keep-alive>
                    <router-view ref="right-hand-tab-container" name="rightHandTabs"/>
                </keep-alive>

            </div>        

        </div>        

        {{-- Pages --}}
        <div class="filofax-pages-container">
            <keep-alive>
                <router-view ref="pages"/>
            </keep-alive>
        </div>

        
        {{-- Footer --}}
        {{-- https://github.com/antonioribeiro/version --}}
        {{-- See \config\version.yml --}}
        <div class="d-flex filofax-footer">
            <div class="flex-fill">@version('full') @version('timestamp-datetime')</div>
        </div>
        

        <vue-snotify></vue-snotify>

        @include('modals.help')
        @include('modals.error')
        @include('modals.message')
        @include('modals.waiting')        

    </div>

    @yield('scripts')
    <script defer>
        var appEnvironment = '{{\Config::get('values.environment')}}';
    </script>

</body>
</html>
