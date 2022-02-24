const mix = require('laravel-mix');

//See: https://github.com/matrus2/webpack-s3-uploader


//https://dev.to/acro5piano/laravel-tips-set-resolve-alias-in-laravel-mix-6f5
mix.webpackConfig({
    resolve: {
        extensions: ['.js', '.vue', '.json'],
        alias: {
            '@components': __dirname + '/resources/js/components',
            '@pages': __dirname + '/resources/js/pages'
        }
    },
})

mix

//    .sass("resources/sass/app.scss", "public/css");


    //.sourceMaps()
    
    
    .disableNotifications()

    .options({
        postCss: [
            require('autoprefixer'),
        ],


    })
    
    .js("resources/js/app.js", "public/js")
    //.js("resources/js/guest.js", "public/js/guest.js")

    //.babel(
    .scripts(
        [
            "resources/js/custom.js",

            // Put these on Cloud Front
            // "resources/js/dataTables.select.js",
            // "resources/js/dataTables.treegrid.js",
            // "resources/js/jquery.highlight.js",
            // "resources/js/printThis.js",
            // "resources/js/tab-guard.js",

        ],
        "public/js/program.js"
    )
    // .scripts(
    //     ["public/js/app.js", "public/js/program.js"],
    //     "public/js/dashboard.js"
    // )

    //.sass("resources/sass/app.scss", "public/css") // !!** Doing this manually once because it doesn't change (and app.css was blank once)
    .styles(
        [
            "public/css/app.css",
            "resources/css/custom.css",
            "resources/css/utils.css",
            "resources/css/filofax.css",
            "resources/css/colors.css",
            "resources/css/datatables-custom.css",
            "resources/css/form.css",
            
            /* These are on Cloud Front
            "resources/css/modal.css"
            "resources/css/datatables.css",
            "resources/css/datatables-select.css",*/
        ],
        "public/css/program.css"
    )
    //.webpackConfig({devtool: 'inline-source-map'})
    //.version();
