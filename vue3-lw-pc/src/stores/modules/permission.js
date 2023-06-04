import { constantRoutes, fixedRoutes } from '@/router/routes'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import { ElMessageBox } from 'element-plus'
import { h } from 'vue'
import { RouterView } from 'vue-router'

const permission = {
  state: {
    routes: [],
    addRoutes: [],
    topbarRouters: [],
    sidebarRouters: [], // 当前显示的侧边栏菜单，通过topbarRouters筛选当前激活的顶部菜单下的子菜单
  },
  actions: {
    // 生成路由
    GenerateRoutes() {
      return new Promise((resolve, reject) => {
        // 向后端请求路由数据
        getRouters()
          .then(({ data }) => {
            if (!data || !data.length) {
              ElMessageBox.confirm('您的角色菜单权限不足，请联系所在企业管理员', '系统提示', {
                confirmButtonText: '重新登录',
                cancelButtonText: '取消',
                type: 'warning',
              }).then(() => {
                this.LogOut().then(() => {
                  location.href = window.lwConfig.BASE_URL
                })
              })
              return reject()
            }
            const rdata = JSON.parse(JSON.stringify(data))
            const rewriteRoutes = filterAsyncRouter(rdata)

            this.permission.addRoutes = rewriteRoutes
            this.permission.routes = constantRoutes.concat(rewriteRoutes)
            this.permission.topbarRouters = rewriteRoutes.concat(fixedRoutes)

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

    delete route.name

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
          route.component = {
            render: () => h(RouterView),
          }
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

// 匹配views里面所有的.vue文件
const modules = import.meta.glob('./../../views/**/*.vue')
export const loadView = (view) => {
  let res
  for (const path in modules) {
    const dir = path.split('views/')[1].split('.vue')[0]
    if (dir === view) {
      res = modules[path]
      break
    }
  }
  return res
}

export default permission
