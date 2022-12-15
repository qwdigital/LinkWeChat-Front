import Vue from 'vue'
import Vuex from 'vuex'
import router from '@/router/index'
import { getUserInfo, login, getWcRedirect } from '@/api/common'
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
      //取缓存中的用户信息
      window.lwConfig.TOKEN && (sessionStorage.token = window.lwConfig.TOKEN)
      if (!sessionStorage.token) {
        // 解决授权重定向返回问题
        let indexRoute = router.getRoutes().find((e) => e.path == '')
        indexRoute && (indexRoute.redirect = window.location.hash.slice(1))
        //缓存中没有用户信息，进入授权流程
        let code = getQueryValue('code') //是否存在code
        // 第三方授权重定向回来手动刷新页面
        if (code && count === 1) {
          commit('reload')
        }
        if (!code) {
          count++
          let url = (await getWcRedirect()).data
          window.location.replace(url)
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
          corpInfo.appId && sessionStorage.setItem('appId', corpInfo.appId) // 微信公众号appid
          sessionStorage.setItem('corpId', corpInfo.corpId) // 企业id
          sessionStorage.setItem('agentId', corpInfo.agentId) // 自建应用agentId
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
