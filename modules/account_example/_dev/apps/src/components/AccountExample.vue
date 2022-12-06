<template>
  <div class="pt-2">
    <section>
      <div class="p-0 m-auto tw-container">
        <prestashop-accounts></prestashop-accounts>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'AccountExample',
  mounted() {
    if (window?.psaccountsVue) {
      console.log('Accounts Vue Component is loaded via CDN');
      return window?.psaccountsVue?.init();
    }
    const accountFallback = require('prestashop_accounts_vue_components');
    console.log('Accounts Vue Component is loaded via fallback');
    accountFallback.init();
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
section {
  margin-bottom: 35px;
}
</style>
