<template>
  <div class="login cc fcbw">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
      <img class="logo" :src="$store.app.isDark ? lwConfig.LOGO_TEXT_LIGHT : lwConfig.LOGO_TEXT_DARK" alt="" />
      <div class="login-title">欢迎来到{{ lwConfig.SYSTEM_NAME }}</div>
      <div class="login-text">登录你的账户</div>
      <template v-if="loginType === 'account'">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" type="text" auto-complete="off" placeholder="账号">
            <template #prefix>
              <svg-icon style="height: 33px" icon="user" class="el-input__icon input-icon" />
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            :type="isPassword ? 'password' : 'text'"
            auto-complete="off"
            placeholder="密码"
            @keyup.enter="handleLogin">
            <template #prefix>
              <svg-icon style="height: 33px" icon="password" class="el-input__icon input-icon" />
            </template>
            <template #suffix>
              <svg-icon
                style="height: 33px"
                :icon="isPassword ? 'eye' : 'eye-open'"
                class="el-input__icon input-icon cp"
                @click="isPassword = !isPassword" />
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="code">
          <div class="fxbw">
            <el-input v-model="loginForm.code" auto-complete="off" placeholder="验证码" @keyup.enter="handleLogin">
              <template #prefix>
                <svg-icon icon="validCode" style="height: 33px" class="el-input__icon input-icon" />
              </template>
            </el-input>
            <img class="login-code-img ml10" :src="codeUrl" @click="getCode" />
          </div>
        </el-form-item>
        <div class="fxbw g-margin-b">
          <el-checkbox v-if="lwConfig.IS_LINKWECHAT" v-model="isDemonstrationLogin" @change="changeDemonAccount">
            演示账号登录
          </el-checkbox>
          <el-checkbox class="fr" v-model="loginForm.rememberMe">记住密码</el-checkbox>
        </div>
        <el-form-item>
          <el-button :loading="loading" type="primary" style="width: 100%" @click.prevent="handleLogin">
            <span v-if="!loading">登 录</span>
            <span v-else>登 录 中...</span>
          </el-button>
        </el-form-item>
        <div class="link" @click="changeLoginType('url')">企微登录</div>
      </template>
      <div v-else class="ac">
        <template v-if="lwConfig.IS_LINKWECHAT">
          <img class="wechat-code" :src="wechatCodeUrl" alt="" />
          <!-- <div class="desc al">企业注册后，员工可直接扫码登录，无需重复注册</div> -->
          <div class="desc">扫码体验完整功能</div>
        </template>
        <a :href="authLink">
          <el-button :loading="loading" type="primary" style="width: 100%">企业微信登录</el-button>
          <!-- <img
            src="//wwcdn.weixin.qq.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_white$4dab5411.png" /> -->
        </a>
        <div class="link" @click="changeLoginType('account')">账号密码登录</div>
      </div>
    </el-form>
    <img src="@/assets/login.png" class="login-img" alt="" />
  </div>
</template>

<script>
import { getCodeImg, getCodeInSyetem } from '@/api/login'
import Cookies from 'js-cookie'
import { encrypt, decrypt } from '@/utils/jsencrypt'

export default {
  name: 'Login',
  data() {
    return {
      loginType: 'url',
      codeUrl: '',
      wechatCodeUrl: '',
      cookiePassword: '',
      isPassword: true,
      loginForm: {
        username: '',
        password: '',
        rememberMe: false,
        code: '',
        uuid: '',
      },
      loginRules: {
        username: [{ required: true, trigger: 'blur', message: '用户名不能为空' }],
        password: [{ required: true, trigger: 'blur', message: '密码不能为空' }],
        code: [{ required: true, trigger: 'change', message: '验证码不能为空' }],
      },
      authLink: '',
      loading: false,
      redirect: undefined,
      dialogVisible: true,
      isDemonstrationLogin: false,
    }
  },
  watch: {
    $route: {
      handler: function (route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true,
    },
  },
  created() {
    console.log(this.$route.query.redirect)
    getCodeInSyetem().then(({ data, code, msg }) => {
      if (code === 200) {
        this.authLink = data.loginQr
        this.wechatCodeUrl = data.joinCorpQr
      } else if (code === 226) {
        this.msgError(msg)
        this.loginType = 'account'
        this.getCode()
        this.getCookie()
      }
    })
    // window.lwConfig.IS_PUBLISH_DIALOG &&
    //   this.$alert('LinkWeChat V2.5 已正式发布，遇到使用上的问题欢迎提交 Issue，我们将光速修复。', '提示', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //   })
  },
  methods: {
    changeLoginType(type) {
      this.loginType = type
      if (type === 'account') {
        this.getCode()
        this.getCookie()
      }
    },
    getCode() {
      getCodeImg().then(({ data }) => {
        this.codeUrl = 'data:image/gif;base64,' + data.img
        this.loginForm.uuid = data.uuid
      })
    },
    getCookie() {
      const username = Cookies.get('username')
      const password = Cookies.get('password')
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe),
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set('username', this.loginForm.username, { expires: 30 })
            Cookies.set('password', encrypt(this.loginForm.password), {
              expires: 30,
            })
            Cookies.set('rememberMe', this.loginForm.rememberMe, {
              expires: 30,
            })
          } else {
            Cookies.remove('username')
            Cookies.remove('password')
            Cookies.remove('rememberMe')
          }
          let loginForm = JSON.parse(JSON.stringify(this.loginForm))
          loginForm.password = encrypt(this.loginForm.password)
          this.$store
            .Login(loginForm)
            .then(() => {
              this.$router.push(this.redirect || window.lwConfig.BASE_URL)
            })
            .catch(() => {
              this.loading = false
              this.getCode()
            })
        }
      })
    },
    goVote() {
      window.open('https://www.oschina.net/p/linkwechat')
    },
    changeDemonAccount(val) {
      this.loginForm.username = val ? 'lw' : ''
      this.loginForm.password = val ? '123456' : ''
    },
  },
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.login {
  width: min(80%, 1234px);
  height: min(80%, 878px);
  min-height: 700px;
  background: var(--bg-white);
  border-radius: 56px;
  .logo {
    position: absolute;
    height: 28px;
    left: 38px;
    top: 38px;
  }
}
.login-title {
  font-size: 16px;
  color: var(--font-black-4);
}
.login-text {
  font-size: 32px;
  font-weight: 700;
  color: var(--font-black);
  margin: 26px auto 50px auto;
}

.login-form {
  width: 50%;
  padding: 0 calc((50% - 360px) / 2);
  // .el-input {
  //   height: 38px;
  //   line-height: 38px;
  //   input {
  //     height: 38px;
  //   }
  // }
  .desc {
    text-align: center;
    color: var(--font-black-7);
    font-size: 12px;
    margin: -22px 0 50px;
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}
.login-code-img {
  height: 32px;
  cursor: pointer;
  vertical-align: middle;
}

.link {
  color: var(--color);
  font-size: 14px;
  margin-top: var(--card-margin);
  text-align: left;
  cursor: pointer;
}
.wechat-code {
  width: 220px;
  height: 240px;
  padding: 20px;
  background: var(--bg-white);
  box-shadow: 0px 8px 24px 0px rgba(7, 193, 96, 0.16);
  border-radius: 24px 24px 24px 24px;
  border: 1px solid var(--color);
}
.login-img {
  padding: 20px;
  height: 100%;
}
</style>
