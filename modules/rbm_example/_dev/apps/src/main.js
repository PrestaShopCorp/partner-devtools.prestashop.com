import Vue from 'vue';
import App from './App.vue';
import { BootstrapVue, BootstrapVueIcons } from "bootstrap-vue";

import "@/assets/_global.scss";
import "@/assets/_settings.scss";

Vue.use(BootstrapVue, BootstrapVueIcons);

Vue.config.productionTip = false;
Vue.config.debug = true;
Vue.config.devtools = true;

window.Vue = Vue;

window.onload = () => {
  new Vue({
    render: h => h(App),
  }).$mount('#app')
}