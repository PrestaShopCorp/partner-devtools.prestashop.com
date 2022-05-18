<template>
  <div class="pt-2">
    <section>
      <div class="p-0 m-auto tw-container">
        <PsAccounts></PsAccounts>
      </div>
    </section>

    <div v-if="sub && sub.id">
      Display your configuration, only if customer is associated
    </div>
  </div>
</template>

<script>
export default {
  name: 'AccountExample',
  components: {
    PsAccounts: async () => {
      let psAccounts = window?.psaccountsVue?.PsAccounts;
      if (!psAccounts) {
        console.log('Fallback to Account Vue component');
        psAccounts = require('prestashop_accounts_vue_components').PsAccounts;
      }

      return psAccounts;
    },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
section {
  margin-bottom: 35px;
}
</style>
