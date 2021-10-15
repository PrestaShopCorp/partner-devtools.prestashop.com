import Vue from 'vue';
import App from './App.vue';
import i18n from "@/lib/i18n";
import psAccountsVueComponents from "prestashop_accounts_vue_components";
import { BootstrapVue, BootstrapVueIcons } from "bootstrap-vue";

import store from "@/store";
import "@/assets/_global.scss";
import "@/assets/_settings.scss";
import "@/assets/index.css";


Vue.use(BootstrapVue, BootstrapVueIcons);
Vue.use(psAccountsVueComponents);

Vue.config.productionTip = false;
Vue.config.debug = true;
Vue.config.devtools = true;

new Vue({
  store,
  i18n,
  render: h => h(App),
}).$mount('#app')
