<template>
  <div class="login">
    <div class="login-wrap">
      <img class="login-bg1" src="@/assets/image/login_bg1.png" alt="" />
      <img class="login-bg2" src="@/assets/image/login_bg2.png" alt="" />
      <img class="login-bg3" src="@/assets/image/login_bg3.png" alt="" />
      <div class="login-form-wrap">
        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
          <h3 class="title">{{ lwConfig.SYSTEM_NAME }}</h3>
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
                  <svg-icon
                    slot="prefix"
                    icon-class="validCode"
                    style="height: 33px"
                    class="el-input__icon input-icon" />
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
            </el-form-item>
            <div style="margin-bottom: 20px">
              <a @click="changeLoginType('url')" class="link">企微登录</a>
            </div>
          </template>
          <template v-else>
            <img style="height: 180px; width: 180px" :src="wechatCodeUrl" alt="" />
            <!-- <div class="desc al">企业注册后，员工可直接扫码登录，无需重复注册</div> -->
            <div class="desc al">扫码加入企业，点击企业微信登录，即可扫码登录系统</div>
            <el-form-item class="ac">
              <a :href="authLink">
                <img
                  src="//wwcdn.weixin.qq.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_white$4dab5411.png"
                  srcset="
                    //wwcdn.weixin.qq.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_white_2x$6a1f5234.png 2x
                  "
                  alt="点我加入企业微信" />
              </a>
            </el-form-item>
            <div style="margin-bottom: 20px">
              <a @click="changeLoginType('account')" class="link">账号密码登录</a>
            </div>
          </template>
        </el-form>
      </div>
    </div>

    <!--  底部  -->
    <div class="el-login-footer">
      <span>
        {{ lwConfig.COPYRIGHT || 'Copyright © 2018-2022 LinkWeChat All Rights Reserved.' }}
      </span>
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
    window.lwConfig.IS_PUBLISH_DIALOG &&
      this.$alert('LinkWeChat V2.5 已正式发布，遇到使用上的问题欢迎提交 Issue，我们将光速修复。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      })
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
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  // background-image: url('../assets/image/login-background.png');
  background-size: cover;
}
.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #027dfe;
}

.login-form {
  border-radius: 6px;
  width: 400px;
  padding: 25px 25px 5px 25px;
  position: absolute;
  top: 100px;
  z-index: 10;
  .el-input {
    height: 38px;
    input {
      height: 38px;
    }
  }
  .desc {
    text-align: center;
    color: #aaa;
    font-size: 12px;
    margin-bottom: 50px;
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}
.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}
.login-code {
  width: 33%;
  height: 38px;
  float: right;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}
.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  // color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
  z-index: 90;
}
.login-code-img {
  height: 38px;
}
.login ::v-deep.el-dialog {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  margin-top: 0vh !important;
}
.el-dialog__body {
  padding: 0px 20px;
}
[class*='login-bg'] {
  position: absolute;
  z-index: 0;
}
.login-form-wrap {
  position: relative;
  background: #fff;
  text-align: center;
  height: 609px;
  top: 50px;
  left: 100px;
}
.login-wrap {
  position: relative;
  width: 1180px;
  height: 720px;
  overflow: hidden;
}
.login-bg1 {
  top: 0;
  left: 0;
}
.login-bg2 {
  top: 50px;
  left: 370px;
  z-index: 10;
}
.login-bg3 {
  top: 220px;
  right: 25px;
  z-index: 20;
}
.link {
  color: var(--color);
  font-size: 14px;
  float: right;
  padding-right: 25px;
  &:hover {
    text-decoration: underline;
  }
}
.code_con {
  text-align: center;
  margin-top: 20px;
  img {
    height: 200px;
    width: 200px;
  }
}
</style>
