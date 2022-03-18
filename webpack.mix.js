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

// Run this if the sass ever changes
//mix.sass("resources/sass/app.scss", "public/css");

mix

    //.sourceMaps()
    
    
    .disableNotifications()

    //https://github.com/JeffreyWay/laravel-mix/issues/1979
    // .options({
    //     postCss: [
    //         require('autoprefixer'),
    //     ],
    // })
    
    .sass("resources/sass/app.scss", "public/css")

    .js("resources/js/app.js", "public/js")
    //.js("resources/js/guest.js", "public/js/guest.js")

    //.babel(
    .scripts(
        [
            "resources/js/custom.js",
            "resources/js/common.js",
            "resources/js/document-generator.js",
            "resources/js/summer-note.js",
            "resources/js/clarion.js",

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
            "resources/css/filofax.css",
            "resources/css/colors.css",
            "resources/css/bootstrap-custom.css",
            "resources/css/datatables.css",
            "resources/css/datatables-custom.css",
            "resources/css/form.css",
            "resources/css/modal.css"
            
            /* These are on Cloud Front
            "resources/css/datatables.css",
            "resources/css/datatables-select.css",*/
        ],
        "public/css/program.css"
    ).vue();
    //.webpackConfig({devtool: 'inline-source-map'})
    //.version();
