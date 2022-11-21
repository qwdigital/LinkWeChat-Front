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
      name: '',
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
    // 所有的路由信息
    routers() {
      return this.$store.state.permission.topbarRouters
    },
    // 设置子路由
    childrenMenus() {
      var childrenMenus = []
      this.routers.map((router) => {
        for (var item in router.children) {
          if (router.children[item].parentPath === undefined) {
            if (router.path === '/') {
              router.children[item].path = router.children[item].path
            } else {
              if (!this.ishttp(router.children[item].path)) {
                router.children[item].path = router.path + '/' + router.children[item].path
              }
            }
            router.children[item].parentPath = router.path
          }
          childrenMenus.push(router.children[item])
        }
      })
      return constantRoutes.concat(childrenMenus)
    },
    // 默认激活的菜单
    activeMenu() {
      const path = this.$route.path
      let activePath = this.defaultRouter()
      if (path.lastIndexOf('/') > 0) {
        const tmpPath = path.substring(1, path.length)
        activePath = '/' + tmpPath.substring(0, tmpPath.indexOf('/'))
      }
      //  else if ('/index' == path || '' == path) {
      //   if (!this.isFrist) {
      //     this.isFrist = true
      //     activePath = '/index'
      //   } else {
      //     activePath = '/index'
      //   }
      // }
      var routes = this.activeRoutes(activePath)
      if (routes.length === 0) {
        activePath = path
      }
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
    this.setName()
    // this.handleSelect(this.topMenus[0].path)
  },
  methods: {
    setName() {
      this.topMenus.map((dd) => {
        if (this.activeMenu == dd.path) {
          this.name = dd.meta.title
        }
      })
    },
    // 根据宽度计算设置显示栏数
    setVisibleNumber() {
      const width = document.body.getBoundingClientRect().width / 3
      this.visibleNumber = parseInt(width / 85)
    },
    // 默认激活的路由
    defaultRouter() {
      let router
      Object.keys(this.routers).some((key) => {
        if (!this.routers[key].hidden) {
          router = this.routers[key].path
          return true
        }
      })
      return router
    },
    // 菜单选择事件
    handleSelect(path, keyPath) {
      this.currentIndex = path
      let index = ''
      this.topMenus.map((dd, cc) => {
        if (path == dd.path) {
          this.name = dd.meta.title
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
        // 显示左侧联动菜单
        // if (path === '/index') {
        //   this.$router.push(path)
        // } else {
        //   }
        this.activeRoutes(path)
        // let obj = this.topMenus[index]
        // let path = this.topMenus[index].children[0].path
        // console.log(this.topMenus[index].children[0])
        // let path = ''
        // if (obj.children && obj.children.length) {
        //   path = path + obj.children[0].path
        // }
        // if (obj.children[0].children && obj.children[0].children.length) {
        //   path = path + '/' + obj.children[0].children[0].path
        // }
        if (!isExternal(path)) {
          this.$router.push({ path })
        }
      }
    },
    // 当前激活的路由
    activeRoutes(key) {
      var routes = []
      if (this.childrenMenus && this.childrenMenus.length > 0) {
        this.childrenMenus.map((item) => {
          if (key == item.parentPath) {
            routes.push(item)
          }
        })
      }
      if (routes.length > 0) {
        this.$store.commit('SET_SIDEBAR_ROUTERS', routes)
      }
      return routes
    },
    ishttp(url) {
      return url.indexOf('http://') !== -1 || url.indexOf('https://') !== -1
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
