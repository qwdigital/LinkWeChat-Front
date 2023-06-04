/**
 * 环境变量
 * 以下划线 '_' 开头的字段表示只在build命令打包时有效，勿在项目中使用
 */
const envs = {
  development: {
    DOMAIN: 'https://dev.linkwechat.net',
    BASE_URL: './', // 路由基础路径
    BASE_API: 'https://dev.linkwechat.net/linkwechat-dev-api',
    SYSTEM_API: '/linkwechat-dev-api',
    VIEW_URL: 'https://saas.pardigital.cn/file-view/onlinePreview?url=',
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: true, // 是否开启cdn加速
  },
  test: {
    DOMAIN: 'https://demo.linkwechat.net',
    BASE_URL: '/vue3/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    SYSTEM_API: '/linkwechat-api',
    VIEW_URL: 'https://saas.pardigital.cn/file-view/onlinePreview?url=',
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: true, // 是否开启cdn加速
  },
  production: {
    DOMAIN: 'https://demo.linkwechat.net',
    BASE_URL: '/vue3/', // 路由基础路径
    BASE_API: 'https://demo.linkwechat.net/linkwechat-api',
    VIEW_URL: 'https://saas.pardigital.cn/file-view/onlinePreview?url=',
    SYSTEM_API: '/linkwechat-api',
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: true, // 是否开启cdn加速
  },
}
export const env = Object.assign(
  { SYSTEM_NAME_ALL: 'LinkWeChat -- 全链路私域数字化营销增长解决方案' },
  envs[process.env.VUE_APP_ENV],
)
// console.log(1, env)
// module.exports = env
