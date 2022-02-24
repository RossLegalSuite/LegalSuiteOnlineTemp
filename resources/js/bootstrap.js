window._ = require('lodash');

try {

    window.Popper = require('popper.js').default;
    
    window.$ = window.jQuery = require('jquery');

    require('bootstrap');

} catch (e) {

    console.log('error',e);

}

window.axios = require('axios');

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

window.axios.defaults.timeout = 300000;

let token = document.head.querySelector('meta[name="csrf-token"]');

if (token) {
    window.axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
} else {
    console.error('CSRF token not found: https://laravel.com/docs/csrf#csrf-x-csrf-token');
}
