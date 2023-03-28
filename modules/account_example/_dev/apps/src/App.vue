<template>
  <div id="app">
    <account-example />
  </div>
</template>

<script>
import AccountExample from "@/components/AccountExample.vue";

export default {
  name: 'App',
  components: {
    AccountExample
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
