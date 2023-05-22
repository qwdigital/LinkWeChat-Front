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
    <top-nav />
    <div class="right-menu mr10">
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

        <!-- <el-tooltip content="企业微信-管理后台" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <svg-icon
              class="right-icon"
              iconClass="qiyeweixin"
              style="color: #0082f0"
              @click="goto('https://work.weixin.qq.com/wework_admin/loginpage_wx?from=myhome_baidu')"></svg-icon>
          </div>
        </el-tooltip>
        <el-tooltip content="源码地址" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <svg-icon class="right-icon" icon-class="gitee" @click="goto('https://gitee.com/LinkWeChat/link-wechat')" />
          </div>
        </el-tooltip>

        <el-tooltip content="LinkWeChat官网" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <i class="el-icon-link right-icon" @click="goto('https://www.linkwechat.net/')" />
          </div>
        </el-tooltip>

        <el-tooltip content="文档手册" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <i class="el-icon-reading document right-icon" @click="goto('https://www.yuque.com/linkwechat/help')"></i>
          </div>
        </el-tooltip>

        <el-tooltip content="功能清单" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <i
              class="el-icon-tickets right-icon"
              @click="goto('https://docs.qq.com/sheet/DZW9HSHpHdWlOYWh2?tab=BB08J3')"></i>
          </div>
        </el-tooltip>

        <el-tooltip content="需求墙" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <i
              class="el-icon-data-board right-icon"
              @click="goto('https://docs.qq.com/sheet/DZWxGU0JGVFRVdWZV?tab=BB08J2')"></i>
          </div>
        </el-tooltip> -->

        <!-- <screenfull id="screenfull" class="right-menu-item hover-effect" /> -->

        <el-tooltip content="点击前往linwechat-vue3版本 v5.0.0.alpha.1" effect="light" placement="bottom">
          <div class="right-menu-item hover-effect">
            <i class="el-icon-message-solid right-icon" @click="goto('/vue3')"></i>
          </div>
        </el-tooltip>
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

    <el-popover placement="left" title="" trigger="hover">
      <div slot="reference" class="contact-us">
        <svg-icon class="contact-us-icon cc" icon-class="wechat" />
      </div>
      <div class="ac">
        <img :src="lwConfig.QRCODE_CONTACT_US" class="contact-code" alt="" />
        <div class="nav-li">微信扫码咨询</div>
      </div>
    </el-popover>
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

    goto(url) {
      window.open(url)
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
  font-size: 20px;
}
//
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
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
    // position: absolute;
    // right: 0;
    flex: none;
    background: #fff;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 0 0 min(2vw - 20px, 15px);
      // color: #5a5e66;
      vertical-align: middle;

      &.hover-effect {
        cursor: pointer;
        transition: background 0.3s;

        // &:hover {
        //   background: rgba(0, 0, 0, 0.025);
        // }
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
          margin-left: 8px;
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

// .nav-scrollbar {
//   width: calc(100% - 450px);
//   ::v-deep.el-scrollbar__view {
//     white-space: nowrap;
//     line-height: 58px;
//   }
//   .nav {
//     display: inline-block;
//     margin: 0 20px;
//     flex: none;
//     position: relative;
//     cursor: pointer;
//     &.active::after {
//       content: '';
//       display: inline-block;
//       position: absolute;
//       bottom: 2px;
//       width: 42px;
//       height: 2px;
//       left: 50%;
//       transform: translateX(-50%);
//       border-radius: 6px;
//       background: #fff;
//     }
//   }
// }

.contact-us {
  position: fixed;
  top: 60%;
  width: 100px;
  height: 100px;
  z-index: 9;
  right: 28px;
  width: 50px;
  height: 50px;
  background: linear-gradient(225deg, var(--color-sub) 0%, var(--color) 100%);
  box-shadow: 0px 4px 20px 0px rgba(28, 49, 111, 0.1);
  border-radius: 50%;
  // background: #fff;
  // color: var(--color);
  .contact-us-icon {
    color: #fff;
    // color: inherit;
    font-size: 30px;
  }
  // &:hover {
  //   color: #fff;
  //   background: linear-gradient(225deg, var(--color-sub) 0%, var(--color) 100%);
  //   transition: all 0.3s;
  // }
}
.contact-code {
  width: 118px;
}
</style>
