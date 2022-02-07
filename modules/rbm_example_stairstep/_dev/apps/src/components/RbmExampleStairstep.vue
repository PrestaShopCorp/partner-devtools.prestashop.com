<template>
  <div class="pt-2">
    <section>
      <div class="p-0 m-auto tw-container">
        <PsAccounts></PsAccounts>
      </div>

      <ps-billing-customer
        v-if="billingContext.user.email"
        ref="customer"
        :context="billingContext"
        :onOpenModal="openBillingModal"
        :onEventHook="eventHookHandler"
      />
    </section>

    <ps-billing-modal
      v-if="type !== ''"
      :context="billingContext"
      :type="type"
      :onCloseModal="closeBillingModal"
      :onEventHook="eventHookHandler"
    />

    <div v-if="sub && sub.id">
      Display your configuration, only if customer have a subscription

      <ps-subscription-quantity-test :context="billingContext" />
    </div>
  </div>
</template>

<script>
import Vue from 'vue';

import {
  SubscriptionQuantityTestComponent,
  CustomerComponent,
  ModalContainerComponent,
  EVENT_HOOK_TYPE
} from "@prestashopcorp/billing-cdc/dist/bundle.umd";

export default {
  name: 'RbmExampleStairstep',
  components: {
    PsAccounts: async () => {
      let psAccounts = window?.psaccountsVue?.PsAccounts;
      if (!psAccounts) {
        console.log('Fallback to Account Vue component');
        psAccounts = require('prestashop_accounts_vue_components').PsAccounts;
      }
      return psAccounts;
    },
    PsBillingCustomer: CustomerComponent.driver('vue', Vue),
    PsBillingModal: ModalContainerComponent.driver('vue', Vue),
    PsSubscriptionQuantityTest: SubscriptionQuantityTestComponent.driver('vue', Vue),
  },
  provide() {
    return {
      emailSupport: window.psBillingContext.context.user.emailSupport
    }
  },
  data() {
    return {
      billingContext: {...window.psBillingContext.context},
      type: '',
      sub: null
    }
  },
  methods: {
    openBillingModal(type, data) {
      this.type = type;
      this.billingContext = {
        ...this.billingContext,
        ...data
      };
    },
    closeBillingModal(data) {
      this.type = '';
      this.$refs.customer.parent.updateProps({
        context: {
          ...this.billingContext,
          ...data
        },
      });
    },
    eventHookHandler(type, data) {
      switch(type) {
        case EVENT_HOOK_TYPE.BILLING_INITIALIZED:
            // data structure is: { customer, subscription }
            console.log('Billing initialized', data);
            this.sub = data.subscription;
            break;
        case EVENT_HOOK_TYPE.SUBSCRIPTION_UPDATED:
            // data structure is: { customer, subscription, card }
            console.log('Subscription updated', data);
            this.sub = data.subscription;
            break;
        case EVENT_HOOK_TYPE.SUBSCRIPTION_CANCELLED:
            // data structure is: { customer, subscription }
            console.log('Subscription cancelled', data);
            this.sub = data.subscription;
            break;
        }
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
section {
  margin-bottom: 35px;
}
</style>
