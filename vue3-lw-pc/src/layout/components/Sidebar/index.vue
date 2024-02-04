<!-- 服务包弹窗 -->
<template>
  <div class="sidebar-container">
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :unique-opened="true"
        :collapse-transition="false"
        mode="vertical">
        <SidebarItem
          v-for="(route, index) in sidebarRouters"
          :key="route.path + index"
          :item="route"
          level="1"
          :base-path="resolvePath(route.path)" />
      </el-menu>
    </el-scrollbar>

    <div class="card" v-if="lwConfig.IS_LINKWECHAT">
      <div class="card-item card-ai" v-if="$store.app.serverState?.ai" @click="$store.AIDrawer = true">
        <svg-icon class="right-icon mr5" icon="custom-ai"></svg-icon>
        AI 助手
      </div>

      <el-tooltip content="文档手册" effect="dark" placement="top">
        <div class="card-item">
          <svg-icon
            class="right-icon"
            icon="custom-document"
            @click="goto('https://www.yuque.com/linkwechat/help')"></svg-icon>
        </div>
      </el-tooltip>

      <el-tooltip content="功能清单" effect="dark" placement="top">
        <div class="card-item">
          <svg-icon
            class="right-icon"
            icon="custom-read"
            @click="goto('https://docs.qq.com/sheet/DZW9HSHpHdWlOYWh2?tab=BB08J3')"></svg-icon>
        </div>
      </el-tooltip>

      <el-tooltip content="需求墙" effect="dark" placement="top">
        <div class="card-item">
          <svg-icon
            class="right-icon"
            icon="custom-tickets"
            @click="goto('https://docs.qq.com/sheet/DZWxGU0JGVFRVdWZV?tab=BB08J2')"></svg-icon>
        </div>
      </el-tooltip>

      <el-tooltip content="企业微信-管理后台" effect="dark" placement="top">
        <div class="card-item">
          <svg-icon
            class="right-icon"
            icon="custom-qiyeweixin"
            @click="goto('https://work.weixin.qq.com/wework_admin/loginpage_wx?from=myhome_baidu')"></svg-icon>
        </div>
      </el-tooltip>

      <el-tooltip content="LinkWeChat官网" effect="dark" placement="top">
        <div class="card-item">
          <svg-icon class="right-icon" icon="custom-linkWeChat" @click="goto('https://www.linkwechat.net/')" />
        </div>
      </el-tooltip>

      <el-tooltip content="源码地址" effect="dark" placement="top">
        <div class="card-item">
          <svg-icon class="right-icon" icon="gitee" @click="goto('https://gitee.com/LinkWeChat/link-wechat')" />
        </div>
      </el-tooltip>
    </div>

    <AIDrawer />
  </div>
</template>

<script>
import path from 'path-browserify'
import { mapState } from 'pinia'
import stores from '@/stores'

import SidebarItem from './SidebarItem'
import AIDrawer from './AIDrawer/index.vue'
// import ServeDialog from './ServeDialog'

export default {
  components: { SidebarItem, AIDrawer },
  computed: {
    // ...mapState(['settings']),
    ...mapState(stores, ['permission_routes', 'sidebarRouters', 'sidebar']),
    activeMenu() {
      const route = this.$route
      const { meta, path } = route
      // if set path, the sidebar will highlight the path you set
      if (meta.activeMenu) {
        return meta.activeMenu
      } else if (route.meta.hidden) {
        return route.matched.slice(-2, -1)[0].path
      }
      return path
    },
    isCollapse() {
      // return !this.sidebar.opened
      return false
    },
  },
  // mounted() {
  //   this.$nextTick(() => {
  //     console.log(this.$refs.serveDialog)
  //   })
  // },
  methods: {
    goto(url) {
      window.open(url)
    },
    resolvePath(pathStr) {
      return path.resolve(this.sidebarRouters.parentRoute.path, pathStr)
    },
  },
}
</script>

