import axios from 'axios'
import { ElNotification as Notification, ElMessageBox as MessageBox, ElMessage as Message } from 'element-plus'
import stores from '@/stores'
import { getToken, setToken } from '@/utils/auth'
import errorCode from '@/utils/errorCode'

// axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'
// setToken('eyJhbGciOiJIUzUxMiJ9.eyJ0ZW5hbnRfaWQiOjI2LCJ1c2VyX3R5cGUiOiI1IiwidXNlcl9pZCI6MjU5LCJ3ZUFwcFNlY3JldCI6IjY0YjRjNWRiMzg3MjA2Nzc2ZDRmYWJlMjEwNWMwNTc1IiwibG9naW5fdHlwZSI6IkxpbmtXZUNoYXRBUEkiLCJ1c2VyX25hbWUiOiLlp5zpuY_lh68iLCJ1c2VyX2tleSI6ImRmNTdmYzY4LWI2ZTYtNDVmNS04N2UzLWY4YzA5ZTZiNzFiOSIsIndlQXBwSWQiOiJ3eDg2M2MwMzFhNzRmNTg5YTAiLCJjb3JwX25hbWUiOiLku5_lvq7np5HmioAiLCJjb3JwX2lkIjoid3c2MjJmYzg1MmY3OWMzZjEzIn0.X5To1L7fJRBEIxmP6Dvp2XTpvWHwz8Ey6ODAeyk_owlFj_JywVjfpodDk0B7bGjRXE16nNpab0L9f3eF_-WGPQ')

// 创建axios实例
function requestFactory(getway = '') {
  const service = axios.create({
    // axios中请求配置有baseURL选项，表示请求URL公共部分
    baseURL: (process.env.NODE_ENV === 'development' ? '/api' : window.lwConfig.BASE_API) + getway,
    // 超时
    timeout: 100000,
  })

  // request拦截器
  service.interceptors.request.use(
    (config) => {
      // 是否需要设置 token
      const isToken = (config.headers || {}).isToken === false
      if (getToken() && !isToken) {
        // config.headers = window.lwConfig.headers // 让每个请求携带自定义token 请根据实际情况自行修改
        Object.assign(config.headers, window.lwConfig.headers) // 让每个请求携带自定义token 请根据实际情况自行修改
      }
      return config
    },
    (error) => {
      console.log(error)
      Promise.reject(error)
    },
  )

  // 响应拦截器
  service.interceptors.response.use(
    (res) => {
      let store = stores()
      // 未设置状态码则默认成功状态
      const code = res.data.code || 200
      // 获取错误信息
      const msg = errorCode[code] || res.data.msg || errorCode['default']
      if ([200, 226, 433].includes(code)) {
        return res.data
      } else if (code === 401) {
        MessageBox.confirm('登录状态已过期，您可以继续留在该页面，或者重新登录', '系统提示', {
          confirmButtonText: '重新登录',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(() => {
          store.LogOut()
        })
      } else if ([-10007, -10008].includes(code) && location.host == 'demo.linkwechat.net') {
        MessageBox.alert(
          `
          <div><h3>${msg}</h3></div>
          <div class="mt20 ac">
            <img style="width: 280px" src="${window.lwConfig.QRCODE_CONTACT_US}" alt="" />
          </div>
        `,
          '系统提示',
          {
            confirmButtonText: '我知道了',
            // cancelButtonText: '取消',
            // type: 'warning',
            dangerouslyUseHTMLString: true,
          },
        ).then(() => {
          code == -10007 && store.LogOut()
        })
      } else {
        if (process.env.NODE_ENV === 'development') {
          Message({
            message: `后端错误：接口：${res.config.url}，${code}错误：${msg}`,
            type: 'error',
          })
        } else if ([40029, -10002].includes(code)) {
          // 不合法的oauth_code,租户未授权等
          MessageBox.confirm(msg, '系统提示', {
            confirmButtonText: '重新登录',
            cancelButtonText: '取消',
            type: 'warning',
          }).then(() => {
            store.LogOut()
          })
        } else {
          Notification.error({
            title: msg,
          })
        }
        return Promise.reject()
      }
    },
    (error) => {
      console.log('err: ' + error)
      let { message: msg, response, config } = error
      if (msg == 'Network Error') {
        msg = '后端接口连接异常'
      } else if (msg.includes('timeout')) {
        msg = '系统接口请求超时'
      } else if (response) {
        let status = response.status
        msg = '系统接口:' + status + '异常'
      }
      Message({
        message: `${msg}:${config.url}`,
        type: 'error',
        duration: 5 * 1000,
      })
      return Promise.reject()
    },
  )

  // 重写方法，统一传参格式
  service.get = (url, params, config = {}) => {
    return service({ url, params, ...config })
  }

  let post = service.post
  service.post = (url, data, config = {}) => {
    return post(url, data, config)
  }

  let put = service.put
  service.put = (url, data, config = {}) => {
    return put(url, data, config)
  }

  let del = service.delete
  service.del = (url, params, config = {}) => {
    return del(url, { params, ...config })
  }

  return service
}

// 创建常用网关接口请求
export const requestOpen = requestFactory(window.lwConfig.services.wecom)
export const requestAi = requestFactory(window.lwConfig.services.ai)

export default requestFactory()
