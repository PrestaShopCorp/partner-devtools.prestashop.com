import Vue from 'vue';
import App from './App.vue';
import psAccountsVueComponents from "prestashop_accounts_vue_components";
import { BootstrapVue, BootstrapVueIcons } from "bootstrap-vue";

import "@/assets/_global.scss";
import "@/assets/_settings.scss";


Vue.use(BootstrapVue, BootstrapVueIcons);
Vue.use(psAccountsVueComponents, { locale: window?.psBillingContext?.i18n?.isoCode ?? 'en' });

Vue.config.productionTip = false;
Vue.config.debug = true;
Vue.config.devtools = true;

new Vue({
  render: h => h(App),
}).$mount('#app')
