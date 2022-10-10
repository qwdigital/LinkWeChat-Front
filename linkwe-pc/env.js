// '_' 开头的字段表示只在打包时使用，勿在项目中使用
const envs = {
  development: {
    DOMAIN: 'http://demo.linkwechat.net',
    BASE_URL: './', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    SYSTEM_API: '/linkwechat-api',
    KF_API: '/linkwechat-api',
  },
  test: {
    DOMAIN: 'http://demo.linkwechat.net',
    BASE_URL: './', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    SYSTEM_API: '/linkwechat-api',
    KF_API: '/linkwechat-api',
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: false, // 是否开启cdn加速
  },
  production: {
    DOMAIN: 'http://demo.linkwechat.net',
    BASE_URL: './', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    SYSTEM_API: '/linkwechat-api',
    KF_API: '/linkwechat-api',
    _ISGZIP: true, // 是否开启gzip压缩
    _ISCDN: false, // 是否开启cdn加速
  },
}
const env = Object.assign(
  { SYSTEM_NAME_ALL: 'LinkWeChat -- 全链路私域数字化营销增长解决方案' },
  envs[process.env.VUE_APP_ENV || process.env.NODE_ENV]
)

module.exports = env
