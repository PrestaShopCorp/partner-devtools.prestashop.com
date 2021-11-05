<template>
  <div class="pt-2">
    <section key="display-module-plan">
      <div class="p-0 m-auto tw-container">
        <PsAccounts>
          <template v-slot:body>
              <!-- Put here what you want to show in the ps account container -->
          </template>
          <!-- or -->
          <template v-slot:customBody>
              <!-- Put here what you want to show in the ps account container -->
          </template>
        </PsAccounts>
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

    <div v-if="sub && sub.id">Rbm example content</div>

  </div>
</template>

<script>
import Vue from 'vue';
import {PsAccounts} from "prestashop_accounts_vue_components";
import moduleLogo from "@/assets/prestashop-logo.png";
import { CustomerComponent, ModalContainerComponent, EVENT_HOOK_TYPE } from "@prestashopcorp/billing-cdc/dist/bundle.umd";

export default {
  name: 'RbmExample',
  components: {
    PsAccounts,
    PsBillingCustomer: CustomerComponent.driver('vue', Vue),
    PsBillingModal: ModalContainerComponent.driver('vue', Vue),
  },
  provide() {
    return {
      emailSupport: window.psBillingContext.context.user.emailSupport
    }
  },
  data() {
    return {
      billingContext: {...window.psBillingContext.context, moduleLogo},
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
        billingContext: {
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
            console.log('Sub updated', data);
            this.sub = data.subscription;
            break;
        case EVENT_HOOK_TYPE.SUBSCRIPTION_CANCELLED:
            // data structure is: { customer, subscription }
            console.log('Sub cancelled', data);
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