<style lang="scss" scoped>
::v-deep.sidebar-container {
  --side-bar-width: 200px;
  display: flex;
  flex-direction: column;
  transition: width 0.28s;
  width: var(--side-bar-width) !important;
  background: var(--bg-white);
  bottom: 0;
  // z-index: 1001;
  overflow: hidden;
  flex: none;
  box-shadow: 0px 2px 2px 0px rgba(228, 228, 228, 0.35);
  // reset element-ui css
  .horizontal-collapse-transition {
    transition: 0s width ease-in-out, 0s padding-left ease-in-out, 0s padding-right ease-in-out;
  }

  .scrollbar-wrapper {
    overflow-x: hidden !important;
  }

  // .el-scrollbar__bar.is-vertical {
  //   right: 0px;
  // }

  .el-scrollbar {
    flex: auto;
    border-bottom: 20px solid transparent;
  }

  &.has-logo {
    .el-scrollbar {
      height: calc(100% - 50px);
    }
  }

  .is-horizontal {
    display: none;
  }

  // .svg-icon {
  //   margin-right: 16px;
  // }

  .el-menu {
    border: none;
    height: 100%;
    width: 100% !important;
  }

  // 叶子菜单，目录
  .el-menu-item,
  .el-sub-menu > .el-sub-menu__title {
    padding: 0 !important;
    // margin: 4px auto;
    margin: 4px 10px;
    font-weight: 500;
    height: 40px;
    line-height: 40px;
    i {
      color: inherit;
    }
    // background-color: $subMenuBg !important;
    &:hover {
      color: var(--color);
      background-color: transparent !important;
    }
  }
  // 叶子菜单
  .el-menu-item {
    // margin: 4px 16px;
    min-width: auto;
    // a {
    //   &:hover {
    //     color: inherit !important;
    //   }
    // }
  }
  // 当前激活菜单
  .el-menu-item.is-active {
    background: linear-gradient(to right, var(--color) 0%, var(--color-sub) 100%);
    box-shadow: 0px 13px 16px 0px hsl(var(--hsl-dark), 0.2);
    border-radius: 8px;
    color: var(--font-white, #fff) !important;
    z-index: 1;
  }

  // 当前激活菜单所属上级菜单标题目录
  .is-active > .el-sub-menu__title {
    color: var(--color) !important;
  }
}

.hideSidebar {
  .sidebar-container {
    width: 0 !important;
  }

  .main-container {
    margin-left: 0;
  }

  .submenu-title-noDropdown {
    padding: 0 !important;
    position: relative;

    .el-tooltip {
      padding: 0 !important;

      .svg-icon {
        margin-left: 20px;
      }
    }
  }

  .el-sub-menu {
    overflow: hidden;

    & > .el-sub-menu__title {
      padding: 0 !important;

      .svg-icon {
        margin-left: 20px;
      }

      .el-sub-menu__icon-arrow {
        display: none;
      }
    }
  }

  .el-menu--collapse {
    .el-sub-menu {
      & > .el-sub-menu__title {
        & > span {
          height: 0;
          width: 0;
          overflow: hidden;
          visibility: hidden;
          display: inline-block;
        }
      }
    }
  }
}

.serve-card {
  margin: 0 24px 24px;
  padding: 15px;
  cursor: pointer;
  font-weight: 500;
  line-height: 20px;
  text-align: center;
  color: var(--color);
  background: var(--color-light-9);
  border-radius: var(--border-radius);
}
.card {
  // color: var(--font-white, #fff);
  // padding: 20px;
  // background: linear-gradient(315deg, #07c160 0%, #90de45 100%);
  // box-shadow: 0px 15px 20px 0px rgba(64, 64, 64, 0.12);
  // border-radius: var(--border-radius);
  margin: 0 0 5vh;
  display: grid;
  grid: auto/auto auto auto;
  justify-content: space-evenly;
  row-gap: 24px;
  .card-item {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 32px;
    height: 32px;
    border-radius: var(--border-radius);
    box-shadow: inset 4px 8px 16px 0px rgba(134, 144, 156, 0.18);
    border: 1px solid var(--border-black-9);
    cursor: pointer;

    .right-icon {
      font-size: 20px;
    }
  }
  .card-ai {
    border: none;
    width: auto;
    height: 38px;
    grid-column: 1 / span 3;
    background: var(--color);
    color: var(--font-white);
    font-weight: 600;
  }
}
</style>
