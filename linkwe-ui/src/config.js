import { getToken } from '@/utils/auth'

window.CONFIG = {
  /**
   * 是否系统布局配置
   */
  showSettings: false,

  /**
   * 是否显示 tagsView
   */
  tagsView: true,

  /**
   * 是否固定头部
   */
  fixedHeader: false,

  /**
   * 是否显示logo
   */
  sidebarLogo: true,

  /**
   * @type {string | array} 'production' | ['production', 'development']
   * @description Need show err logs component.
   * The default is only used in the production env
   * If you want to also use it in dev, you can pass ['production', 'development']
   */
  errorLog: 'production',

  services: {
    wecom: '/wecom',
    common: '/common',
  },

  /**
   * 前端生成群活码跳转的H5链接
   * 由于群活码是由前端生成，需要配置一下群活码跳转的链接
   * 例如: http://xxx.xxx.xx/h5/groupCode
   */
  groupCodeH5Link: 'http://linkwechat.cn/mobile/#/groupCode',

  get headers() {
    return { Authorization: 'Bearer ' + getToken() }
  },
}
export default window.CONFIG
