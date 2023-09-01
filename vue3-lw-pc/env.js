/**
 * 环境变量
 * 以下划线 '_' 开头的字段表示只在build命令打包时有效，勿在项目中使用
 */
const envs = {
  development: {
    DOMAIN: 'https://dev.linkwechat.net', // 接口域名（站点域名请使用：window.location.origin）
    BASE_URL: '/', // 页面路由基础路径
    BASE_API: 'https://dev.linkwechat.net/linkwechat-dev-api', // 接口基础路径
    VIEW_URL: 'https://saas.pardigital.cn/file-view/onlinePreview?url=', // kkfileview，素材预览服务地址
    _ISGZIP: true,
    _ISCDN: true,
  },
  test: {
    DOMAIN: 'https://demo.linkwechat.net',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    VIEW_URL: 'https://saas.pardigital.cn/file-view/onlinePreview?url=',
    _ISGZIP: true,
    _ISCDN: true,
  },
  production: {
    DOMAIN: 'https://demo.linkwechat.net',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    VIEW_URL: 'https://saas.pardigital.cn/file-view/onlinePreview?url=',
    _ISGZIP: true,
    _ISCDN: true,
  },
}
export const env = Object.assign(
  { SYSTEM_NAME_ALL: 'LinkWeChat -- 全链路私域数字化营销增长解决方案' },
  envs[process.env.VUE_APP_ENV],
)
// console.log(1, env)
// module.exports = env
