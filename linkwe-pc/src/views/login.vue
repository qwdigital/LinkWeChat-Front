<template>
  <div class="login cc fcbw">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
      <img class="logo" :src="lwConfig.LOGO_TEXT_DARK" alt="" />
      <div class="login-title">欢迎来到{{ lwConfig.SYSTEM_NAME }}</div>
      <div class="login-text">登录你的账户</div>
      <template v-if="loginType === 'account'">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" type="text" auto-complete="off" placeholder="账号">
            <svg-icon style="height: 33px" slot="prefix" icon-class="user" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            auto-complete="off"
            placeholder="密码"
            @keyup.enter.native="handleLogin">
            <svg-icon style="height: 33px" slot="prefix" icon-class="password" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
        <el-form-item prop="code">
          <div style="display: flex">
            <el-input
              v-model="loginForm.code"
              auto-complete="off"
              placeholder="验证码"
              @keyup.enter.native="handleLogin">
              <svg-icon slot="prefix" icon-class="validCode" style="height: 33px" class="el-input__icon input-icon" />
            </el-input>
            <div class="login-code" style="margin-left: 10px">
              <img :src="codeUrl" @click="getCode" class="login-code-img" />
            </div>
          </div>
        </el-form-item>
        <el-checkbox class="fr" v-model="loginForm.rememberMe">记住密码</el-checkbox>
        <el-checkbox
          class="fl"
          v-model="isDemonstrationLogin"
          @change="changeDemonAccount"
          style="margin: 0px 0px 25px 10px">
          演示账号登录
        </el-checkbox>
        <el-form-item style="width: 100%">
          <el-button
            :loading="loading"
            size="medium"
            type="primary"
            style="width: 100%"
            @click.native.prevent="handleLogin">
            <span v-if="!loading">登 录</span>
            <span v-else>登 录 中...</span>
          </el-button>
          <div class="link" @click="changeLoginType('url')">企微登录</div>
        </el-form-item>
      </template>
      <div v-else class="ac">
        <img class="wechat-code" :src="wechatCodeUrl" alt="" />
        <!-- <div class="desc al">企业注册后，员工可直接扫码登录，无需重复注册</div> -->
        <div class="desc">扫码体验完整功能</div>
        <a :href="authLink">
          <el-button :loading="loading" size="medium" type="primary" style="width: 100%">企业微信登录</el-button>
          <!-- <img
            src="//wwcdn.weixin.qq.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_white$4dab5411.png"
 /> -->
        </a>
        <div class="link" @click="changeLoginType('account')">账号密码登录</div>
      </div>
    </el-form>
    <div>
      <img src="@/assets/login.png" class="login-img" alt="" />
    </div>
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
          this.$store
            .dispatch('Login', this.loginForm)
            .then(() => {
              this.$router.push({ path: this.redirect || window.lwConfig.BASE_URL })
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
  position: relative;
  max-width: 1234px;
  max-height: 878px;
  background: #ffffff;
  border-radius: 56px 56px 56px 56px;
  .logo {
    position: absolute;
    height: 58px;
    left: 38px;
    top: 38px;
  }
}
.login-title {
  font-size: 16px;
  color: #4e5969;
}
.login-text {
  font-size: 32px;
  font-weight: 700;
  color: #1d2129;
  margin: 26px auto 50px auto;
}

.login-form {
  width: 50%;
  padding: 0 calc((50% - 360px) / 2);
  .el-input {
    height: 38px;
    line-height: 38px;
    input {
      height: 38px;
    }
  }
  .desc {
    text-align: center;
    color: #aaa;
    font-size: 12px;
    margin: -22px 0 50px;
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}
.login-code {
  .login-code-img {
    height: 32px;
    cursor: pointer;
    vertical-align: middle;
  }
}

.link {
  color: var(--color);
  font-size: 14px;
  // padding-left: 25px;
  margin-top: 20px;
  text-align: left;
  cursor: pointer;
}
.wechat-code {
  width: 220px;
  height: 240px;
  padding: 20px;
  background: #ffffff;
  box-shadow: 0px 8px 24px 0px rgba(7, 193, 96, 0.16);
  border-radius: 24px 24px 24px 24px;
  border: 1px solid #07c160;
}
.login-img {
  padding: 20px;
  width: 100%;
}
</style>
