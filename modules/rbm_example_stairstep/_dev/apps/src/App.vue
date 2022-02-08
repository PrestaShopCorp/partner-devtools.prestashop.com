<template>
  <div id="app">
    <rbm-example-stairstep />
  </div>
</template>

<script>
import RbmExampleStairstep from "@/components/RbmExampleStairstep.vue";

export default {
  name: 'App',
  components: {
    RbmExampleStairstep
  },
  setup() {
    console.log('rbm example stairstep initialized');
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
