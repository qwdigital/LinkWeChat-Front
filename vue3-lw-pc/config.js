import { getToken } from '@/utils/auth'
import { env } from './env'

// 系统内常量默认配置，只能从外部配置，内部不可修改
const common = {
  SYSTEM_NAME: 'LinkWeChat', // 系统简称
  SYSTEM_NAME_MOBILE: 'LinkWeChat', // 移动端应用简称
  SYSTEM_NAME_ALL: 'LinkWeChat -- 全链路私域数字化营销增长解决方案', // 系统全称，浏览器标题
  COMPANY_NAME: 'LinkWeChat', // 公司简称
  COMPANY_NAME_ALL: 'LinkWeChat', // 公司全称
  COPYRIGHT:
    'Copyright © 2018-2023 LinkWeChat All Rights Reserved. 备案号：<a href="https://beian.miit.gov.cn/">皖ICP备022014134号-1</a>', // 版权信息
  LOGO_DARK: env.BASE_URL + 'static/LOGO_DARK.png', // 深色logo
  LOGO_LIGHT: env.BASE_URL + 'static/LOGO_LIGHT.png', // 淡色logo
  LOGO_TEXT_DARK: env.BASE_URL + 'static/LOGO_TEXT_DARK.png', // 深色logo+文字
  LOGO_TEXT_LIGHT: env.BASE_URL + 'static/LOGO_TEXT_LIGHT.png', // 淡色logo+文字
  QRCODE_CONTACT_US: env.BASE_URL + 'static/QRCODE_CONTACT_US.png', // 联系我们二维码
  QRCODE_CUSTOMER_SERVICE: env.BASE_URL + 'static/QRCODE_CUSTOMER_SERVICE.png', // 客服二维码
  POST_QRCODE: env.BASE_URL + 'static/POST_QRCODE.png', // 海报占位二维码
  AGREEMENT: env.BASE_URL + 'static/AGREEMENT.pdf', // 用户协议pdf
  PRIVACY: env.BASE_URL + 'static/PRIVACY.pdf', // 隐私协议pdf
  COOKIEEXPIRES: 0.5, // token在Cookie中存储的天数，默认0.5天
  WORK_WEIXIN_CONFIG_ROUTE_NAME: Symbol(), // 企业微信设置页面路由名称, 用于router 通过name判断与跳转，避免使用path不易于扩展
  CUSTOMER_DETAIL_ROUTE_NAME: Symbol(), // 客户详情页面路由name，同上
  GROUP_DETAIL_ROUTE_NAME: Symbol(), // 客群详情
  DEFAULT_H5_PIC: env.BASE_URL + 'static/PIC.png',
  DEFAULT_H5_ART: env.BASE_URL + 'static/ARTICAL.png', // 文章默认封面
  DEFAULT_H5_TP: env.BASE_URL + 'static/TEXT_PIC.png', // 图文默认封面
  DEFAULT_H5_PDF: env.BASE_URL + 'static/PDF.png', // pdf默认封面
  DEFAULT_H5_WORDE: env.BASE_URL + 'static/WORD.png',
  DEFAULT_H5_PPT: env.BASE_URL + 'static/PPT.png',
  PRIVIEW_PATH: window.location.origin + '/mobile/#/metrialDetail?materiaId=',
  BAIDU_MAP_KEY: '6fZIymhpgfnAHUT1baHeEF922lPIThOG', // 百度地图key
  IS_PUBLISH_DIALOG: false, // 是否显示发布弹窗
  IS_LINKWECHAT: env.DOMAIN.includes('linkwechat.net'), // 是否显示linkwechat开源相关业务组件

  MICRO_APPS: {
    store: {
      name: 'microStore',
      entry: window.location.origin + '/microStore/',
      container: '#micro-app',
      // activeRule: (location) => location.hash.startsWith('#/microStore'),
      activeRule: env.BASE_URL.slice(env.BASE_URL.indexOf('/')) + 'microStore', // eg:/vue/microStore
    },
  },
}

// 以下仅用于系统信息展示，不作为项目变量使用，请勿在代码中使用
const project = {
  _version: 'v5.x', // 当前版本信息
  _packDateTime: __PACK_DATETIME__, // 打包时间
  _packEnv: process.env.VUE_APP_ENV, // 前端打包模式
  _packUser: __PACK_USER__, // 打包人员
}

let config = {
  // 是否系统布局配置
  showSettings: false,

  // 是否显示 tagsView
  tagsView: true,

  // 是否固定头部
  fixedHeader: false,

  // 是否显示logo
  sidebarLogo: true,

  services: {
    wecom: '/open',
    ai: '/ai',
    // system: 'http://192.168.4.168:6180',
    common: '/common',
    weChat: '/wx-api',
  },

  get headers() {
    return { Authorization: 'Bearer ' + getToken() }
  },
}

const lwConfig = window.lwConfig || {} // 线上动态配置，用于覆盖系统默认常量的配置信息

// config 含有getter必须放在merge第一位
window.lwConfig = Object.assign(config, env, common, lwConfig, project)
// Object.defineProperties(window.lwConfig, {})

document.title = window.lwConfig.SYSTEM_NAME_ALL

// 主题回显
const [h, s, l] = localStorage.hsl?.split(',')?.map((e) => e.trim()) || []
// const l1 = l?.slice(0, -1) - 5
if (h) {
  const style = document.documentElement.style
  style.setProperty('--h', h)
  style.setProperty('--s', s)
  style.setProperty('--l', l)

  // style.setProperty('--hsl', localStorage.hsl)
  // style.setProperty('--hsl-dark', `${h},${s},${l1}%`)
  style.setProperty('--color-sub', localStorage.colorSub)
}

// 灰色主题
// if (window.lwConfig.ENV === 'production') document.documentElement.style.filter = 'grayscale(100%)'

// el-button点击后自动失焦 去除焦点样式
document.addEventListener('click', (event) => {
  let target = event.target
  if (target.className.includes?.('el-button')) {
    target.blur()
  } else if (target.parentNode.className.includes('el-button')) {
    target.parentNode.blur()
  }
})

// 阻止表单默认提交行为
document.addEventListener('submit', (event) => {
  event.preventDefault()
})

// 统一为img的src不是绝对地址的拼接接口地址
// document.addEventListener(
//   'error',
//   function (e) {
//     let target = e.target
//     let src = target.attributes.getNamedItem('src').value
//     if (target.tagName.toUpperCase() === 'IMG' && src && !src.includes('http')) {
//       target.src = window.lwConfig.BASE_API + src
//     }
//   },
//   true
// )

export default config
