<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="180px">
      <div class="g-card">
        <div class="g-card-title">短链小程序配置</div>
        <div>
          <el-form-item label="微信小程序APPID:" prop="miniAppId">
            <el-input v-model="form.miniAppId" placeholder="请输入APPID"></el-input>
            <!-- <div class="tips">在微信公众号后台->开发管理->开发设置中获取</div> -->
          </el-form-item>
        </div>
        <div id="step2">
          <el-form-item label="微信小程序Secret:" prop="miniSecret">
            <el-input v-model="form.miniSecret" placeholder="请输入小程序Secret"></el-input>
            <!-- <div class="tips">在微信公众号后台->开发管理->开发设置->开发者ID中获取</div> -->
          </el-form-item>
        </div>

        <el-form-item label="小程序原始ID:" prop="wxAppletOriginalId">
          <el-input v-model="form.wxAppletOriginalId" placeholder="请输入小程序原始ID"></el-input>
          <!-- <div class="tips">在微信公众号后台->开发管理->开发设置中获取</div> -->
        </el-form-item>

        <!-- <div class="g-card-title">商城小程序配置</div>
        <div>
          <el-form-item label="微信小程序APPID:" prop="shopAppId">
            <el-input v-model="form.shopAppId" placeholder="请输入APPID"></el-input>
            <div class="tips">在微信公众号后台->开发管理->开发设置中获取</div>
          </el-form-item>
        </div>
        <div id="step2">
          <el-form-item label="微信小程序Secret:" prop="shopSecret">
            <el-input v-model="form.shopSecret" placeholder="请输入小程序Secret"></el-input>
            <div class="tips">在微信公众号后台->开发管理->开发设置->开发者ID中获取</div>
          </el-form-item>
        </div>

        <el-form-item label="小程序验证token:" prop="shopMaToken">
          <el-input v-model="form.shopMaToken" placeholder="请输入小程序验证token"></el-input>
          <div class="tips">在微信公众号后台->开发管理->开发设置->消息推送中获取</div>
        </el-form-item>

        <el-form-item label="小程序EncodingAESKey:" prop="shopMaEnsodingeskey">
          <el-input v-model="form.shopMaEnsodingeskey" placeholder="请输入小程序EncodingAESKey"></el-input>
          <div class="tips">在微信公众号后台->开发管理->开发设置->消息推送中获取</div>
        </el-form-item>

        <el-form-item label="URL服务器地址:" prop="shopMaApi">
          <el-input v-model="form.shopMaApi" disabled placeholder="这是一段固定的服务器地址，不可更改"></el-input>
          <el-button class="copy-btn ml10" type="primary" :data-clipboard-text="form.shopMaApi">复制</el-button>
          <div class="tips">
            将此段内容复制黏贴至微信公众号后台->开发管理->开发设置->消息推送中的【url服务器地址】处
          </div>
        </el-form-item> -->
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  data() {
    return {
      mat: ['p12'],
      merChantSecretCopy: '',
      merChantSecretEditState: false,
      form: {},
      // activeNumber: '',
      rules: {
        // miniAppId: [{ required: true, message: '必填项', trigger: 'blur' }],
        // miniSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        // wxAppletOriginalId: [{ required: true, message: '必填项', trigger: 'blur' }],
        // miniMaToken: [{ required: true, message: '必填项', trigger: 'blur' }],
        // miniMaEncodingaeskey: [{ required: true, message: '必填项', trigger: 'blur' }],
      },
      // dataList: [
      //   {
      //     element: '#step1',
      //     popover: {
      //       title: "<div style='display:none'></div>",
      //       description:
      //         '<div>1、请于此处填写商户名称，您可前往<微信支付后台—账号中心—个人信息>中获取查看。  <a style="color:var(--color)" href="https://pay.weixin.qq.com/index.php/core/account/info" target="_blank">点击前往 >></a></div>',
      //       position: 'top-center',
      //       className: 'step_none',
      //     },
      //     onPrevious: () => {
      //       this.$driver.preventMove()
      //     },
      //   },
      //   {
      //     element: '#step2',
      //     popover: {
      //       title: "<div style='display:none'></div>",
      //       description:
      //         '<div>2、请于此处填写商户号，您可前往<微信支付后台—账号中心—个人信息>中获取查看。  <a style="color:var(--color)" href="https://pay.weixin.qq.com/index.php/core/account/info" target="_blank">点击前往 >></a></div>',
      //       position: 'bottom-center',
      //     },
      //   },
      //   {
      //     element: '#step3',
      //     popover: {
      //       title: "<div style='display:none'></div>",
      //       description:
      //         '<div>3、请于此处填写商户支付Secret，您可前往<微信支付后台—账号中心—API安全>中获取查看。  <a style="color:var(--color)" href="https://pay.weixin.qq.com/index.php/core/cert/api_cert#/" target="_blank">点击前往 >></a></div>',
      //       position: 'bottom-center',
      //     },
      //   },
      //   {
      //     element: '#step4',
      //     popover: {
      //       title: "<div style='display:none'></div>",
      //       description:
      //         '<div>4、请于此处上传API证书文件，您可前往<微信支付后台—账号中心—账户设置—API安全>中获取查看。  <a style="color:var(--color)" href="https://pay.weixin.qq.com/index.php/core/cert/api_cert#/" target="_blank">点击前往 >></a></div>',
      //       position: 'bottom-center',
      //     },
      //   },
      //   {
      //     element: '#step5',
      //     doneBtnText: '下一步',
      //     popover: {
      //       title: "<div style='display:none'></div>",
      //       description: '5、填写完成后请于此处点击< 保存配置 >按钮并点击完成按钮。',
      //       position: 'top-center',
      //     },
      //     onNext: (ele) => {
      //       sessionStorage.setItem('currentActive', '2')
      //       this.$emit('getActive', '2')
      //     },
      //   },
      //   {
      //     element: '#item1',
      //     popover: {
      //       title: '',
      //       description:
      //         '<div>6、请于此处填写公众号ID，您可前往<公众号后台—设置与开发—基本配置>中获取查看。  <a style="color:var(--color)" href="https://mp.weixin.qq.com/advanced/advanced?action=dev&t=advanced/dev&token=603419011&lang=zh_CN" target="_blank">点击前往 >></a></div>',
      //       position: 'bottom-center',
      //     },
      //   },
      // ],
    }
  },
  watch: {
    data: 'setData',
    // currentActive() {
    //   if (sessionStorage.getItem('currentActive') && this.currentActive === '4') {
    //     this.$driver.defineSteps(this.dataList)
    //     this.$driver.start(4)
    //   }
    // },
    // part4Number() {
    //   this.activeNumber = '2'
    // },
  },
  props: {
    data: {
      type: Object,
      default: {},
    },
    // currentActive: {
    //   type: String,
    // },
    // part4Number: {
    //   type: String,
    // },
  },
  created() {
    // this.activeNumber = sessionStorage.getItem('currentActive')
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
    // if (sessionStorage.getItem('currentActive') === '4') {
    //   this.$driver.defineSteps(this.dataList)
    //   this.$driver.start()
    // }
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    // editMerChantSecret() {
    //   this.merChantSecretEditState = true
    //   this.merChantSecretCopy = JSON.parse(JSON.stringify(this.form.merChantSecret))
    //   this.form.merChantSecret = ''
    // },
    // cancelEditMerChantSecret() {
    //   this.merChantSecretEditState = false
    //   this.form.merChantSecret = JSON.parse(JSON.stringify(this.merChantSecretCopy))
    // },
    // submitEditMerChantSecret() {
    //   if (this.form.merChantSecret) {
    //     this.$emit('submit', this.form)
    //     this.merChantSecretEditState = false
    //   }
    // },
    submit() {
      this.$refs['form'].validate((validate) => {
        if (validate) {
          this.$emit('submit', this.form)
        }
      })
    },
    setData() {
      if (Object.keys(this.data).length) {
        this.form = JSON.parse(JSON.stringify(this.data))
      }
    },
  },
}
</script>
<style lang="scss">
div.step_none#driver-popover-item {
  div.driver-popover-footer {
    span.driver-navigation-btns {
      button.driver-prev-btn {
        opacity: 0;
        cursor: default !important;
        display: none;
      }
    }
  }
}
div#driver-popover-item {
  div.driver-popover-footer {
    button.driver-close-btn {
      display: none; //隐藏关闭按钮
    }
    .driver-btn-group {
      button.driver-disabled {
        // display: none !important;
        color: var(--font-black);
        border: 1px solid #d4d4d4;
        cursor: pointer !important;
        pointer-events: auto !important;
      }
    }
  }
}
div#driver-page-overlay {
  opacity: 1 !important;
  background: var(--bg-black-3) !important;
}
div#driver-highlighted-element-stage {
  border-radius: 8px !important;
}
</style>
<style lang="scss" scoped>
#step1 {
  width: 100%;
  height: 120px;
  overflow: hidden;
  .el-form-item {
    width: 80%;
  }
}
// .driver-highlighted-element {
//   pointer-events: none;
// }
// ::v-deep.scoped-class .driver-close-btn {
//   visibility: hidden;
// }
.tips {
  color: var(--font-black-7);
  font-size: 12px;
}
</style>
