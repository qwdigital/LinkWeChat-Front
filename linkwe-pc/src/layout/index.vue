<template>
  <div :class="classObj" class="app-wrapper">
    <div class="top-wrap no-dark">
      <navbar />
    </div>
    <div class="main-wrap">
      <div class="main main-size">
        <sidebar v-if="isSidebar" class="sidebar-container" />
        <div class="main-container">
          <div v-show="visiableSidebarRouters">
            <hamburger id="hamburger-container" class="hamburger-container" />
            <breadcrumb id="breadcrumb-container" class="breadcrumb-container" />
          </div>
          <app-main />
          <right-panel v-if="showSettings">
            <settings />
          </right-panel>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import RightPanel from '@/components/RightPanel'
import { AppMain, Navbar, Settings, Sidebar, TagsView } from './components'
import Breadcrumb from './components/Breadcrumb'
import Hamburger from './components/Hamburger'
import CustomerService from './components/CustomerService'

import ResizeMixin from './mixin/ResizeHandler'
import { mapState } from 'vuex'

export default {
  name: 'Layout',
  components: {
    Breadcrumb,
    Hamburger,
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
@import '~@/styles/mixin.scss';

.app-wrapper {
  @include clearfix;
  position: relative;
  height: 100%;
  width: 100%;

  &.mobile.openSidebar {
    position: fixed;
    top: 0;
  }
  //   .customer-service {
  //     position: absolute;
  //     bottom: 120px;
  //     right: 20px;
  //     z-index: 99999;
  //   }
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
  }
}

.drawer-bg {
  background: #000;
  opacity: 0.3;
  width: 100%;
  top: 0;
  height: 100%;
  position: absolute;
  z-index: 999;
}

.fixed-header {
  position: fixed;
  top: 0;
  right: 0;
  z-index: 9;
  width: calc(100% - #{$sideBarWidth});
  transition: width 0.28s;
}

.hideSidebar .fixed-header {
  width: calc(100% - 54px);
}

.mobile .fixed-header {
  width: 100%;
}

.hamburger-container {
  cursor: pointer;
  transition: background 0.3s;
  -webkit-tap-highlight-color: transparent;

  &:hover {
    background: rgba(0, 0, 0, 0.025);
  }
}
.slogan {
  font-size: 22px;
  color: #999;
  vertical-align: middle;
}
</style>
