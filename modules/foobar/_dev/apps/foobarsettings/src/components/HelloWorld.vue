<template>
  <div class="pt-2">
    <section key="display-module-plan">
      <div class="p-0 m-auto tw-container">
        <PsAccounts>
          <template v-slot:body>
            <ps-customer
              v-if="context && context.user && context.user.email"
              ref="customer"
              :context="context"
              :onOpenModal="openBillingModal"
            />
          </template>
        </PsAccounts>
      </div>


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
import { mapActions } from 'vuex'
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
  provide() {
    return {
      emailSupport: window.psBillingContext?.context?.emailSupport
    }
  },
  data() {
    return {
      moduleLogo,
      context: window.psBillingContext?.context,
      type: ''
    }
  },
  methods: {
    openBillingModal(type, data) {
      this.type = type;
      this.context = {
        ...this.context,
        ...data
      };
    },
    closeModal(data) {
      this.type = '';
      this.$refs.customer.parent.updateProps({
        context: {
          ...this.context,
          ...data
        },
      });
    },
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
section {
  margin-bottom: 35px;
}
</style>
