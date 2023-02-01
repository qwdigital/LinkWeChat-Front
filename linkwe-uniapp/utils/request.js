import Request from '@/js_sdk/luch-request/luch-request/index.js'
import cfg from '@/config.js'

const http = new Request()

http.interceptors.request.use(
  (config) => {
    // 可使用async await 做异步操作
    // config.header = {
    //   ...config.header,
    //   a: 1 // 演示拦截器header加参
    // }
    // 演示custom 用处
    // if (config.custom.auth) {
    //   config.header.token = 'token'
    // }
    config.header['Authorization'] =
      'eyJhbGciOiJIUzUxMiJ9.eyJ1c2VyX3R5cGUiOiIwMCIsInVzZXJfaWQiOjEsImxvZ2luX3R5cGUiOiJMaW5rV2VDaGF0QVBJIiwidXNlcl9uYW1lIjoiYWRtaW4iLCJ1c2VyX2tleSI6IjYyZjRiYWZmLWY2NzYtNGNlOS1iNDNhLTZhMjhlM2QwYTEwNiIsImNvcnBfbmFtZSI6IuS7n-W-ruenkeaKgCIsImNvcnBfaWQiOiJ3dzYyMmZjODUyZjc5YzNmMTMifQ.CvkoSw7K1eT-AjmfFYX5e2MlxKFNjfqzPpIwPlEuNDRL3ZASTW7t6UlGUl5CbYGI-F-3EPcVvFm9PcEk_YKtlQ'
    // if (config.custom.loading) {
    //  uni.showLoading()
    // }
    /**
   /* 演示
   if (!token) { // 如果token不存在，return Promise.reject(config) 会取消本次请求
      return Promise.reject(config)
    }
   **/
    return config
  },
  (config) => {
    // 可使用async await 做异步操作
    return Promise.reject(config)
  },
)

http.interceptors.response.use(
  (response) => {
    /* 对响应成功做点什么 可使用async await 做异步操作*/
    let data = response.data
    if (data.code == 200) {
      return data
    }
    uni.hideLoading()
    uni.showToast({
      icon: 'none',
      title: data.msg,
      duration: 3000,
    })
    return Promise.reject(response) // return Promise.reject 可使promise状态进入catch
  },
  (response) => {
    /*  对响应错误做点什么 （statusCode !== 200）*/
    console.log(response)
    return Promise.reject(response)
  },
)

export async function post(url, data) {
  return http.request({
    method: 'POST', // 请求方法必须大写
    url,
    data,
  })
}

export async function get(url, params) {
  return http.get(url, {
    params,
  })
}

export default function(config = {}) {
  config.baseURL = cfg.BASE_API
  // 兼容get方法使用data传参
  if ((config.method || 'get').toLowerCase() === 'get' && !config.params) {
    config.params = config.data
  }
  return http.request(config)
}
