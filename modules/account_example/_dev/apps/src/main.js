import Vue from 'vue';
import App from './App.vue';

import "@/assets/_global.scss";
import "@/assets/_settings.scss";

Vue.config.productionTip = false;
Vue.config.debug = true;
Vue.config.devtools = true;

// Account CDN need to have VueJs in window
window.Vue = Vue;

// We need to wait all JS is loaded before to init our Vue App
window.onload = () => {
  new Vue({
    render: h => h(App),
  }).$mount('#app')
}
