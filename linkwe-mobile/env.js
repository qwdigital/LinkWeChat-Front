const envs = {
  development: {
    BASE_URL: '/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/saas-dev-api',
    APPID: 'ww622fc852f79c3f13', // 企业corpid (仟微科技)
    AGENTID: '1000080', // 自建应用agentId (LinkWeChat)
  },
  test: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    APPID: 'ww622fc852f79c3f13',
    AGENTID: '1000080',
  },
  production: {
    BASE_URL: '/mobile/', // 路由基础路径
    BASE_API: 'http://demo.linkwechat.net/linkwechat-api',
    APPID: 'ww622fc852f79c3f13',
    AGENTID: '1000080',
  },
}
let env = envs[process.env.VUE_APP_ENV]

module.exports = env
