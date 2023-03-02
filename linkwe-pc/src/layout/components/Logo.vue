<template>
  <transition name="sidebarLogoFade">
    <div class="logo-container" :class="{ collapse: collapse }">
      <router-link key="collapse" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo" />
      </router-link>
      <hamburger />
    </div>
  </transition>
</template>

<script>
export default {
  name: 'SidebarLogo',
  props: {
    collapse: {
      type: Boolean,
    },
  },
  components: {
    Hamburger: () => import('./Hamburger'),
  },
  data() {
    return {
      title: process.env.VUE_APP_TITLE,
      logo: this.lwConfig.LOGO_TEXT_DARK,
    }
  },
}
</script>

<style lang="scss" scoped>
.sidebarLogoFade-enter-active {
  transition: opacity 1.5s;
}

.sidebarLogoFade-enter,
.sidebarLogoFade-leave-to {
  opacity: 0;
}

.logo-container {
  position: relative;
  flex: 0 1 300px;
  display: flex;
  align-items: center;
  padding-right: 10px;
  & .sidebar-logo-link {
    & .sidebar-logo {
      max-height: 44px;
      max-width: 170px;
      vertical-align: middle;
      margin-right: 12px;
    }

    & .sidebar-title {
      display: inline-block;
      margin: 0;
      color: #fff;
      font-weight: 600;
      line-height: 50px;
      font-size: 14px;
      font-family: Avenir, Helvetica Neue, Arial, Helvetica, sans-serif;
      vertical-align: middle;
    }
  }

  &.collapse {
    .sidebar-logo {
      margin-right: 0px;
    }
  }

  .el-icon-s-operation {
    color: #333;
    font-size: 20px;
  }
}
</style>
