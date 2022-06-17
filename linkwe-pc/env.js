const envs = {
  development: {
    DOMAIN: 'http://demo.linkwechat.cn',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.cn/dev-api',
    SYSTEM_API: '/dev-api',
    KF_API: '/dev-kf',
  },
  test: {
    DOMAIN: 'http://demo.linkwechat.cn',
    BASE_URL: '/dev/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.cn/dev-api',
    SYSTEM_API: '/dev-api',
    KF_API: '/dev-kf',
  },
  production: {
    DOMAIN: 'http://demo.linkwechat.cn',
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.cn/prod-api',
    SYSTEM_API: '/prod-api',
    KF_API: '/prod-kf',
  },
}
const env = envs[process.env.VUE_APP_ENV || process.env.NODE_ENV]

module.exports = env
