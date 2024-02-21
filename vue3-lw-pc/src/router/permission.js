import stores from '@/stores'
import { ElMessage as Message } from 'element-plus'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'

NProgress.configure({ showSpinner: true })

const whiteList = ['/bind', '/test', '/404', '/401'] // 不管有没有token都可直接进入的页面路径
const noLoginList = ['/authRedirect', '/login', '/register'] // 没有token才能进入的页面

function nextTo(to, next, isRpelace) {
  if (/^\/microStore[^#]+$/.test(to.fullPath)) {
    // location.href = window.lwConfig.BASE_URL.slice(window.lwConfig.BASE_URL.indexOf('/'), -1) + to.path + '#' + to.path
    // to.path = to.path + '#' + to.path
    next({ ...to, hash: '#' + to.path })
  }
  if (isRpelace) {
    next({ ...to, replace: true })
  } else {
    next()
  }
}
export default function permission(router) {
  router.beforeEach((to, from, next) => {
    let store = stores()
    NProgress.start()
    // 无需检测token的， 不管有没有token都可直接进入
    if (whiteList.includes(to.path) || to.meta.isNoLogin) {
      next()
    } else if (getToken()) {
      /* has token*/
      if (noLoginList.includes(to.path)) {
        next({ path: window.lwConfig.BASE_URL })
        // NProgress.done()
      } else {
        if (store.roles.length === 0) {
          // 判断当前用户是否已拉取完user_info信息
          store.GetInfo().then((res) => {
            // 拉取user_info
            const roles = res.roles
            store.GenerateRoutes({ roles }).then((accessRoutes) => {
              // // 设置首页重定向
              let indexRoute = router.getRoutes().find((e) => e.path == '')
              indexRoute.redirect = accessRoutes[0].path
              accessRoutes.push({ path: '/:path(.*)*', redirect: '/404', hidden: true })
              // 根据roles权限生成可访问的路由表
              accessRoutes.forEach((e) => router.addRoute(e))

              // 测试 默认静态页面
              // 判断是否有设置企业微信id
              if (res.corpInfo && res.corpInfo.corpId) {
                nextTo(to, next, true)
              } else {
                // 没有设置企业微信的
                let isEnterpriseWechat = router.getRoutes().some((element) => {
                  return element.name === window.lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME
                })
                // 若有设置企业微信的页面权限，默认跳转到设置企业微信页面
                if (isEnterpriseWechat) {
                  Message.warning('初次使用，请配置企业微信的id，以使用其他功能')
                  next({
                    name: window.lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME,
                    replace: true,
                  })
                } else {
                  // 没有权限的给予提示，并退回登录页面
                  Message.error('没有设置企业微信的权限，请联系系统管理员')
                  store.LogOut()
                }
              }
            })

            store.getServerState()
          })
          // .catch((err) => {
          //   store.LogOut().then(() => {
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
      next(`/login?redirect=${encodeURIComponent(to.fullPath)}`) // 否则全部重定向到登录页
      // NProgress.done()
    }
  })

  router.afterEach(() => {
    NProgress.done()
    document.getElementById('loader-wrapper').className = 'loaded'
  })
}
