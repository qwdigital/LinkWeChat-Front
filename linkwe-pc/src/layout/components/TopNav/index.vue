<template>
  <!-- <el-scrollbar class="nav-scrollbar"> -->
  <el-menu :default-active="activeMenu" mode="horizontal" @select="handleSelect">
    <el-menu-item v-for="(item, index) in topMenus" :index="item.path" :key="index">
      {{ item.meta.title }}
    </el-menu-item>
  </el-menu>
  <!-- </el-scrollbar> -->
</template>

<script>
import { isExternal } from '@/utils/validate'

export default {
  data() {
    return {
      // name: '',
      // 当前激活菜单的
      currentIndex: '',
    }
  },
  computed: {
    // 顶部显示菜单
    topMenus() {
      let topMenus = []
      this.routers.map((menu) => {
        if (menu.hidden !== true) {
          // 兼容顶部栏一级菜单内部跳转 (you bug)
          // if (menu.path === '/') {
          //   topMenus.push(menu.children[0])
          // } else {
          //   }
          topMenus.push(menu)
        }
      })
      return topMenus
    },
    routers() {
      return this.$store.state.permission.topbarRouters
    },
    // 默认激活的一级菜单路径 eg：/drainageCode
    activeMenu() {
      const path = this.$route.path
      let activePath = ''
      // 兼容微服务多级路径匹配eg：/microStore/*
      if (
        window.lwConfig.MICRO_APPS &&
        Object.values(window.lwConfig.MICRO_APPS).some((item) => path.startsWith(item.activeRule.match('/.*')[0]))
      ) {
        activePath = path.match('/.+?/.+?/')[0].slice(0, -1)
      } else {
        activePath = path.match(/\/[^\/]+/)
        activePath = activePath && activePath[0]
      }
      this.activeRoutes(activePath)
      return activePath
    },
  },
  mounted() {
    // this.setName()
  },
  methods: {
    // setName() {
    //   this.topMenus.map((dd) => {
    //     if (this.activeMenu == dd.path) {
    //       this.name = dd.meta.title
    //     }
    //   })
    // },

    // 菜单选择事件
    handleSelect(path, keyPath) {
      this.topMenus.map((dd, cc) => {
        if (path == dd.path) {
          // this.name = dd.meta.title
        }
      })
      if (this.ishttp(path)) {
        // http(s):// 路径新窗口打开
        window.open(path, '_blank')
      } else if (path.indexOf('/redirect') !== -1) {
        // /redirect 路径内部打开
        this.$router.push({ path: path.replace('/redirect', '') })
      } else {
        this.activeRoutes(path)

        if (!isExternal(path)) {
          this.$router.push({ path })
        }
      }
    },
    // 当前激活的侧边栏菜单
    activeRoutes(path) {
      let activeRoute = this.routers.find((e) => e.path == path)
      let routes = (activeRoute && activeRoute.children) || []
      if (routes.length > 0) {
        this.$store.commit('SET_SIDEBAR_ROUTERS', routes)
      }
      return routes
    },
    ishttp(url) {
      return /^http/.test(url)
    },
  },
}
</script>

<style lang="scss" scoped>
.g-bg-lg {
  background: linear-gradient(to left, var(--color) 0%, var(--color-sub) 100%);
  box-shadow: 0px 13px 16px 0px rgba(7, 168, 85, 0.2);
}
// .nav-scrollbar {
//   width: calc(100% - 580px);
//   ::v-deep.el-scrollbar__view {
//     white-space: nowrap;
//   }
// }
.el-menu--horizontal {
  background-color: transparent;
  border: none;
  white-space: nowrap;
  flex: 1 1 1200px;
  & > .el-menu-item {
    height: 38px !important;
    line-height: 38px !important;
    color: #1d2129;
    border-radius: 8px;
    font-weight: bold;
    margin: 0 4px !important;
    border: 0;
    padding: 0px min(1.1vw, 20px);
    float: none;
    display: inline-block;
    &::after {
      content: '';
      display: block;
      opacity: 0;
      position: absolute;
      top: 0;
      left: 0;
      z-index: -1;
      width: 100%;
      height: 100%;
      border-radius: 8px;
      transition: opacity 0.3s;
      @extend .g-bg-lg;
    }
    &:not(.is-disabled) {
      &:hover,
      &:focus {
        &::after {
          opacity: 1;
        }
        background-color: transparent;
        color: #fff;
      }
    }
  }

  & > .el-menu-item.is-active,
  & > .el-submenu.is-active .el-submenu__title {
    @extend .g-bg-lg;
    color: #fff;
    border: 0;
  }

  // /* submenu item */
  // & > .el-submenu .el-submenu__title {
  //   float: left;
  //   height: 50px !important;
  //   line-height: 50px !important;
  //   color: #999093 !important;
  //   padding: 0 5px !important;
  //   margin: 0 10px !important;
  // }
}
</style>
