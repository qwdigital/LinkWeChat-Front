<template>
  <div :class="classObj" class="app-wrapper">
    <div class="top-wrap">
      <TopBar />
    </div>
    <div class="main-wrap">
      <div class="main main-size">
        <sidebar />
        <div class="main-container">
          <div class="breadcrumb-wrap" v-show="visiableSidebarRouters">
            <breadcrumb />
          </div>
          <AppMain />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import AppMain from './components/AppMain'
import TopBar from './components/TopBar/index'
import Sidebar from './components/Sidebar/index.vue'
// import TagsView  from './components/TagsView/index.vue'
import Breadcrumb from './components/Breadcrumb'
import CustomerService from './components/CustomerService'

import ResizeMixin from './mixin/ResizeHandler'

import { mapState } from 'pinia'
import stores from '@/stores'

export default {
  name: 'Layout',
  components: {
    Breadcrumb,
    AppMain,
    TopBar,
    Sidebar,
    // TagsView,
    CustomerService,
  },
  mixins: [ResizeMixin],
  computed: {
    //  ...mapGetters(['sidebar', 'avatar', 'device']),
    ...mapState(stores, {
      sidebar: (state) => state.app.sidebar,
      device: (state) => state.app.device,
      showSettings: (state) => state.settings.showSettings,
      // needTagsView: (state) => state.settings.tagsView,
      // fixedHeader: (state) => state.settings.fixedHeader,
    }),
    visiableSidebarRouters() {
      let visibleRoutes = this.$store.sidebarRouters.filter((e) => !e.hidden)
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
      this.$store.closeSideBar({ withoutAnimation: false })
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
    display: flex;
    align-items: center;
    background: var(--bg-white);
    border-top: 1px solid var(--border-black-9);
  }

  &.mobile.openSidebar {
    position: fixed;
    top: 0;
  }
  .top-wrap {
    height: var(--top-nav-heght);
    background: var(--bg-white);
  }

  .main-wrap {
    height: calc(100vh - var(--top-nav-heght));
    background: #edf2f9;
    .main {
      height: 100%;
      // padding: 10px;
      display: flex;
      align-items: stretch;
    }
  }
}

.dark {
  .main-wrap {
    background: var(--bg-black-11);
  }
}
</style>
