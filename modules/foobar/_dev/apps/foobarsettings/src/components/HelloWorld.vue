<template>
  <div class="pt-2">
    <section key="display-module-plan">
      <div class="p-0 m-auto tw-container">
        <PsAccounts :force-show-plans="true">
          <!-- <template v-slot:body>
            <div class="mt-4">
              <span>Configuration banner</span>
            </div>
          </template> -->
        </PsAccounts>
        <!-- <component v-if="psAccount" :is="psAccount" :force-show-plans="true" /> -->
      </div>

      <ps-customer
        v-if="context.user.email"
        ref="customer"
        :context="context"
        :onOpenModal="openBillingModal"
      />
    </section>

    <modal-container
      v-if="type !== ''"
      :context="context"
      :type="type"
      :onCloseModal="closeModal"
    />

  </div>
</template>

<script>
import Vue from 'vue';
/**
 * not used for now, but this is mandatory for dynamic loading ps account npm in created hook
 * use with ps account from cdn
 */
// import PsVueAccounts from "prestashop_accounts_vue_components"; 
import {PsAccounts} from "prestashop_accounts_vue_components";
import { mapGetters, mapActions, mapState } from 'vuex'
import moduleLogo from "@/assets/icon-ps-metrics.png";
import { CustomerComponent, ModalContainerComponent } from "@prestashopcorp/billing-cdc/dist/bundle.umd";

// let PsAccounts = window?.psaccountsVue?.PsAccounts;
// This is a fallback in case the CDN doesn't work properly. If you want to do this
// you should also add prestashop_accounts_vue_components in your dependencies:
// npm install prestashop_accounts_vue_components OR yarn add prestashop_accounts_vue_components

// if (!PsAccounts) {
//   console.log('not found ps account cdn', window?.psaccountsVue?.PsAccounts);
//   PsAccounts = require('prestashop_accounts_vue_components').PsAccounts;
// }

export default {
  name: 'HelloWorld',
  components: {
    PsAccounts,
    PsCustomer: CustomerComponent.driver('vue', Vue),
    ModalContainer: ModalContainerComponent.driver('vue', Vue),
  },
  computed: {
    ...mapState({
      appInfo: state => state.app,
      billingInfo: state => state.billing
    }),
    ...mapGetters({
      initialize: 'loadingBilling',
      displayModulePlans: 'displayModulePlans',
    }),
  },
  provide() {
    return {
      emailSupport: this.appInfo.user.emailSupport
    }
  },
  data() {
    return {
      moduleLogo,
      context: window.storePsFoobar.context,
      type: '',
      // psAccount: null
    }
  },
  methods: {
    ...mapActions([
      'SET_DISPLAY_MODULE_PLANS'
    ]),
    goToPlans() {
      this.SET_DISPLAY_MODULE_PLANS(true)
    },
    backToSettings() {
      this.SET_DISPLAY_MODULE_PLANS(false)
    },
    openBillingModal(type, data) {
      this.type = type;
      this.context = {
        ...this.context,
        ...data
      };
      console.log('openBillingModal', type, this.context);
    },
    closeModal(data) {
      console.log('data', data)
      this.type = '';
      this.$refs.customer.parent.updateProps({
        context: {
          ...this.context,
          ...data
        },
      });
    },
  },
  created() {
    // this.psAccount = require('prestashop_accounts_vue_components').PsAccounts;
    // this.context = {
    //   versionModule: this.appInfo.version_module,
    //   versionPs: this.appInfo.version_ps,
    //   moduleName: this.appInfo.moduleName,
    //   refreshToken: this.appInfo.refreshToken,
    //   emailSupport: this.appInfo.user.emailSupport,
    //   i18n: this.appInfo.i18n,
    //   shop: {
    //     uuid: this.appInfo.shop.shopUuid,
    //     domain: window.location.host
    //   },
    //   user: {
    //     createdFromIp: this.appInfo.user.created_from_ip,
    //     email: this.appInfo.user.email,
    //   },
    //   moduleLogo: 'https://upload.wikimedia.org/wikipedia/fr/thumb/7/7d/Prestashop-logo.png/280px-Prestashop-logo.png'
    // };

  },
  mounted() {
    // document.addEventListener("DOMContentLoaded", () => {
    //   if (window?.psaccountsVue?.PsAccounts) {
    //     console.log('cdn ps account', window?.psaccountsVue?.PsAccounts);
    //     this.psAccount = window?.psaccountsVue?.PsAccounts;
    //   }
    // });
    // if (localStorage.getItem('customer_sub_created') !== 'ok') {
    //   this.$billingEmitter.emit('init:billing', {
    //     'CREATE_CUSTOMER': {
    //       created_from_ip: this.appInfo.user.created_from_ip,
    //     },
    //     'CREATE_SUBSCRIPTION': {
    //       // this should be dynamic. Change this to the module name passed from php module perhaps
    //       planId: 'default-free'
    //     }
    //   })
    //   localStorage.setItem('customer_sub_created', 'ok')
    // }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
section {
  margin-bottom: 35px;
}
</style>
