import { getToken } from '@/utils/auth'
import { env } from '../env'

// 系统内常量默认配置，只能从外部配置，内部不可修改
const common = {
  SYSTEM_NAME: 'LinkWeChat', // 系统简称
  SYSTEM_NAME_MOBILE: 'LinkWeChat', // 移动端应用简称
  // SYSTEM_NAME_ALL: 'LinkWeChat--全链路私域数字化营销增长解决方案', // 系统全称
  COMPANY_NAME: 'LinkWeChat', // 公司简称
  COMPANY_NAME_ALL: 'LinkWeChat', // 公司全称
  COPYRIGHT: 'Copyright © 2018-2023 LinkWeChat All Rights Reserved.', // 版权信息
  LOGO_DARK: env.BASE_URL + 'static/LOGO_DARK.png', // 深色logo
  LOGO_LIGHT: env.BASE_URL + 'static/LOGO_LIGHT.png', // 淡色logo
  LOGO_TEXT_DARK: env.BASE_URL + 'static/LOGO_TEXT_DARK.png', // 深色logo+文字
  LOGO_TEXT_LIGHT: env.BASE_URL + 'static/LOGO_TEXT_LIGHT.png', // 淡色logo+文字
  QRCODE_CONTACT_US: env.BASE_URL + 'static/QRCODE_CONTACT_US.png', // 联系我们二维码
  QRCODE_CUSTOMER_SERVICE: env.BASE_URL + 'static/QRCODE_CUSTOMER_SERVICE.png', // 客服二维码
  POST_QRCODE: env.BASE_URL + 'static/POST_QRCODE.png', // 海报占位二维码
  AGREEMENT: env.BASE_URL + 'static/AGREEMENT.pdf', // 用户协议pdf
  PRIVACY: env.BASE_URL + 'static/PRIVACY.pdf', // 隐私协议pdf
  IS_PUBLISH_DIALOG: false, // 是否显示发布弹窗
  COOKIEEXPIRES: 0.5, // token在Cookie中存储的天数，默认0.5天
  WORKWEIXINPAGENAME: 'EnterpriseWechat', // 企业微信设置页面路由name
  DEFAULT_H5_PIC: env.DOMAIN + '/static/PIC.png',
  DEFAULT_H5_ART: env.DOMAIN + '/static/ARTICAL.png', // 文章默认封面
  DEFAULT_H5_TP: env.DOMAIN + '/static/TEXT_PIC.png', // 图文默认封面
  DEFAULT_H5_PDF: env.DOMAIN + '/static/PDF.png', // pdf默认封面
  DEFAULT_H5_WORDE: env.DOMAIN + '/static/WORD.png',
  DEFAULT_H5_PPT: env.DOMAIN + '/static/PPT.png',
  PRIVIEW_URL: env.VIEW_URL,

  MICRO_APPS: {
    store: {
      name: 'microStore',
      entry: env.DOMAIN + '/microStore/',
      container: '#micro-app',
      // activeRule: (location) => location.hash.startsWith('#/microStore'),
      activeRule: env.BASE_URL.slice(env.BASE_URL.indexOf('/')) + 'microStore', // eg:/vue/microStore
    },
  },
}

// 以下仅用于系统信息展示，不作为项目变量使用，请勿在代码中使用
const project = {
  _version: 'v5.0.0-beta.5', // 当前版本信息
  _packDateTime: __PACK_DATETIME__, // 打包时间
  _env: process.env.VUE_APP_ENV, // 前端系统环境模式
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
    system: env.SYSTEM_API,
    // system: 'http://192.168.4.168:6180',
    common: '/common',
  },

  get headers() {
    return { Authorization: 'Bearer ' + getToken() }
  },
}

const lwConfig = window.lwConfig || {} // 线上动态配置，用于覆盖系统默认常量的配置信息

// config 含有getter必须放在merge第一位
window.lwConfig = Object.assign(config, env, common, lwConfig, project)
// Object.defineProperties(window.lwConfig, {})

// 主题回显
const [h, s, l] = localStorage.hsl?.split(',')?.map((e) => e.trim()) || []
const l1 = l?.slice(0, -1) - 5
if (h) {
  const style = document.documentElement.style
  style.setProperty('--hsl', localStorage.hsl)
  style.setProperty('--hsl-dark', `${h},${s},${l1}%`)
  style.setProperty('--color-sub', localStorage.colorSub)
}

// 灰色主题
// if (process.env.VUE_APP_ENV === 'production') document.documentElement.style.filter = 'grayscale(100%)'

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
