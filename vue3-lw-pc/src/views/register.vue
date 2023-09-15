<script>
import { getInstallThirdAppUrl, findWxQrLoginInfo, getRegisterQrCode, getCustomerServiceQrUrl } from '@/api/login'
export default {
  name: '',
  components: {},
  data() {
    return {
      active: 0,
      // dialogVisible: false,
      authQrcode: '',
      serviceQrcode: '',
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getRegisterQrCode()
    this.getCustomerServiceQrUrl()
  },
  mounted() {},
  methods: {
    auth() {
      getInstallThirdAppUrl().then(({ data }) => {
        // this.dialogVisible = true
        location.href = data
      })
    },
    getRegisterQrCode() {
      getRegisterQrCode().then(({ data }) => {
        this.authQrcode = 'data:image/gif;base64,' + data.qrcodeUrl
      })
    },
    getCustomerServiceQrUrl() {
      getCustomerServiceQrUrl().then(({ data }) => {
        this.serviceQrcode = data
      })
    },
    login() {
      findWxQrLoginInfo().then(({ data }) => {
        location.href = data
      })
    },
  },
}
</script>

<template>
  <div class="register cc bgw">
    <el-steps :active="active" process-status="finish">
      <el-step title="第三方应用授权"></el-step>
      <el-step title="自建代开发授权"></el-step>
      <el-step title="等待配置完成"></el-step>
    </el-steps>

    <div v-show="active == 0" class="register-step first ac">
      <div class="auth-btn">
        <el-button size="default" type="primary" style="width: 255px" @click="auth">
          <svg-icon icon="qiyeweixin" class="qiyeweixin-icon"></svg-icon>
          <span>企业微信扫码授权</span>
        </el-button>
      </div>
      <el-button size="default" type="primary" plain style="width: 255px" @click="active = 1">
        <span>我已完成第三方授权</span>
      </el-button>

      <ul class="register-step-desc al">
        <li>第三方应用授权主要用于进行企业验证并安装{{ lwConfig.SYSTEM_NAME }}第三方应用：</li>
        <li>如果您是首次注册，请点击「企业微信扫码授权」进行授权；</li>
        <li>如果您已经进行过授权，点击「我已完成第三方授权」进入下一步；</li>
      </ul>
    </div>

    <div v-show="active == 1" class="register-step ac">
      <div class="blod">管理员使用企业微信扫码授权自建应用代开发</div>
      <div class="fxbw step-main">
        <div class="step-aside">
          <div class="step-text">管理员扫码授权</div>
          <img class="step-qrcode" :src="authQrcode" alt="" />
        </div>
        <div class="step-line"></div>
        <div class="step-aside">
          <div class="step-text">
            请确保扫码并成功授权后点击
            <el-popover ref="popover1" placement="right" width="" trigger="hover">
              <!-- <img class="auth-desc-img" src="@/assets/register/auth-desc-1.png" alt="" /> -->
              <template #reference>
                <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
              </template>
            </el-popover>
          </div>
          <el-button size="default" type="primary" style="margin-top: 50px" @click="active = 2">
            <span>我已完成扫码并授权</span>
          </el-button>
        </div>
      </div>
      <ul class="register-step-desc al">
        <li>自建应用代开发主要用于{{ lwConfig.SYSTEM_NAME }}为您提供更灵活的定制化服务：</li>
        <li>
          请使用管理员的企业微信进行授权；
          <el-popover ref="popover1" placement="right" width="" trigger="hover">
            <!-- <img class="auth-desc-img" src="@/assets/register/auth-desc-1.png" alt="" /> -->
            <template #reference>
              <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
            </template>
          </el-popover>
        </li>
        <li>授权成功后，我们将火速为您配置并上线应用，即刻体验；</li>
      </ul>
    </div>

    <div v-show="active == 2" class="register-step ac">
      <div class="blod">正在为您火速配置应用中，预计需要10分钟时间</div>
      <div class="fxbw step-main">
        <div class="step-aside">
          <div class="step-text">联系客服催办</div>
          <img class="step-qrcode" :src="serviceQrcode" alt="" />
        </div>
        <div class="step-line"></div>
        <div class="step-aside">
          <div class="step-text">
            已收到上线通知
            <el-popover ref="popover1" placement="right" width="" trigger="hover">
              <!-- <img class="auth-desc-img" src="@/assets/register/auth-desc-2.png" alt="" /> -->
              <template #reference>
                <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
              </template>
            </el-popover>
          </div>
          <el-button size="default" type="primary" style="margin-top: 50px" @click="login">
            <span>立即登录</span>
          </el-button>
        </div>
      </div>
      <ul class="register-step-desc al">
        <li>我们已经收到您的注册请求，正在为您配置应用：</li>
        <li>
          配置过程中您将会收到权限变更通知，请点击确认授权；
          <el-popover ref="popover1" placement="right" width="" trigger="hover">
            <!-- <img class="auth-desc-img" src="@/assets/register/auth-desc-3.png" alt="" /> -->
            <template #reference>
              <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
            </template>
          </el-popover>
        </li>
        <li>
          应用配置完成后，您将会收到代开发应用上线通知，快登录体验吧；
          <el-popover ref="popover1" placement="right" width="" trigger="hover">
            <!-- <img class="auth-desc-img" src="@/assets/register/auth-desc-2.png" alt="" /> -->
            <template #reference>
              <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
            </template>
          </el-popover>
        </li>
      </ul>
    </div>

    <!-- <el-dialog
      title="授权第三方应用中…"
       v-model:visible="dialogVisible"
      width="400px"
      :close-on-click-modal="false"
      append-to-body
      top="30vh"
    >
      <div>
        请在新窗口中为您的企业授权安装{{lwConfig.SYSTEM_NAME}}第三方应用，授权完成后，点击此弹窗右下角的「我已完成授权」进入下一步。
      </div>
      <div slot="footer">
        <el-button @click="auth">重新授权</el-button>
        <el-button
          type="primary"
          @click="
            active = 1
            dialogVisible = false
          "
          >我已完成授权</el-button
        >
      </div>
    </el-dialog> -->
  </div>
</template>

<style lang="scss" scoped>
.register {
  width: 750px;
  height: 490px;
  padding: 30px 35px;
}
.register-step {
  margin: 30px auto;
}
.first {
  .auth-btn {
    margin: 90px auto 20px;
  }
}
.step-main {
  width: 500px;
  margin: 30px auto;
  .step-aside {
    width: 200px;
  }
  .step-text {
    margin-top: 20px;
  }
  .step-qrcode {
    width: 150px;
  }
  .step-line {
    width: 2px;
    height: 190px;
    background: var(--bg-black-9);
  }
}
.register-step-desc {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 520px;
  padding: 10px 40px;
  margin: 0 auto;
  background: var(--bg-black-9);
  border-radius: 5px;
  line-height: 1.5;
  bottom: 20px;
}
.el-icon-QuestionFilled {
  color: var(--font-black-7);
}
.auth-desc-img {
  height: 400px;
}
</style>
