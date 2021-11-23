import Vue from 'vue';
import App from './App.vue';
import i18n from "@/i18n";
import { BootstrapVue, BootstrapVueIcons } from "bootstrap-vue";


import "@/assets/_global.scss";
import "@/assets/_settings.scss";

Vue.use(BootstrapVue, BootstrapVueIcons);

Vue.config.productionTip = false;
Vue.config.debug = true;
Vue.config.devtools = true;

new Vue({
  i18n,
  render: h => h(App),
}).$mount('#app')
