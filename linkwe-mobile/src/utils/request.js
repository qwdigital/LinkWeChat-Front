import axios from 'axios'
import { Toast, Dialog } from 'vant'

function createAxios(baseURL) {
  const instance = axios.create({
    baseURL,
    timeout: 10000,
  })
  // 请求拦截
  instance.interceptors.request.use(
    (config) => {
      // console.log('request config: ' + JSON.stringify(config))
      config.headers = {
        Authorization: 'Bearer ' + sessionStorage.token,
      }
      return config
    },
    (error) => {
      return Promise.reject(error)
    }
  )
  // 响应拦截
  instance.interceptors.response.use(
    (res) => {
      // console.log('res: ' + res)
      const { data, status } = res
      // code 200:成功，-1/其它:错误
      if (status === 200 && data.code === 200) {
        return data
      } else if (data.code === 401) {
        let r = confirm('登录状态已过期，您可以继续留在该页面，或者重新登录')
        if (r == true) {
          sessionStorage.clear()
          location.reload()
        }
      } else if (data.code == 501) {
        // 红包领取相关错误
        return data
      }
      // else if ([-10002, -10003].includes(data.code)) {
      //   // 用户信息不存在
      //   location.replace('/#/task/state')
      //   location.reload()
      //   return new Promise(() => {})
      // }
      else {
        alert(data.msg)
        // addErrorLog(res)
      }
      return Promise.reject(data)

      // if (process.env.NODE_ENV === 'development') {
      //   return Promise.reject(res) // 这样控制台会显示报错日志
      // } else {
      //   return new Promise(() => {}) // 中断promise
      // }
    },
    (error) => {
      if (error.response) {
        addErrorLog(error.response)
      } else {
        alert('服务器未启动或连接超时')
      }
      return Promise.reject(error)
    }
  )
  // 错误日志
  function addErrorLog(errorInfo) {
    const {
      data,
      statusText,
      status,
      request: { responseText, responseURL },
    } = errorInfo
    // let info = {
    //   type: 'ajax',
    //   code: status,
    //   mes: statusText,
    //   url: responseURL
    // }
    // if (!responseURL.includes('save_error_logger')) store.dispatch('addErrorLog', info)
    try {
      // console.error(`错误: 路径: ${responseURL}, 返回值 : ${responseText}`)
      let mes =
        process.env.ENV === 'production'
          ? `错误: 路径: ${responseURL}, 返回值 : ${responseText}`
          : `系统繁忙，请稍后再试`
      alert(mes)
    } catch (error) {}
  }

  return instance
}

// const httpRequest = createAxios()

export default createAxios(
  process.env.NODE_ENV === 'development' ? '/api' : window.lwConfig.BASE_API
)
