<template>
  <div class="home">
    <div class="logo ac">linkWeChat</div>
  </div>
</template>

<script>
import { getQueryValue } from '@/utils/index'
import { getWechatUserInfo } from '@/api/common'
export default {
  name: 'authCallback',
  data() {
    return {
      keyword: '',
      active: 0,
      list: [],
      loading: false,
      finished: false,
      show: false,
      // userId: this.$store.state.userId,
    }
  },
  created() {
    alert(1)
    this.getWxCode()
  },
  methods: {
    getWxCode() {
      try {
        let appid = window.lwConfig.appId // 公众号appid
        // let appid = 'wx8bfe6bc2ca5c45ae' // 公众号appid
        alert(2)
        let code = getQueryValue('code') //是否存在code
        alert(3)
        let local = window.location.origin.includes('localhost')
          ? 'http://h5.linkwechat.cn/test.html'
          : window.location.href
        // let local = 'http://h5.x*****o.com/'
        alert(code)
        if (!code) {
          //不存在就打开上面的地址进行授权
          window.location.href = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(
            local
          )}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect`

          // window.location.href =
          //     `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(local)}&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect`;
        } else {
          this.getUserInfo(code)
        }
      } catch (error) {
        alert(error)
        this.$toast(JSON.stringify(error))
      }
    },
    getUserInfo(code) {
      getWechatUserInfo(code).then(({ data }) => {
        if (data && data.openId) {
          localStorage.setItem('userinfo', JSON.stringify(data))
          alert(data.openId)
        }
      })
    },
  },
}
</script>

<style lang="less" scoped>
.logo {
  margin: 0 auto;
  width: 150px;
  height: 50px;
  line-height: 50px;
  border: 2px solid #6582ff;
  border-radius: 50px;
}
.router-link {
  display: block;
  text-align: center;
  line-height: 40px;
}
</style>
