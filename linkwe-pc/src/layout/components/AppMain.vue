<template>
  <!-- <el-scrollbar class="page-scrollbar"> -->
  <div class="app-main">
    <transition name="fade-transform" mode="out-in" v-if="!isActiveMicroApp">
      <router-view class="page" :key="key" />
      <!-- <keep-alive :include="cachedViews">
      </keep-alive> -->
    </transition>
    <div v-loading="loading">
      <div id="micro-app" v-show="isActiveMicroApp">
        <!-- <div id="app" class="mask" style="position: absolute">
        <i class="el-icon-loading cc"></i>
      </div> -->
      </div>
    </div>
  </div>
  <!-- </el-scrollbar> -->
</template>

<script>
import { registerMicroApps, start, initGlobalState } from 'qiankun'
export default {
  name: 'AppMain',
  computed: {
    cachedViews() {
      return this.$store.state.tagsView.cachedViews
    },
    key() {
      return this.$route.path
    },
    isActiveMicroApp() {
      let microApp = window.lwConfig.MICRO_APPS
      return (
        microApp && Object.values(microApp).some((item) => this.$route.path.startsWith(item.activeRule.match('/.*')[0]))
      )
    },
  },
  mounted() {
    if (window.lwConfig.MICRO_APPS && window.lwConfig.MICRO_APPS.store) {
      window.Vue2 = window.Vue
      delete window.Vue
      window.lwConfig.MICRO_APPS.store.loader = (loading) => (this.loading = loading)
      registerMicroApps([window.lwConfig.MICRO_APPS.store])
      start({
        sandbox: { experimentalStyleIsolation: true },
      })

      // 挂在window供下面微服务使用
      window.lwConfig.$store = this.$store

      // 初始化 state
      // const actions = initGlobalState({ token: getToken() })
      // actions.onGlobalStateChange((state, prev) => {
      //   // state: 变更后的状态; prev 变更前的状态
      // });
      // actions.setGlobalState(state)
    }
    // if (window.lwConfig.MICRO_APPS) {
    //   import('qiankun').then(({ registerMicroApps, start }) => {
    //     registerMicroApps(window.lwConfig.MICRO_APPS)
    //     start({
    //       sandbox: { experimentalStyleIsolation: true },
    //     })
    //   })
    // }
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
  flex: auto;
  &::-webkit-scrollbar-thumb {
    visibility: hidden;
  }
  &:hover::-webkit-scrollbar-thumb {
    visibility: visible;
  }
}

.page {
  // background: #fff;
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

#micro-app {
  height: calc(100vh - 130px);
  position: relative;
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
