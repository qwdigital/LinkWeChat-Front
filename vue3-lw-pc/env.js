/**
 * 环境变量
 * 以下划线 '_' 开头的字段表示只在build命令打包时有效，勿在项目中使用
 */
export const envs = {
  development: {
    DOMAIN: 'https://dev.linkwechat.net', // 站点域名，会用于判断环境
    DOMAIN_MOBILE: 'https://dev.linkwechat.net/mobile', // linkwe-mobile (vue2) 移动端地址
    BASE_URL: '/', // 页面路由基础路径 /*/*/，eg：/lw/，不支持 ’./‘形式的路径
    BASE_API: 'https://dev.linkwechat.net/linkwechat-api', // 接口基础路径
    PRIVIEW_URL: 'https://dev.linkwechat.net/fileView/onlinePreview?url=', // kkfileview，素材预览服务地址
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: false, // 是否开启cdn加速
  },
  test: {
    DOMAIN: 'https://demo.linkwechat.net',
    DOMAIN_MOBILE: 'https://demo.linkwechat.net/mobile',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    PRIVIEW_URL: 'https://demo.linkwechat.net/fileView/onlinePreview?url=', // kkfileview，素材预览服务地址
    _ISGZIP: true,
    _ISCDN: false,
  },
  production: {
    DOMAIN: 'https://demo.linkwechat.net',
    DOMAIN_MOBILE: 'https://demo.linkwechat.net/mobile',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    PRIVIEW_URL: 'https://demo.linkwechat.net/fileView/onlinePreview?url=', // kkfileview，素材预览服务地址
    _ISGZIP: true,
    _ISCDN: false,
  },
}
let _env = {}
if (process.env.NODE_ENV == 'development' || !globalThis.document) {
  // 本地开发和构建(vite)时使用
  _env = envs[process.env.VUE_APP_ENV]
  _env.ENV = process.env.VUE_APP_ENV
} else {
  // 打包后，根据访问域名动态判断环境
  let mode = Object.keys(envs).find((e) => envs[e].DOMAIN === window?.location.origin)
  _env = envs[mode]
  _env.ENV = mode // 前端系统环境模式 development，test，production
}
export const env = _env
// console.log(1, env)
// module.exports = env
