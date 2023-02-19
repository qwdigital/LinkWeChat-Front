<template>
  <!-- <el-scrollbar class="page-scrollbar"> -->
  <div class="app-main">
    <transition name="fade-transform" mode="out-in">
      <router-view class="page" :key="key" />
      <!-- <keep-alive :include="cachedViews">
      </keep-alive> -->
    </transition>
  </div>
  <!-- </el-scrollbar> -->
</template>

<script>
export default {
  name: 'AppMain',
  computed: {
    cachedViews() {
      return this.$store.state.tagsView.cachedViews
    },
    key() {
      return this.$route.path
    },
  },
}
</script>

<style lang="scss" scoped>
// ::v-deep .el-scrollbar__wrap {
//   margin: 20px 0;
//   padding: 0 20px;
// }
.app-main {
  position: relative;
  overflow-y: auto;
  margin: 20px 0 0;
  padding: 0 20px;

  &::-webkit-scrollbar-thumb {
    visibility: hidden;
  }
  &:hover::-webkit-scrollbar-thumb {
    visibility: visible;
  }
}

.page {
  background: #fff;
  border-radius: var(--border-radius-big);
  overflow: hidden;
}
.fixed-header + .app-main {
  padding-top: 50px;
}

.hasTagsView {
  .app-main {
    /* 84 = navbar + tags-view = 50 + 34 */
    height: calc(100vh - 84px);
  }

  .fixed-header + .app-main {
    padding-top: 84px;
  }
}
</style>

<style lang="scss">
// fix css style bug in open el-dialog
.el-popup-parent--hidden {
  .fixed-header {
    padding-right: 15px;
  }
}
</style>
