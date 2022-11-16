import router, { constantRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import View from '@/layout/components/View'
import { Notification, MessageBox, Message } from 'element-ui'

const permission = {
  state: {
    routes: [],
    addRoutes: [],
    defaultRoutes: [],
    topbarRouters: [],
    sidebarRouters: [],
  },
  mutations: {
    SET_ROUTES: (state, routes) => {
      state.addRoutes = routes
      state.routes = constantRoutes.concat(routes)
      // 根据roles权限生成可访问的路由表
      routes.forEach((e) => router.addRoute(e))
    },
    SET_DEFAULT_ROUTES: (state, routes) => {
      state.defaultRoutes = constantRoutes.concat(routes)
    },
    SET_TOPBAR_ROUTES: (state, routes) => {
      // 顶部导航菜单默认添加统计报表栏指向首页
      // const index = [{
      //   path: 'index',
      //   meta: { title: '统计报表', icon: 'dashboard' }
      // }]
      // state.topbarRouters = routes.concat(index);
      state.topbarRouters = routes
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
            // const accessedRoutes = filterAsyncRouter(data)
            // // 设置为匹配路由重定向404
            // accessedRoutes.push({ path: '*', redirect: '/404', hidden: true })
            // commit('SET_ROUTES', accessedRoutes)
            // resolve(accessedRoutes)
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
            const sdata = JSON.parse(JSON.stringify(data))
            const rdata = JSON.parse(JSON.stringify(data))
            const sidebarRoutes = filterAsyncRouter(sdata)
            const rewriteRoutes = filterAsyncRouter(rdata, false, true)

            // // 设置首页重定向
            let indexRoute = router.getRoutes().find((e) => e.path == '')
            indexRoute.redirect = rewriteRoutes[0].path

            rewriteRoutes.push({ path: '*', redirect: '/404', hidden: true })
            commit('SET_ROUTES', rewriteRoutes)
            commit('SET_SIDEBAR_ROUTERS', constantRoutes.concat(sidebarRoutes))
            commit('SET_DEFAULT_ROUTES', sidebarRoutes)
            commit('SET_TOPBAR_ROUTES', sidebarRoutes)
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

function filterChildren(childrenMap, lastRouter = false) {
  var children = []
  childrenMap.forEach((el, index) => {
    if (el.children && el.children.length) {
      if (el.component === 'ParentView' && !lastRouter) {
        el.children.forEach((c) => {
          c.path = el.path + '/' + c.path
          if (c.children && c.children.length) {
            children = children.concat(filterChildren(c.children, c))
            return
          }
          children.push(c)
        })
        return
      }
    }
    if (lastRouter) {
      el.path = lastRouter.path + '/' + el.path
    }
    children = children.concat(el)
  })
  return children
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
function filterAsyncRouter(asyncRouterMap) {
  level++
  let res = asyncRouterMap.filter((route) => {
    route.meta = route.meta || {}
    route.meta.hidden = route.hidden
    if (route.component) {
      // Layout组件特殊处理
      if (route.component === 'Layout') {
        if (route.redirect === 'noRedirect' && route.children.length) {
          let firstChildPath = route.children[0].path
          route.redirect = firstChildPath.startsWith('/')
            ? firstChildPath
            : route.path + '/' + firstChildPath
        }
        if (level != 1) {
          route.component = View
        } else {
          route.component = Layout
        }
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children)
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
