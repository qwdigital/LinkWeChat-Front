// 显隐侧边栏按钮
<template>
  <!-- <i class="el-icon-s-fold" :class="{ 'open': $store.state.app.sidebar.opened }" @click="toggle"></i> -->
  <!-- <svg-icon
    iconClass="nested"
    class="el-icon-s-fold"
    :class="{ 'open': $store.state.app.sidebar.opened }"
    @click="toggle"></svg-icon> -->
  <div class="toggle" :class="{ open: $store.state.app.sidebar.opened }" @click="toggle">
    <div class="toggle-line"></div>
    <div class="toggle-line line-middle"></div>
    <div class="toggle-line"></div>
  </div>
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
    toggle() {
      this.$store.dispatch('app/toggleSideBar')
    },
  },
}
</script>

<style lang="scss" scoped>
// .el-icon-s-fold {
//   font-size: 20px;
//   &.open {
//     transform: rotate(180deg);
//   }
// }
.toggle {
  position: relative;
  cursor: pointer;
  .toggle-line {
    position: relative;
    left: 0;
    width: 18px;
    height: 2px;
    background: #4e5969;
    border-radius: 8px;
    transition: all 0.3s;
  }
  .line-middle {
    position: relative;
    margin: 4px 0;
    left: -5px;
  }
  &.open {
    .toggle-line {
      // transform: rotateY(360deg);
      left: 3px;
    }
    .line-middle {
      left: 8px;
    }
  }
}
</style>
