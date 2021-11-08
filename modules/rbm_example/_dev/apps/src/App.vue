<template>
  <div id="app">
    <rbm-example />
  </div>
</template>

<script>
import RbmExample from "@/components/RbmExample.vue";

export default {
  name: 'App',
  components: {
    RbmExample
  },
  setup() {
    console.log('rbm example initialized');
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
