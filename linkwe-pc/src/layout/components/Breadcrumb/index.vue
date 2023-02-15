// 导航面包屑
<template>
  <el-breadcrumb class="app-breadcrumb" separator="/">
    <transition-group name="breadcrumb">
      <el-breadcrumb-item key="1">
        <svg-icon @click="handleLink({ path: '/' })" iconClass="home" class="cp home"></svg-icon>
      </el-breadcrumb-item>
      <el-breadcrumb-item v-for="(item, index) in levelList" :key="item.path">
        <span
          v-if="item.redirect === 'noRedirect' || index == levelList.length - 1 || !/^\//gi.test(item.redirect)"
          class="no-redirect">
          {{ transformTitle(item.meta.title) }}
        </span>
        <a v-else @click.prevent="handleLink(item)">{{ item.meta.title }}</a>
      </el-breadcrumb-item>
    </transition-group>
    <el-popover v-if="busininessDesc" placement="top-start" title="引导语" trigger="hover">
      <div v-html="busininessDesc"></div>
      <i class="el-icon-question" slot="reference"></i>
    </el-popover>
  </el-breadcrumb>
</template>

<script>
import pathToRegexp from 'path-to-regexp'

export default {
  data() {
    return {
      levelList: null,
    }
  },
  watch: {
    $route(route) {
      // if you go to the redirect page, do not update the breadcrumbs
      if (route.path.startsWith('/redirect/')) {
        return
      }
      this.$store.state.app.busininessDesc = ''
      this.getBreadcrumb()
    },
  },
  computed: {
    busininessDesc() {
      return this.$store.state.app.busininessDesc
    },
  },
  created() {
    this.getBreadcrumb()
  },
  methods: {
    getBreadcrumb() {
      // only show routes with meta.title
      let matched = this.$route.matched.filter((item) => item.meta && item.meta.title)
      const first = matched[0]

      // if (!this.isDashboard(first)) {
      //   matched = [{ path: '/index', meta: { title: '首页' } }].concat(matched)
      // }

      this.levelList = matched.filter((item) => item.meta && item.meta.title && item.meta.breadcrumb !== false)
    },
    isDashboard(route) {
      const name = route && route.name
      if (!name) {
        return false
      }
      return name.trim() === '首页'
    },
    pathCompile(path) {
      const { params } = this.$route
      var toPath = pathToRegexp.compile(path)
      return toPath(params)
    },
    handleLink(item) {
      const { redirect, path } = item
      if (redirect) {
        this.$router.push(redirect)
        return
      }
      this.$router.push(this.pathCompile(path))
    },
    transformTitle(title) {
      // 对于详情和添加为同一个路由的面包屑处理
      // 匹配菜单标题中带有 {*} 的公用路由
      let reg = /^\{(.*)\}$/gi
      if (reg.test(title)) {
        let query = this.$route.query
        if (query && query.id) {
          // 带路由查询id参数的替换 {*} 为详情 eg:活码{添加} 替换为 活码详情
          title = title.replace(reg, '详情')
        } else {
          // 默认情况下都替换为 新建
          title = title.replace(reg, '新建')
        }
      }
      return title
    },
  },
}
</script>

<style lang="scss" scoped>
.el-breadcrumb {
  display: inline-block;
  vertical-align: middle;
  font-size: 14px;
  line-height: 50px;
  margin-left: 20px;

  .no-redirect {
    color: #999;
    cursor: text;
  }
}
.el-icon-question {
  color: #888;
  margin-left: 10px;
}
.home {
  color: $blue;
}
::v-deep .el-breadcrumb__separator {
  margin: 0 5px;
}
</style>
