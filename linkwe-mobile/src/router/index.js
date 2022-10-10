import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import { getAgentTicket } from '@/api/common'
import store from '@/store'
import { Toast } from 'vant'

Vue.use(VueRouter)
let noAuth = process.env.NODE_ENV === 'development'
const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: {
      title: '首页',
      noAuth: true,
    },
  },
  // 聊天素材
  {
    path: '/chat',
    name: 'chat',
    component: () => import('../views/chat'),
    meta: {
      title: '聊天素材',
    },
  },
  // 用户画像
  {
    path: '/portrait',
    name: 'portrait',
    component: () => import('../views/portrait/index'),
    meta: {
      title: '客户画像',
      noAuth,
    },
  },
  // 用户画像-社群关系
  {
    path: '/community',
    name: 'community',
    component: () => import('../views/portrait/community.vue'),
    hidden: true,
    meta: {
      title: '社群关系',
      noAuth,
    },
  },
  // 客群画像
  {
    path: '/portraitGroup',
    name: 'portraitGroup',
    component: () => import('../views/portraitGroup/index.vue'),
    hidden: true,
    meta: {
      title: '客群画像',
      noAuth,
    },
  },
  {
    path: '/groupMembers',
    name: 'groupMembers',
    component: () => import('../views/portraitGroup/members.vue'),
    hidden: true,
    meta: {
      title: '群成员',
      noAuth,
    },
  },
  // 群活码扫描跳转页面
  {
    path: '/groupCode',
    name: 'groupCode',
    component: () => import('../views/groupCode/index'),
    hidden: true,
    meta: {
      title: '',
      noAuth: true,
    },
  },
  // 标签建群+群sop
  {
    path: '/task',
    hidden: true,
    meta: {
      title: '消息群发',
      noAuth: true,
    },
    component: () => import('../views/communityOperating/task/index'),
    children: [
      {
        path: '',
        component: () => import('../views/communityOperating/task/list'),
        hidden: true,
        meta: {
          title: '消息群发',
          // noAuth: true
        },
      },
      {
        path: 'state',
        name: 'taskState',
        component: () => import('../views/communityOperating/task/state.vue'),
        hidden: true,
        meta: {
          title: '消息群发',
          noAuth: true,
        },
      },
    ],
  },
  // 关键词群
  {
    path: '/keywords',
    name: 'keywords',
    component: () => import('../views/communityOperating/keywords/index'),
    hidden: true,
    meta: {
      title: '关键词群',
    },
  },
  // 客户公海
  {
    path: '/highSeas',
    name: 'highSeas',
    component: () => import('../views/highSeas/index'),
    meta: {
      title: '公海分配',
    },
  },
  // 红包
  {
    path: '/redPacket',
    name: 'redPacket',
    component: () => import('../views/redPacket/index'),
    meta: {
      title: '红包',
    },
  },
  // 领取红包
  {
    path: '/redPacketReceive',
    name: 'redPacketReceive',
    component: () => import('../views/redPacket/receive'),
    meta: {
      title: '领取红包',
      noAuth: true,
    },
  },
  // 任务宝、群裂变
  {
    path: '/taskTreasure',
    name: 'taskTreasure',
    component: () => import('../views/task/index'),
    meta: {
      title: '裂变任务',
      noAuth: true,
    },
  },
  // 任务宝、群裂变 任务进度查询
  {
    path: '/taskProcess',
    name: 'taskProcess',
    component: () => import('../views/task/process'),
    meta: {
      title: '任务进度',
      noAuth: true,
    },
  },
  // 群裂变 扫码结果页面
  {
    path: '/fission',
    name: 'fission',
    component: () => import('../views/fission/index'),
    meta: {
      title: '群裂变',
      noAuth: true,
    },
  },
  // 门店活码
  {
    path: '/guideCode',
    name: 'guideCode',
    component: () => import('../views/storeCode/index'),
    hidden: true,
    meta: {
      title: '门店导购码',
      noAuth: true,
    },
  },
  {
    path: '/storeCode',
    name: 'storeCode',
    component: () => import('../views/storeCode/code'),
    hidden: true,
    meta: {
      title: '门店群活码',
      noAuth: true,
    },
  },

  // 解决授权重定向返回问题
  { path: '*', redirect: '/', hidden: true },
]

const router = new VueRouter({
  // mode: 'history', window.lwConfig
  base: window.lwConfig.BASE_URL,
  routes,
})

let init = true
router.beforeEach(async (to, from, next) => {
  Toast.clear()
  /* 路由发生变化修改页面title */
  if (to.meta.title) {
    document.title = to.meta.title
  }
  // 通过config接口注入权限验证配置
  // 所有需要使用JS-SDK的页面必须先注入配置信息，否则将无法调用（同一个url仅需调用一次，对于变化url的SPA（single-page application）的web app可在每次url变化时进行调用）
  const noAuth = to.meta ? to.meta.noAuth : false
  try {
    if (init && !noAuth) {
      Toast.loading()
      await store.dispatch('login')
      window.lwConfig.TOKEN || (await wxConfig())
      init = false
      Toast.clear()
    }
    next()
  } catch (error) {
    error && alert(JSON.stringify(error))
    next(false)
  }
})

async function wxConfig() {
  try {
    let { data } = await getAgentTicket(window.location.href.split('#')[0])
    let { timestamp, nonceStr, signature } = data
    return new Promise((resolve, reject) => {
      wx.agentConfig({
        beta: true, // 必须这么写，否则wx.invoke调用形式的jsapi会有问题
        debug: true,
        corpid: sessionStorage.corpId, // 必填，企业微信的corpid，必须与当前登录的企业一致
        agentid: sessionStorage.agentId, // 必填，企业微信的应用id （e.g. 1000247）
        timestamp, // 必填，生成签名的时间戳
        nonceStr, // 必填，生成签名的随机串
        signature, // 必填，签名，见附录-JS-SDK使用权限签名算法
        jsApiList: [
          'sendChatMessage',
          'getContext',
          'getCurExternalContact',
          'getCurExternalChat',
          'openEnterpriseChat',
          'shareToExternalContact',
          'shareToExternalChat',
          'navigateToAddCustomer',
          'openEnterpriseChat',
          'openExistedChatWithMsg',
        ], //必填
        success: (res) => {
          // 回调
          // toast('agentId成功:')
          resolve()
        },
        fail: (res) => {
          alert('agent config失败:' + JSON.stringify(res))
          if (res.errMsg.indexOf('function not exist') > -1) {
            alert('版本过低请升级')
          }
          reject()
        },
      })
    })
  } catch (error) {
    error && alert(JSON.stringify(error))
    return Promise.reject()
  }
}

export default router
