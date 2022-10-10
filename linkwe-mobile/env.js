const envs = {
  development: {
    BASE_URL: '/devMobile/saas/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/saas-dev-api',
    APPID: 'ww622fc852f79c3f13'
  },
  test: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    APPID: 'ww622fc852f79c3f13'
  },
  production: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    APPID: 'ww622fc852f79c3f13'
  },
}
let env = envs[process.env.VUE_APP_ENV]

module.exports = env
