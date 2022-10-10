<template>
  <div>
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :background-color="
          settings.sideTheme === 'theme-dark' ? variables.menuBackground : variables.menuLightBackground
        "
        :text-color="settings.sideTheme === 'theme-dark' ? variables.menuColor : variables.menuLightColor"
        :unique-opened="true"
        :active-text-color="settings.theme"
        :collapse-transition="false"
        mode="vertical"
      >
        <sidebar-item
          v-for="(route, index) in sidebarRouters"
          :key="route.path + index"
          :item="route"
          :base-path="route.path"
        />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script>
  import { mapGetters, mapState } from 'vuex'
  import SidebarItem from './SidebarItem'
  import variables from '@/styles/variables.scss'

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
      variables() {
        return variables
      },
      isCollapse() {
        // return !this.sidebar.opened
        return false
      }
    }
  }
</script>
