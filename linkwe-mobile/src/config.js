import env from '../env'

// 系统常量
const common = {
  SYSTEM_NAME: '仟微助手',
  SYSTEM_NAME_ALL: 'LinkWechat 企业微信SCRM 仟微助手',
  COMPANY_NAME: '仟微科技',
  COMPANY_NAME_ALL: '仟微科技',
  // COPYRIGHT: 'Copyright © 2018-2022 LinkWeChat All Rights Reserved.',
  // LOGO_DARK: env.BASE_URL + 'static/LOGO_DARK.png',
  // LOGO_LIGHT: env.BASE_URL + 'static/LOGO_LIGHT.png',
  // LOGO_TEXT_DARK: env.BASE_URL + 'static/LOGO_TEXT_DARK.png',
  // LOGO_TEXT_LIGHT: env.BASE_URL + 'static/LOGO_TEXT_LIGHT.png',
  // QRCODE_CONTACT_US: env.BASE_URL + 'static/QRCODE_CONTACT_US.png',
  // QRCODE_CUSTOMER_SERVICE: env.BASE_URL + 'static/QRCODE_CUSTOMER_SERVICE.png',
  // IS_PUBLISH_DIALOG: true, // 是否显示发布弹窗
  IS_VCONSOLE: true, // 是否显示发布弹窗
  APPID: 'wx863c031a74f589a0', // 微信公众号id
}
const config = {
  cookieExpires: 1, //token在Cookie中存储的天数，默认1天
  homeName: 'home', //默认打开的首页的路由name值，默认为home
  services: {
    wecom: '/wecom',
  },
}
window.lwConfig = Object.assign(env, common, window.lwConfig || {}, config)
document.title = window.lwConfig.SYSTEM_NAME

window.CONFIG = config

export default config
