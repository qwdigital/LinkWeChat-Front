// 显隐侧边栏按钮
<template>
  <!-- <i class="el-icon-s-fold" :class="{ 'is-active': $store.state.app.sidebar.opened }" @click="toggleClick"></i> -->
  <svg-icon
    iconClass="nested"
    class="el-icon-s-fold"
    :class="{ 'is-active': $store.state.app.sidebar.opened }"
    @click="toggleClick"></svg-icon>
</template>

<script>
export default {
  name: 'Hamburger',
  // watch: {
  //   $route(route) {
  //     // if you go to the redirect page, do not update the breadcrumbs
  //     if (route.name == '首页') {
  //       this.$store.state.app.sidebar.opened = 0
  //     }
  //   },
  // },
  methods: {
    toggleClick() {
      this.$store.dispatch('app/toggleSideBar')
    },
  },
}
</script>

<style lang="scss" scoped>
.el-icon-s-fold {
  font-size: 20px;
  &.is-active {
    transform: rotate(180deg);
  }
}
</style>
