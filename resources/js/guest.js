import Snotify from 'vue-snotify';
import 'vue-snotify/styles/material.css';


window.Vue = require("vue");

Vue.use(Snotify, {
    toast: {
      timeout: 2000,
      showProgressBar: false,
      position: "centerCenter",
    }
});


window.Popper = require('popper.js').default;

window.$ = window.jQuery = require('jquery');

require('bootstrap');

new Vue({
    el: '#app',
    components: {
        ModalMessage: () => import("./components/modals/ModalMessage"),
    },
});

