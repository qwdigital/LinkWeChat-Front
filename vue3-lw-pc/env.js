/**
 * 环境变量
 * 以下划线 '_' 开头的字段表示只在build命令打包时有效，勿在项目中使用
 */
const envs = {
  development: {
    DOMAIN: 'https://dev.linkwechat.net', // 接口域名（站点域名请使用：window.location.origin）
    BASE_URL: '/', // 页面路由基础路径 /*/*/，eg：/lw/，不支持 ’./‘形式的路径
    BASE_API: 'https://dev.linkwechat.net/linkwechat-api', // 接口基础路径
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: true, // 是否开启cdn加速
  },
  test: {
    DOMAIN: 'https://demo.linkwechat.net',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    _ISGZIP: true,
    _ISCDN: true,
  },
  production: {
    DOMAIN: 'https://demo.linkwechat.net',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    _ISGZIP: true,
    _ISCDN: true,
  },
}
export const env = envs[process.env.VUE_APP_ENV]
// console.log(1, env)
// module.exports = env
