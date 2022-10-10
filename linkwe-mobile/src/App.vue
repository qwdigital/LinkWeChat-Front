<script>
export default {
  name: 'App',
  provide() {
    return {
      reload: this.reload,
    }
  },
  data() {
    return {}
  },

  created() {},
  methods: {
    reload() {
      this.$store.state.reload = false
      this.$nextTick(() => {
        this.$store.state.reload = true
      })
    },
  },
}
</script>
<template>
  <div id="app">
    <router-view class="page" v-if="$store.state.reload" />
  </div>
</template>

<style lang="less">
.page {
  height: 100vh;
  background: #fafafa;
  overflow: auto;
}
</style>
