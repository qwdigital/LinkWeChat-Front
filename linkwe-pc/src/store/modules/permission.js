import router, { constantRoutes, fixedRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import View from '@/layout/components/View'
import { Notification, MessageBox, Message } from 'element-ui'

const permission = {
  state: {
    routes: [],
    addRoutes: [],
    topbarRouters: [],
    sidebarRouters: [], // 当前显示的侧边栏菜单，通过topbarRouters筛选当前激活的顶部菜单下的子菜单
  },
  mutations: {
    SET_ROUTES: (state, routes) => {
      state.addRoutes = routes
      state.routes = constantRoutes.concat(routes)
      // 根据roles权限生成可访问的路由表
      routes.forEach((e) => router.addRoute(e))
    },
    SET_TOPBAR_ROUTES: (state, routes) => {
      state.topbarRouters = routes.concat(fixedRoutes)
    },
    SET_SIDEBAR_ROUTERS: (state, routes) => {
      state.sidebarRouters = routes
    },
  },
  actions: {
    // 生成路由
    GenerateRoutes({ commit, dispatch }) {
      return new Promise((resolve, reject) => {
        // 向后端请求路由数据
        getRouters()
          .then(({ data }) => {
            if (!data || !data.length) {
              MessageBox.confirm('您的角色菜单权限不足，请联系所在企业管理员', '系统提示', {
                confirmButtonText: '重新登录',
                cancelButtonText: '取消',
                type: 'warning',
              }).then(() => {
                dispatch('LogOut', null, { root: true }).then(() => {
                  location.href = window.lwConfig.BASE_URL
                })
              })
              return reject()
            }
            const rdata = JSON.parse(JSON.stringify(data))
            const rewriteRoutes = filterAsyncRouter(rdata)

            // // 设置首页重定向
            let indexRoute = router.getRoutes().find((e) => e.path == '')
            indexRoute.redirect = rewriteRoutes[0].path

            rewriteRoutes.push({ path: '*', redirect: '/404', hidden: true })
            commit('SET_ROUTES', rewriteRoutes)
            commit('SET_TOPBAR_ROUTES', rewriteRoutes)
            resolve(rewriteRoutes)
          })
          .catch((error) => {
            console.log(error)
            reject()
          })
      })
    },
  },
}

// export const loadView = (view) => {
//   if (process.env.NODE_ENV === 'development') {
//     return (resolve) => require([`@/views/${view}`], resolve)
//   } else {
//     // 使用 import 实现生产环境的路由懒加载
//     return (resolve) => require([`@/views/${view}`], resolve)
//   }
// }

// // 遍历后台传来的路由字符串，转换为组件对象
let level = 0
function filterAsyncRouter(asyncRouterMap, parentPath) {
  level++
  let res = asyncRouterMap.filter((route) => {
    route.meta = route.meta || {}
    route.meta.hidden = route.hidden

    if (parentPath) {
      let path = route.path
      route.path = /^(\/|http)/.test(path) ? path : parentPath + '/' + path
    }

    if (route.component) {
      // Layout组件特殊处理
      if (route.redirect === 'noRedirect' && route.children.length) {
        let firstChildPath = route.children[0].path
        route.redirect = firstChildPath.startsWith('/') ? firstChildPath : route.path + '/' + firstChildPath
      }
      if (route.component === 'Layout') {
        if (level != 1) {
          route.component = View
        } else {
          route.component = Layout
        }
      } else {
        route.component = loadView(route.component)
      }
    }
    let children = route.children
    if (children && children.length) {
      route.children = filterAsyncRouter(route.children, route.path)
    }
    return true
  })
  level--
  return res
}

export const loadView = (view) => {
  // 路由懒加载
  return (resolve) => require([`@/views/${view}`], resolve)
}

export default permission
