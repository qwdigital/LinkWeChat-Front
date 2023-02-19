<template>
  <div class="navbar main-size">
    <logo />

    <!-- <el-scrollbar class="nav-scrollbar">
      <template v-for="(route, index) in permission_routes">
        <div
          v-if="!route.hidden"
          :class="['nav', $route.path.startsWith(route.path) && 'active']"
          :key="route.path + index"
          @click="goLink(route.path)"
        >
          {{ route.meta && route.meta.title }}
        </div>
      </template>
    </el-scrollbar> -->
    <!-- <el-scrollbar class="nav-scrollar"> -->
    <top-nav id="topmenu-container" />
    <!-- </el-scrollbar> -->
    <div class="right-menu mr20">
      <template v-if="device !== 'mobile'">
        <!-- <search id="header-search" class="right-menu-item" /> -->
        <!-- <el-popover placement="right" width="300" trigger="hover">
           <div class="hover-class">
             <span>扫码联系专属客服</span>
             <img :src="customerServiceQr" alt="" />
             <span>立马扫码一对一答疑</span>
           </div>
           <div class="right-menu-item hover-effect" slot="reference" style="font-size:24px">
             <svg-icon class="right-icon" iconClass="customer-service"></svg-icon>
           </div>
       </el-popover> -->
        <el-tooltip content="企业微信-管理后台" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <svg-icon class="right-icon mt5" iconClass="qiyeweixin" @click="goLink2()"></svg-icon>
            <!-- <img @click="goLink2()" style="height:20px;width:24px;margin-top:4px;" src="@/assets/image/wechat-logo.png"></img> -->
          </div>
        </el-tooltip>
        <!-- <el-tooltip content="源码地址" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <svg-icon icon-class="github" @click="goto(0)" />
          </div>
        </el-tooltip>

        <el-tooltip content="文档地址" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <i class="el-icon-reading document" @click="goto(1)"></i>
          </div>
        </el-tooltip>

        <screenfull id="screenfull" class="right-menu-item hover-effect" /> -->
      </template>

      <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="click">
        <div class="avatar-wrapper">
          <img :src="avatar" class="user-avatar" />
          <div title="仟微" class="user-name toe">{{ name }}</div>
          <i class="el-icon-arrow-down" />
        </div>
        <el-dropdown-menu slot="dropdown">
          <router-link to="/user/profile">
            <el-dropdown-item>个人中心</el-dropdown-item>
          </router-link>
          <!-- <el-dropdown-item divided @click.native="setting = true">
            <span>布局设置</span>
          </el-dropdown-item> -->
          <el-dropdown-item @click.native="logout">
            <span>退出登录</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
import { isExternal } from '@/utils/validate'
import { mapGetters } from 'vuex'
import Logo from './Logo'
// import { getCustomerServiceQrUrl } from "@/api/login";

// import Search from '@/components/HeaderSearch'
// import screenfull from '@/components/Screenfull'
import TopNav from './TopNav'

export default {
  data() {
    return {
      customerServiceQr: '',
    }
  },
  components: {
    Logo,
    // Search,
    // screenfull,
    TopNav,
  },
  computed: {
    ...mapGetters(['avatar', 'name', 'device', 'permission_routes']),
    setting: {
      get() {
        return this.$store.state.settings.showSettings
      },
      set(val) {
        this.$store.dispatch('settings/changeSetting', {
          key: 'showSettings',
          value: val,
        })
      },
    },
  },
  mounted() {
    // console.log(this.permission_routes)
    // getCustomerServiceQrUrl().then((res) => {
    // this.customerServiceQr = res.data;
    // localStorage.setItem('customerServiceQr',res.data)
    // });
  },
  methods: {
    async logout() {
      this.$confirm('确定注销并退出系统吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        this.$store.dispatch('LogOut').then(() => {
          location.href = window.lwConfig.BASE_URL
        })
      })
    },
    goto(type) {
      window.open(type ? 'https://www.yuque.com/linkwechat/help/dsatfs' : 'https://gitee.com/LinkWeChat/link-wechat')
    },
    goLink2() {
      window.open('https://work.weixin.qq.com/wework_admin/loginpage_wx?from=myhome_baidu', '_blank')
    },
    goLink(path) {
      if (!isExternal(path)) {
        this.$router.push({ path })
      } else {
        window.open(path, '_blank')
      }
    },
  },
}
</script>

<style lang="scss" scoped>
// .topmenu-container {
//   margin-left: auto;
//   display: inline-block;
//   position: absolute;
//   right: 100px;
//   top: 50%;
//   transform: translateY(-50%);
// }
.hover-class {
  display: flex;
  flex-direction: column;
  align-items: center;
  span:nth-child(1) {
    font-size: 18px;
    font-weight: bold;
    line-height: 36px;
    margin-bottom: 10px;
  }
  img {
    width: 160px;
    height: 160px;
  }
  span:nth-child(3) {
    font-size: 14px;
    line-height: 16px;
    margin-top: 20px;
  }
}
.right-icon {
  font-size: 18px;
}
//
.navbar {
  display: flex;
  align-items: center;
  width: 100%;
  height: 100%;
  overflow: hidden;
  position: relative;
  color: #1d2129;

  .errLog-container {
    display: inline-block;
    vertical-align: top;
  }

  .right-menu {
    position: absolute;
    right: 0;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 0 0 8px;
      // color: #5a5e66;
      vertical-align: middle;

      &.hover-effect {
        cursor: pointer;
        transition: background 0.3s;

        // &:hover {
        //   background: rgba(0, 0, 0, 0.025);
        // }
      }

      .document {
        font-size: 20px;
      }
    }

    .avatar-container {
      // margin-right: 30px;

      .avatar-wrapper {
        position: relative;
        .user-avatar {
          ---temp: #fafafa;
          display: inline-block;
          position: relative;
          width: 34px;
          height: 34px;
          border-radius: 8px;
          vertical-align: middle;
          // background: var(---temp);
          border: 1px solid var(---temp);
        }
        .user-name {
          display: inline-block;
          max-width: 100px;
          vertical-align: middle;
          font-weight: 500;
        }

        .el-icon-arrow-down {
          margin-left: 3px;
          font-size: 12px;
          color: #000;
        }
      }
    }
  }
}

.nav-scrollbar {
  width: calc(100% - 450px);
  ::v-deep.el-scrollbar__view {
    white-space: nowrap;
    line-height: 58px;
  }
  .nav {
    display: inline-block;
    margin: 0 20px;
    flex: none;
    position: relative;
    cursor: pointer;
    &.active::after {
      content: '';
      display: inline-block;
      position: absolute;
      bottom: 2px;
      width: 42px;
      height: 2px;
      left: 50%;
      transform: translateX(-50%);
      border-radius: 6px;
      background: #fff;
    }
  }
}
</style>
