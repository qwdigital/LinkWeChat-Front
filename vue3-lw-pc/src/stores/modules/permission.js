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
                this.LogOut()
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

    // 默认返回的name为大驼峰式的组件名
    // 删除name，避免vue router自动删除重名的路由
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
        route.component = loadView(route)
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
export const loadView = (route) => {
  let res
  for (const path in modules) {
    const dir = path.split('views/')[1].split('.vue')[0]
    if (dir === route.component) {
      res = modules[path]

      // 为需要单独使用的路由命名，避免使用绝对路径跳转
      let routeNames = {
        // 组件路径: route name
        'customerManage/customerDetail': window.lwConfig.CUSTOMER_DETAIL_ROUTE_NAME, //  客户详情
        'customerManage/groupDetail': window.lwConfig.GROUP_DETAIL_ROUTE_NAME, //  客群详情
        'enterpriseWechat/list': window.lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME, //企微配置
        'drainageCode/staff/list': 'staffCode', //  员工活码
        'drainageCode/group/list': 'customerGroupCode', // 群活码
        'drainageCode/store/list': 'storeCode', //门店活码
        'drainageCode/identity/list': 'identityCode', //识客码
        'drainageCode/pullNews/list': 'pullNewsCode', //拉新活码
        'contentCenter/templateWel/index': 'templateWel', //欢迎语模板列表
        'contentCenter/templateWel/index': 'templateWelAdd', //欢迎语模板新增
      }
      routeNames[route.component] && (route.name = routeNames[route.component])

      break
    }
  }
  return res
}

export default permission
