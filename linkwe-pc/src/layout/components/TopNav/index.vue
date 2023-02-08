<template>
  <el-menu :default-active="activeMenu" background-color="transparent" mode="horizontal" @select="handleSelect">
    <template v-for="(item, index) in topMenus">
      <el-menu-item :index="item.path" :key="index">{{ item.meta.title }}</el-menu-item>
    </template>

    <!-- 顶部菜单超出数量折叠 -->
    <!-- <el-submenu :style="{'--theme': theme}" :index="currentIndex">
      <template slot="title">{{name}}</template>
      <template v-for="(item, index) in topMenus">
        <el-menu-item :index="item.path" :key="index">
          <svg-icon :icon-class="item.meta.icon" /> {{ item.meta.title }}</el-menu-item>
      </template>
    </el-submenu> -->
  </el-menu>
</template>

<script>
import { constantRoutes } from '@/router'
import { isExternal } from '@/utils/validate'

export default {
  data() {
    return {
      // name: '',
      // 顶部栏初始数
      visibleNumber: 5,
      // 是否为首次加载
      isFrist: false,
      // 当前激活菜单的
      currentIndex: '',
    }
  },
  computed: {
    theme() {
      return this.$store.state.settings.theme
    },
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
      let activePath = this.$route.path.match(/\/[^\/]+/)
      activePath = activePath && activePath[0]
      this.activeRoutes(activePath)
      return activePath
    },
  },
  beforeMount() {
    window.addEventListener('resize', this.setVisibleNumber)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.setVisibleNumber)
  },
  mounted() {
    this.setVisibleNumber()
    // this.setName()
    // this.handleSelect(this.topMenus[0].path)
  },
  methods: {
    // setName() {
    //   this.topMenus.map((dd) => {
    //     if (this.activeMenu == dd.path) {
    //       this.name = dd.meta.title
    //     }
    //   })
    // },
    // 根据宽度计算设置显示栏数
    setVisibleNumber() {
      const width = document.body.getBoundingClientRect().width / 3
      this.visibleNumber = parseInt(width / 85)
    },
    // 菜单选择事件
    handleSelect(path, keyPath) {
      this.currentIndex = path
      let index = ''
      this.topMenus.map((dd, cc) => {
        if (path == dd.path) {
          // this.name = dd.meta.title
          index = cc
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

<style lang="scss">
.el-menu {
  background-color: transparent !important;
}
.el-menu.el-menu--horizontal {
  border: none !important;
}
.el-menu--horizontal > .el-menu-item {
  float: left;
  height: 50px !important;
  line-height: 50px !important;
  color: #fff !important;
  // padding: 0 5px !important;
  margin: 0 10px !important;
}
.el-menu-item:hover {
  background-color: transparent !important;
}

.el-menu--horizontal > .el-menu-item.is-active,
.el-menu--horizontal > .el-submenu.is-active .el-submenu__title {
  border-bottom: 2px solid #fff !important;
  // color: #303133;
}

/* submenu item */
.el-menu--horizontal > .el-submenu .el-submenu__title {
  float: left;
  height: 50px !important;
  line-height: 50px !important;
  color: #999093 !important;
  padding: 0 5px !important;
  margin: 0 10px !important;
}
</style>
