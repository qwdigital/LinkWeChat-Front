import router, { constantRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import View from '@/layout/components/View'

const permission = {
  state: {
    routes: [],
    addRoutes: []
  },
  mutations: {
    SET_ROUTES: (state, routes) => {
      state.addRoutes = routes
      state.routes = constantRoutes.concat(routes)
      // 根据roles权限生成可访问的路由表
      router.addRoutes(routes)
    }
  },
  actions: {
    // 生成路由
    GenerateRoutes({ commit }) {
      return new Promise((resolve) => {
        // 向后端请求路由数据
        getRouters().then((res) => {
          const accessedRoutes = filterAsyncRouter(res.data)
          // 设置首页重定向
          accessedRoutes.unshift({ path: '/index', redirect: accessedRoutes[0].path, hidden: true })
          // 设置为匹配路由重定向404
          accessedRoutes.push({ path: '*', redirect: '/404', hidden: true })
          commit('SET_ROUTES', accessedRoutes)
          resolve(accessedRoutes)
        })
      })
    }
  }
}

// 遍历后台传来的路由字符串，转换为组件对象
let level = 0
function filterAsyncRouter(asyncRouterMap) {
  level++
  let res = asyncRouterMap.filter((route) => {
    if (route.component) {
      // Layout组件特殊处理
      if (route.component === 'Layout') {
        if (route.redirect === 'noRedirect' && route.children.length) {
          route.redirect = route.path + '/' + route.children[0].path
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
