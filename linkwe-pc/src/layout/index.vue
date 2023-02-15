<template>
  <div :class="classObj" class="app-wrapper">
    <div class="top-wrap no-dark">
      <navbar />
    </div>
    <div class="main-wrap">
      <div class="main main-size">
        <sidebar v-if="isSidebar" class="sidebar-container" />
        <div class="main-container">
          <div class="breadcrumb-wrap" v-show="visiableSidebarRouters">
            <breadcrumb />
          </div>
          <div class="page-content">
            <app-main />
            <RightPanel v-if="showSettings">
              <settings />
            </RightPanel>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import RightPanel from '@/components/RightPanel'
import { AppMain, Navbar, Settings, Sidebar, TagsView } from './components'
import Breadcrumb from './components/Breadcrumb'
import CustomerService from './components/CustomerService'

import ResizeMixin from './mixin/ResizeHandler'
import { mapState } from 'vuex'

export default {
  name: 'Layout',
  components: {
    Breadcrumb,
    AppMain,
    Navbar,
    RightPanel,
    Settings,
    Sidebar,
    TagsView,
    CustomerService,
  },
  mixins: [ResizeMixin],
  computed: {
    //  ...mapGetters(['sidebar', 'avatar', 'device']),
    ...mapState({
      sidebar: (state) => state.app.sidebar,
      device: (state) => state.app.device,
      showSettings: (state) => state.settings.showSettings,
      // needTagsView: (state) => state.settings.tagsView,
      // fixedHeader: (state) => state.settings.fixedHeader,
    }),
    visiableSidebarRouters() {
      let visibleRoutes = this.$store.getters.sidebarRouters.filter((e) => !e.hidden)
      return visibleRoutes && visibleRoutes.length
    },
    isSidebar() {
      return this.visiableSidebarRouters && this.sidebar.opened
    },
    classObj() {
      return {
        openSidebar: this.isSidebar,
        hideSidebar: !this.isSidebar,
        withoutAnimation: this.sidebar.withoutAnimation,
        mobile: this.device === 'mobile',
      }
    },
  },
  methods: {
    handleClickOutside() {
      this.$store.dispatch('app/closeSideBar', { withoutAnimation: false })
    },
  },
}
</script>

<style lang="scss" scoped>
.app-wrapper {
  position: relative;
  height: 100%;
  width: 100%;

  .main-container {
    min-height: 100%;
    transition: all 0.28s;
    position: relative;
    flex: auto;
    overflow: auto;
    display: flex;
    flex-direction: column;
  }
  .breadcrumb-wrap {
    background: #fff;
    border-top: 1px solid #eee;
  }
  .page-content {
    margin: 20px 20px 0;
  }

  &.mobile.openSidebar {
    position: fixed;
    top: 0;
  }
  .top-wrap {
    height: 64px;
  }

  .main-wrap {
    height: calc(100vh - 64px);
    background: #edf2f9;
    .main {
      height: 100%;
      // padding: 10px;
      display: flex;
      align-items: stretch;
    }

    .breadcrumb-wrap {
    }
  }
}
</style>
