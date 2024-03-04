/* Layout */
import { RouterView } from 'vue-router'
import { h } from 'vue'
import Layout from '@/layout/index.vue'
import visitor from '@/layout/visitor.vue'
const routerView = {
  render: () => h(RouterView),
}
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

// 固定菜单路由
export let fixedRoutes = [
  // {
  //   path: '/test',
  //   component: Layout,
  //   hidden: true,
  //   redirect: '/test/aa',
  //   children: [
  //     {
  //       path: 'aa',
  //       component: {
  //         render: (h) => h('div', 'uuftf'),
  //       },
  //       isNoLogin: true,
  //     },
  //     {
  //       path: 'a',
  //       component: visitor,
  //       redirect: '/test/a/a',
  //       isNoLogin: true,
  //       children: [
  //         {
  //           path: 'a',
  //           component: {
  //             render: (h) => h('div', 'uuftf'),
  //           },
  //           isNoLogin: true,
  //         },
  //       ],
  //     },
  //   ],
  // },
]

// 开发环境路由，总后台配置完菜单务必删除或注释，只在开发环境生效
if (process.env.NODE_ENV === 'development' || window.lwConfig.ENV === 'development') {
  let devRoutes = [
    {
      path: '/dev',
      component: Layout,
      redirect: '/dev/saleInsight',
      meta: {
        title: '开发菜单',
      },
      children: [
        // {
        //   path: '/dev/saleInsight',
        //   component: routerView,
        //   redirect: '/dev/saleInsight/clueAnalysis',
        //   meta: {
        //     title: '销售洞察',
        //   },
        //   children: [
        //     {
        //       path: 'clueAnalysis',
        //       component: () => import('@/views/clue/clueAnalysis/index'),
        //       meta: {
        //         title: '线索分析',
        //       },
        //     },
        //   ],
        // },
        // {
        //   path: '/dev/privateIncubation',
        //   component: routerView,
        //   meta: {
        //     title: '私域孵化',
        //   },
        //   children: [
        //     {
        //       path: 'clueHighseas',
        //       component: routerView,
        //       redirect: '/dev/privateIncubation/clueHighseas/index',
        //       meta: {
        //         title: '线索公海',
        //       },
        //       children: [
        //         {
        //           path: 'index',
        //           hidden: true,
        //           component: () => import('@/views/clue/clueHighseas/index'),
        //           meta: {
        //             title: '',
        //           },
        //         },
        //         {
        //           path: 'addEdit',
        //           hidden: true,
        //           component: () => import('@/views/clue/clueHighseas/addEdit'),
        //           meta: {
        //             title: '新建公海',
        //           },
        //         },
        //         {
        //           path: 'highseasStatistics',
        //           hidden: true,
        //           component: () => import('@/views/clue/clueHighseas/highseasStatistics'),
        //           meta: {
        //             title: '公海统计',
        //           },
        //         },
        //         {
        //           path: 'clueDetail',
        //           hidden: true,
        //           component: () => import('@/views/clue/clueHighseas/clueDetail'),
        //           meta: {
        //             title: '客户详情',
        //           },
        //         },
        //       ],
        //     },
        //     {
        //       path: 'clueTemplate',
        //       component: () => import('@/views/clue/clueTemplate/index'),
        //       meta: {
        //         title: '线索模板',
        //       },
        //     },
        //   ],
        // },
      ],
    },
  ]
  fixedRoutes = fixedRoutes.concat(devRoutes)
}

// 公共路由
export const constantRoutes = [
  {
    path: '/formsDetail', // 智能表单填写
    component: () => import('@/views/drainageCode/smartForms/build/formsDetail'),
    hidden: true,
    meta: {
      title: '填写表单',
      isNoLogin: true,
    },
  },
  {
    path: '/preview',
    component: () => import('@/views/contentCenter/components/preview'),
    hidden: true,
  },
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect'),
      },
    ],
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'profile',
        component: () => import('@/views/system/user/profile/index'),
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
        component: () => import('@/views/login'),
      },
      {
        path: '/register',
        component: () => import('@/views/register'),
      },
    ],
  },
  {
    path: '/authRedirect',
    component: () => import('@/views/authRedirect'),
    hidden: true,
  },
  {
    path: '/404',
    component: () => import('@/views/error/404'),
    hidden: true,
  },
  {
    path: '/401',
    component: () => import('@/views/error/401'),
    hidden: true,
  },
]
