const envs = {
  development: {
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/saas-dev-api',
  },
  test: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
  },
  production: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
  },
}
let env = envs[process.env.VUE_APP_ENV]

module.exports = env
