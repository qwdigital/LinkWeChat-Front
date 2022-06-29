const envs = {
  development: {
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.cn/dev-api',
  },
  test: {
    BASE_URL: '/devMobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.cn/dev-api',
  },
  production: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.cn/prod-api',
  },
}
let env = envs[process.env.VUE_APP_ENV]

module.exports = env
