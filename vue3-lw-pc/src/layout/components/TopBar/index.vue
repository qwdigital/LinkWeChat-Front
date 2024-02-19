<template>
  <div class="navbar main-size">
    <logo />

    <!-- <el-scrollbar class="nav-scrollbar">
      <template v-for="(route, index) in permission_routes" :key="index">
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
    <TopMenu />
    <div class="right-menu mr10">
      <!-- <search id="header-search" class="right-menu-item" /> -->
      <!-- <el-popover placement="right" width="300" trigger="hover">
           <div class="hover-class">
             <span>扫码联系专属客服</span>
             <img :src="customerServiceQr" alt="" />
             <span>立马扫码一对一答疑</span>
           </div>
           <div class="right-menu-item hover-effect" slot="reference" style="font-size:24px">
             <svg-icon class="right-icon" icon="customer-service"></svg-icon>
           </div>
       </el-popover> -->

      <!-- <el-tooltip content="企业微信-管理后台" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <svg-icon
              class="right-icon"
              icon="qiyeweixin"
              style="color: #0082f0"
              @click="goto('https://work.weixin.qq.com/wework_admin/loginpage_wx?from=myhome_baidu')"></svg-icon>
          </div>
        </el-tooltip>
        <el-tooltip content="源码地址" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <svg-icon class="right-icon" icon="gitee" @click="goto('https://gitee.com/LinkWeChat/link-wechat')" />
          </div>
        </el-tooltip>

        <el-tooltip content="LinkWeChat官网" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <el-icon-link class="el-icon-link right-icon" @click="goto('https://www.linkwechat.net/')" />
          </div>
        </el-tooltip>

        <el-tooltip content="文档手册" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <el-icon-reading class="el-icon-reading document right-icon" @click="goto('https://www.yuque.com/linkwechat/help')"></el-icon-reading>
          </div>
        </el-tooltip>

        <el-tooltip content="功能清单" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <el-icon-tickets class="el-icon-tickets right-icon"
              @click="goto('https://docs.qq.com/sheet/DZW9HSHpHdWlOYWh2?tab=BB08J3')"/>
          </div>
        </el-tooltip>

        <el-tooltip content="需求墙" effect="dark" placement="bottom">
          <div class="right-menu-item hover-effect">
            <el-icon-data-board class="el-icon-data-board right-icon"
              @click="goto('https://docs.qq.com/sheet/DZWxGU0JGVFRVdWZV?tab=BB08J2')"/>
          </div>
        </el-tooltip> -->

      <!-- <screenfull id="screenfull" class="right-menu-item hover-effect" /> -->

      <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="click">
        <div class="avatar-wrapper">
          <img :src="avatar" class="user-avatar" />
          <div :title="name" class="user-name toe">{{ name }}</div>
          <el-icon-arrow-down class="el-icon-arrow-down" />
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <router-link to="/user/profile">
              <el-dropdown-item>个人中心</el-dropdown-item>
            </router-link>
            <el-dropdown-item divided @click="setting = true">
              <span>主题设置</span>
            </el-dropdown-item>
            <el-dropdown-item @click="logout">
              <span>退出登录</span>
            </el-dropdown-item>
            <el-dropdown-item @click="$store.app.isDark = !$store.app.isDark">
              <template v-if="$store.app.isDark">
                <el-icon-Moon class="el-icon-Moon right-icon mr5" />
                深色
              </template>
              <template v-else>
                <el-icon-Sunny class="el-icon-Sunny right-icon mr5" />
                浅色
              </template>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>

    <el-drawer v-model="setting" title="主题设置" size="300px" :modal="false" append-to-body z-index="999">
      <settings v-if="setting" />
    </el-drawer>

    <el-popover v-if="lwConfig.IS_LINKWECHAT" placement="left" title="" trigger="hover">
      <template #reference>
        <div class="contact-us">
          <svg-icon class="contact-us-icon cc" icon="wechat" />
        </div>
      </template>
      <div class="ac">
        <img :src="lwConfig.QRCODE_CONTACT_US" class="contact-code" alt="" />
        <div class="nav-li">微信扫码咨询</div>
      </div>
    </el-popover>
  </div>
</template>

<script>
import Settings from './Settings'
import { isExternal } from '@/utils/validate'
import { mapState } from 'pinia'
import stores from '@/stores'
import Logo from './Logo'
// import { getCustomerServiceQrUrl } from "@/api/login";

// import Search from '@/components/HeaderSearch'
// import screenfull from '@/components/Screenfull'
import TopMenu from './TopMenu'

export default {
  data() {
    return {
      customerServiceQr: '',
      setting: false,
    }
  },
  components: {
    Logo,
    // Search,
    // screenfull,
    TopMenu,
    Settings,
  },
  computed: {
    ...mapState(stores, ['avatar', 'name', 'permission_routes']),
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
        this.$store.LogOut()
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
  color: var(--font-black);

  .errLog-container {
    display: inline-block;
    vertical-align: top;
  }

  .right-menu {
    // position: absolute;
    // right: 0;
    flex: none;
    background: var(--bg-white);

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 0 0 min(2vw - 20px, 15px);
      // color: var(--font-black-4);
      vertical-align: middle;

      &.hover-effect {
        cursor: pointer;
        transition: background 0.3s;

        // &:hover {
        //   background: var(--bg-black-11);
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
          color: var(--font-black);
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
//       background: var(--bg-white);
//     }
//   }
// }

.contact-us {
  position: fixed;
  top: 60%;
  width: 100px;
  height: 100px;
  z-index: 99;
  right: 28px;
  width: 50px;
  height: 50px;
  background: linear-gradient(225deg, var(--color-sub) 0%, var(--color) 100%);
  box-shadow: 0px 4px 20px 0px rgba(28, 49, 111, 0.1);
  border-radius: 50%;
  // background: var(--bg-white);
  // color: var(--color);
  .contact-us-icon {
    color: var(--font-white, #fff);
    // color: inherit;
    font-size: 30px;
  }
  // &:hover {
  //   color: var(--font-white, #fff);
  //   background: linear-gradient(225deg, var(--color-sub) 0%, var(--color) 100%);
  //   transition: all 0.3s;
  // }
}
.contact-code {
  width: 118px;
}
</style>
