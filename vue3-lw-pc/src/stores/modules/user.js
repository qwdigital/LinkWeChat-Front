import { login, logout, getInfo } from '@/api/login'
import { getToken, setToken, removeToken } from '@/utils/auth'

const user = {
  state: {
    token: getToken(),
    name: '',
    companyName: '',
    avatar: new URL('@/assets/image/profile.jpg', import.meta.url).href,
    roles: [],
    permissions: [],
    configParamInfo: {},
  },

  actions: {
    // 登录
    Login(userInfo) {
      const username = userInfo.username.trim()
      const password = userInfo.password
      const code = userInfo.code
      const uuid = userInfo.uuid
      return new Promise((resolve, reject) => {
        login(username, password, code, uuid)
          .then(({ data }) => {
            setToken(data.access_token)
            this.user.token = data.access_token

            resolve()
          })
          .catch((error) => {
            reject(error)
          })
      })
    },

    // 获取用户信息
    GetInfo() {
      return new Promise((resolve, reject) => {
        getInfo(this.user.token).then((res) => {
          try {
            const user = res.user
            const avatar = user.avatar
            // : window.lwConfig.BASE_API + user.avatar
            if (res.roles && res.roles.length > 0) {
              // 验证返回的roles是否是一个非空数组
              //   'SET_ROLES',
              //   // res.user.roles.map((data) => {
              //   //   return data.roleKey
              //   // })
              //   res.roles,
              // )
              this.user.roles = res.roles
              this.user.permissions = res.permissions
            } else {
              this.user.roles = ['ROLE_DEFAULT']
            }
            this.user.name = user.userName
            avatar && (this.user.avatar = avatar)
            this.user.configParamInfo = res.configParamInfo

            this.user.companyName = user.companyName
            resolve(res)
          } catch (error) {
            reject(error)
          }
        })
      })
    },

    // 退出系统
    LogOut() {
      return new Promise((resolve, reject) => {
        this.user.token = ''
        this.user.roles = []
        this.user.permissions = []

        removeToken()
        resolve()
        // logout(state.token)
        //   .then(() => {
        //     removeToken()
        //     resolve()
        //   })
        //   .catch((error) => {
        //     reject(error)
        //   })
        location.href = window.lwConfig.BASE_URL
      })
    },
  },
}

export default user
