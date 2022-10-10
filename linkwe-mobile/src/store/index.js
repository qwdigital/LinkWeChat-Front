import Vue from 'vue'
import Vuex from 'vuex'
import router from '@/router/index'
import { getUserInfo, login } from '@/api/common'
import { param2Obj, getQueryValue } from '@/utils/index'

Vue.use(Vuex)
let count = 0
export default new Vuex.Store({
  state: {
    userId: sessionStorage.userId,
    reload: true,
  },
  mutations: {
    userId(state, userId) {
      state.userId = userId
    },
    reload(state, reload) {
      state.reload = false
      setTimeout(() => {
        state.reload = true
      }, 0)
    },
  },
  actions: {
    // 企业微信端授权登录
    async login({ commit }) {
      // http://106.13.201.219/?code=xxx&state=linkwechat#/route
      //取缓存中的用户信息
      window.lwConfig.TOKEN && (sessionStorage.token = window.lwConfig.TOKEN)
      if (!sessionStorage.token) {
        // 解决授权重定向返回问题
        let indexRoute = router.getRoutes().find((e) => e.path == '')
        indexRoute && (indexRoute.redirect = window.location.hash.slice(1))
        //缓存中没有用户信息，进入授权流程
        let code = getQueryValue('code') //是否存在code
        let query = param2Obj() //是否存在code
        // let code = query.code
        let appid = window.lwConfig.APPID || query.corpId
        let local = window.location.origin.includes('localhost')
          ? 'http://h5.linkwechat.cn/test.html':'http://demo.linkwechat.cn/mobile/#/index'
          // : window.location.href

        // 第三方授权重定向回来手动刷新页面
        if (code && window.lwConfig.APPID && count === 1) {
          // window.location.reload()
          commit('reload')
          // return Promise.reject()
        }
        if (!code) {
          count++
          //不存在就打开上面的地址进行授权
          let url = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(
            local
          )}&response_type=code&scope=snsapi_privateinfo&state=linkwechat&agentid=1000002#wechat_redirect`
          // 注意：第三方授权重定向回来携带的code是直接拼接在url后面的，企微没有做查询字符串hash检测，eg：url***code=****
          // 由于上述原因router hash模式下，使用第三方授权重定向回来的时候不会刷新页面，解析code是需要注意
          // 使用其他授权模式无上述问题
          setTimeout(() => {
            // window.location.href = url
            window.location.replace(url)
          }, 0)
          return Promise.reject()

          window.location.href = url
          return new Promise(() => {})
          // window.location.href =
          //     `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${encodeURIComponent(local)}&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect`;
        }
        let dataLogin = await login(code)
        // 存入sessionStorage，解决刷新重复code获取用户问题
        dataLogin.data && sessionStorage.setItem('token', dataLogin.data.access_token)
      }
      if (sessionStorage.token && !sessionStorage.userId) {
        let dataUser = {}
        try {
          dataUser = await getUserInfo()
        } catch (error) {
          return Promise.reject()
        }
        try {
          let corpInfo = dataUser.corpInfo
          dataUser.user.weUserId && sessionStorage.setItem('userId', dataUser.user.weUserId) // 当前 登录/使用 企业员工真实姓名大驼峰 eg：QinShiHuang
          commit('userId', sessionStorage.userId)
          corpInfo.appId && sessionStorage.setItem('appId', corpInfo.appId) // 租户微信公众号appid
          corpInfo.tenantId && sessionStorage.setItem('tenantId', corpInfo.tenantId) // 租户id
          //corpInfo.secret && sessionStorage.userId = store.userId = dataUser.user.weUserId
          corpInfo.corpId && sessionStorage.setItem('corpId', corpInfo.corpId) // 服务商企业id
          corpInfo.agentId && sessionStorage.setItem('agentId', corpInfo.agentId) // 代开发应用agentId
          // urlReplaceFirstHistory(window.location.href)
          dataUser.user.companyName &&
            sessionStorage.setItem('companyName', dataUser.user.companyName) // 公司名称
          dataUser.user.avatar && sessionStorage.setItem('avatar', dataUser.user.avatar) // 用户头像
          dataUser.user.userName && sessionStorage.setItem('userName', dataUser.user.userName) // 用户姓名
          dataUser.user.nickName && sessionStorage.setItem('nickName', dataUser.user.nickName) // 用户昵称
          dataUser.user.position && sessionStorage.setItem('position', dataUser.user.position) // 用户部门
        } catch (error) {
          alert(JSON.stringify(error))
          return Promise.reject()
        }
      }
    },
  },
  modules: {},
})
