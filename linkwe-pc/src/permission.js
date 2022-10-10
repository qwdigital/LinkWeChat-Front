import router from './router'
import store from './store'
import { Message } from 'element-ui'
import NProgress from 'nprogress'
// import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'

// NProgress.configure({ showSpinner: false })

const whiteList = ['/login', '/authRedirect', '/bind', '/register', '/test']

router.beforeEach((to, from, next) => {
  // debugger
  // NProgress.start()
  if (getToken()) {
    /* has token*/
    if (to.path === '/login') {
      next({ path: '/' })
      // NProgress.done()
    } else {
      if (store.getters.roles.length === 0) {
        // 判断当前用户是否已拉取完user_info信息
        store.dispatch('GetInfo').then((res) => {
          // 拉取user_info
          const roles = res.roles
          store.dispatch('GenerateRoutes', { roles }).then((accessRoutes) => {
            // 测试 默认静态页面
            // store.dispatch('permission/generateRoutes', { roles }).then(accessRoutes => {
            // 判断是否有设置企业微信id
            if (res.corpInfo && res.corpInfo.corpId) {
              next({ ...to, replace: true })
            } else {
              // 没有设置企业微信的
              let isEnterpriseWechat = router.getRoutes().some((element) => {
                return element.name === window.lwConfig.WORKWEIXINPAGENAME
              })
              // 若有设置企业微信的页面权限，默认跳转到设置企业微信页面
              if (isEnterpriseWechat) {
                Message.warning('初次使用，请配置企业微信的id，以使用其他功能')
                next({
                  name: window.lwConfig.WORKWEIXINPAGENAME,
                  replace: true,
                })
              } else {
                // 没有权限的给予提示，并退回登录页面
                Message.error('没有设置企业微信的权限，请联系系统管理员')
                store.dispatch('FedLogOut').then(() => {
                  next({ path: '/login', replace: true })
                })
              }
            }
          })
        })
        // .catch((err) => {
        //   store.dispatch('LogOut').then(() => {
        //     Message.error(err)
        //     next({ path: '/' })
        //   })
        // })
      } else {
        next()
      }
    }
  } else {
    // 没有token
    if (whiteList.indexOf(to.path) !== -1 || to.meta.isNoLogin) {
      // 在免登录白名单，直接进入
      next()
    } else {
      next(`/login?redirect=${to.fullPath}`) // 否则全部重定向到登录页
      // NProgress.done()
    }
  }
})

router.afterEach(() => {
  // NProgress.done()
})
