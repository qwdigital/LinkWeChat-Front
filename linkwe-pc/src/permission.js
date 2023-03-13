import router from './router'
import store from './store'
import { Message } from 'element-ui'
// import NProgress from 'nprogress'
// import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'

// NProgress.configure({ showSpinner: false })

const whiteList = ['/authRedirect', '/bind', '/test'] // 不管有没有token都可直接进入的页面路径
const noLoginList = ['/login', '/register'] // 没有token才能进入的页面

function nextTo(to, next, isRpelace) {
  if (isRpelace) {
    next({ ...to, replace: true })
  } else if (
    to.matched.length === 0 &&
    !Object.values(window.lwConfig.MICRO_APPS).some((item) => to.path.startsWith(item.activeRule.match('/.*')[0]))
  ) {
    // 未匹配到路由，且路径不是以微应用路由开头的，跳转至404
    next('/404')
  } else {
    next()
  }
}
router.beforeEach((to, from, next) => {
  // NProgress.start()
  // 无需检测token的， 不管有没有token都可直接进入
  if (whiteList.includes(to.path) || to.meta.isNoLogin) {
    next()
  } else if (getToken()) {
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
              nextTo(to, next, true)
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
        nextTo(to, next)
      }
    }
  } else if (noLoginList.includes(to.path)) {
    // 没有token才能进入的页面
    next()
  } else {
    next(`/login?redirect=${to.fullPath}`) // 否则全部重定向到登录页
    // NProgress.done()
  }
})

router.afterEach(() => {
  // NProgress.done()
})
