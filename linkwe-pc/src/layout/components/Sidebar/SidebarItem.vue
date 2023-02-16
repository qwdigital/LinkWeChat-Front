<template>
  <div v-if="!item.hidden">
    <app-link v-if="isLeafMeu(item)" :to="resolvePath(onlyOneChild.path, onlyOneChild.query)">
      <el-menu-item v-if="onlyOneChild.meta" :index="resolvePath(onlyOneChild.path)">
        {{ onlyOneChild.meta.title }}
      </el-menu-item>
    </app-link>

    <el-submenu v-else :index="resolvePath(item.path)" popper-append-to-body>
      <span slot="title" v-if="item.meta">{{ item.meta.title }}</span>
      <sidebar-item
        v-for="child in item.children"
        :key="child.path"
        :is-nest="true"
        :item="child"
        :base-path="resolvePath(child.path)"
        class="nest-menu" />
    </el-submenu>
  </div>
</template>

<script>
import path from 'path'
import { isExternal } from '@/utils/validate'
import Item from './Item'
import AppLink from './Link'
import FixiOSBug from './FixiOSBug'

export default {
  name: 'SidebarItem',
  components: { Item, AppLink },
  mixins: [FixiOSBug],
  props: {
    // route object
    item: {
      type: Object,
      required: true,
    },
    isNest: {
      type: Boolean,
      default: false,
    },
    basePath: {
      type: String,
      default: '',
    },
  },
  data() {
    this.onlyOneChild = null
    return {}
  },
  methods: {
    hasOneShowingChild(children, parent) {
      // 菜单叶子，无子路由的
      if (!children) {
        this.onlyOneChild = { ...parent, path: '' }
        return true
      }

      const showingChildren = children.filter((item) => {
        if (item.hidden) {
          return false
        } else {
          // Temp set(will be used if only has one showing child)
          this.onlyOneChild = item
          return true
        }
      })

      // When there is only one child router, the child router is displayed by default
      // if (showingChildren.length === 1) {
      //   return true
      // }

      // 菜单目录，无子路由的 ；或者有子路由的，且子路由全部不显示的，显示父级
      if (showingChildren.length === 0) {
        this.onlyOneChild = { ...parent, path: '', noShowingChildren: true }
        return true
      }

      return false
    },
    isLeafMeu(item) {
      return this.hasOneShowingChild(item.children, item) && (!item.alwaysShow || this.onlyOneChild.noShowingChildren)
    },
    resolvePath(routePath, routeQuery) {
      if (isExternal(routePath)) {
        return routePath
      }
      if (isExternal(this.basePath)) {
        return this.basePath
      }
      if (/^\//.test(routePath)) {
        return routePath
      }
      if (routeQuery) {
        let query = JSON.parse(routeQuery)
        return { path: path.resolve(this.basePath, routePath), query: query }
      }
      return path.resolve(this.basePath, routePath)
    },
  },
}
</script>
