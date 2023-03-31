import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch((err) => err)
}

/* Layout */
import Layout from '@/layout'
import visitor from '@/layout/visitor'

/**
 * Note: 路由配置项
 *
 * hidden: true                   // 当设置 true 的时候该路由不会再侧边栏出现 如401，login等页面，或者如一些编辑页面/edit/1
 * alwaysShow: true               // 当你一个路由下面的 children 声明的路由大于1个时，自动会变成嵌套的模式--如组件页面
 *                                // 只有一个时，会将那个子路由当做根路由显示在侧边栏--如引导页面
 *                                // 若你想不管路由下面的 children 声明的个数都显示你的根路由
 *                                // 你可以设置 alwaysShow: true，这样它就会忽略之前定义的规则，一直显示根路由
 * redirect: noRedirect           // 当设置 noRedirect 的时候该路由在面包屑导航中不可被点击
 * name:'router-name'             // 设定路由的名字，一定要填写不然使用<keep-alive>时会出现各种问题
 * meta : {
    roles: ['admin','editor']    // 设置该路由进入的权限，支持多个权限叠加
    title: 'title'               // 设置该路由在侧边栏和面包屑中展示的名字
    icon: 'svg-name'             // 设置该路由的图标，对应路径src/icons/svg
    breadcrumb: false            // 如果设置为false，则不会在breadcrumb面包屑中显示
  }
 */

// 固定业务菜单路由
export let fixedRoutes = []

// 开发环境路由，总后台配置完菜单务必删除或注释，只在开发环境生效
if (process.env.VUE_APP_ENV === 'development') {
  fixedRoutes = fixedRoutes.concat()
}

// 公共路由
export const constantRoutes = [
  // {

  //   path: '/drainageCode/customerService',
  //   component: Layout,
  //   hidden: true,
  //   meta: {
  //     title: '客服管理',
  //   },
  //   children: [
  //     {
  //       path: 'add',
  //       name: 'service-add',
  //       component: (resolve) => require(['@/views/customerService/customerServiceManage/add'], resolve),
  //       meta: {
  //         title: '新建客服',
  //         activeMenu: '/drainageCode/customerService/index',
  //         breadcrumb: true,
  //       },
  //     },
  //     {
  //       path: 'detail',
  //       name: 'service-add-detail',
  //       component: (resolve) => require(['@/views/customerService/customerServiceManage/detail'], resolve),
  //       meta: {
  //         title: '客服详情',
  //         activeMenu: '/drainageCode/customerService/index',
  //         breadcrumb: true,
  //       },
  //     },
  //   ],
  // },

  {
    path: '/formsDetail', // 智能表单填写
    component: (resolve) => require(['@/views/drainageCode/smartForms/build/formsDetail'], resolve),
    hidden: true,
    meta: {
      title: '填写表单',
      isNoLogin: true,
    },
  },
  {
    path: '/preview',
    component: (resolve) => require(['@/views/contentCenter/components/preview'], resolve),
    hidden: true,
  },
  // {
  //   path: '',
  //   component: Layout,
  //   hidden: true,
  //   meta: {
  //     title: '客群活码',
  //   },
  //   children: [
  //     {
  //       path: '/drainageCode/qrCode/analyse',
  //       name: 'group-code-analyse',
  //       component: (resolve) => require(['@/views/drainageCode/group/analyse'], resolve),
  //       meta: {
  //         title: '活码统计',
  //         activeMenu: '/drainageCode/qrCode/customerGroup',
  //         breadcrumb: true,
  //       },
  //     },
  //   ],
  // },
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: (resolve) => require(['@/views/redirect'], resolve),
      },
    ],
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile',
        component: (resolve) => require(['@/views/system/user/profile/index'], resolve),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user' },
      },
    ],
  },
  {
    path: '',
    component: visitor,
    hidden: true,
    children: [
      {
        path: '/login',
        component: (resolve) => require(['@/views/login'], resolve),
      },
      {
        path: '/register',
        component: (resolve) => require(['@/views/register'], resolve),
      },
    ],
  },

  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile',
        component: (resolve) => require(['@/views/system/user/profile/index'], resolve),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user' },
      },
    ],
  },
  {
    path: '/authRedirect',
    component: (resolve) => require(['@/views/authRedirect'], resolve),
    hidden: true,
  },
  {
    path: '/404',
    component: (resolve) => require(['@/views/error/404'], resolve),
    hidden: true,
  },
  {
    path: '/401',
    component: (resolve) => require(['@/views/error/401'], resolve),
    hidden: true,
  },
]

export default new VueRouter({
  // mode: process.env.VUE_APP_ENV === 'test' ? 'hash' : 'history', // history 下 element ui 存在bug
  // base: window.lwConfig.BASE_URL,
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes.concat(fixedRoutes),
})
