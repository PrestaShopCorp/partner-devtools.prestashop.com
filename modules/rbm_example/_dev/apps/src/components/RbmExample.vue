<template>
  <div class="pt-2">
    <section key="display-module-plan">
      <div class="p-0 m-auto tw-container">
        <PsAccounts :force-show-plans="true">
        </PsAccounts>
      </div>

      <ps-customer
        v-if="context.user.email"
        ref="customer"
        :context="context"
        :onOpenModal="openBillingModal"
        :onEventHook="eventHookHandler"
      />
    </section>

    <modal-container
      v-if="type !== ''"
      :context="context"
      :type="type"
      :onCloseModal="closeModal"
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
    PsCustomer: CustomerComponent.driver('vue', Vue),
    ModalContainer: ModalContainerComponent.driver('vue', Vue),
  },
  provide() {
    return {
      emailSupport: window.psBillingContext.context.user.emailSupport
    }
  },
  data() {
    return {
      context: {...window.psBillingContext.context, moduleLogo},
      type: '',
      sub: null
    }
  },
  methods: {
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
