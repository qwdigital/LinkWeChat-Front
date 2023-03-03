<template>
  <div class="sidebar-container">
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :unique-opened="true"
        :collapse-transition="false"
        mode="vertical">
        <sidebar-item
          v-for="(route, index) in sidebarRouters"
          :key="route.path + index"
          :item="route"
          level="1"
          :base-path="route.path" />
      </el-menu>
    </el-scrollbar>

    <div class="card">
      <div class="">{{ lwConfig.SYSTEM_NAME }}</div>
      <div class="info mt10 mb5">版本: 全功能v4最新版</div>
      <!-- <div class="info">期限: 本世纪末</div> -->
      <div class="mt10 mb10">欢迎您登陆本系统</div>
      <el-popover placement="top" title="" width="80" trigger="hover">
        <el-button slot="reference" type="default" plain>联系客服</el-button>
        <div class="ac">
          <img :src="lwConfig.QRCODE_CONTACT_US" class="contact-code" alt="" />
          <div class="nav-li">微信扫码咨询</div>
        </div>
      </el-popover>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import SidebarItem from './SidebarItem'

export default {
  components: { SidebarItem },
  computed: {
    ...mapState(['settings']),
    ...mapGetters(['permission_routes', 'sidebarRouters', 'sidebar']),
    activeMenu() {
      const route = this.$route
      const { meta, path } = route
      // if set path, the sidebar will highlight the path you set
      if (meta.activeMenu) {
        return meta.activeMenu
      } else if (route.meta.hidden) {
        return route.matched.slice(-1)[0].parent.path
      }
      return path
    },
    isCollapse() {
      // return !this.sidebar.opened
      return false
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
  background-color: #fff;
  bottom: 0;
  z-index: 1001;
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

  .svg-icon {
    margin-right: 16px;
  }

  .el-menu {
    border: none;
    height: 100%;
    width: 100% !important;
  }

  // 叶子菜单，目录
  .el-menu-item,
  .el-submenu > .el-submenu__title {
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
    box-shadow: 0px 13px 16px 0px rgba(7, 168, 85, 0.2);
    border-radius: 8px;
    color: #fff !important;
    z-index: 1;
  }

  // 当前激活菜单所属上级菜单标题目录
  .is-active > .el-submenu__title {
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

  .el-submenu {
    overflow: hidden;

    & > .el-submenu__title {
      padding: 0 !important;

      .svg-icon {
        margin-left: 20px;
      }

      .el-submenu__icon-arrow {
        display: none;
      }
    }
  }

  .el-menu--collapse {
    .el-submenu {
      & > .el-submenu__title {
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

.card {
  color: #fff;
  margin: 0 20px 30px;
  padding: 20px;
  background: linear-gradient(315deg, #07c160 0%, #90de45 100%);
  box-shadow: 0px 15px 20px 0px rgba(64, 64, 64, 0.12);
  border-radius: var(--border-radius);

  .info {
    font-size: 12px;
  }
  .el-button {
    width: 100%;
    color: #333;
  }
}
.contact-code {
  width: 80px;
}
</style>
