<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="130px">
      <div class="g-card">
        <div class="my-title">微信客服</div>
        <el-form-item label="微信客服Secret:" prop="kfSecret">
          <div>
            <el-input
              style="width: 40%"
              :disabled="!kfSecretEditState"
              :type="kfSecretEditState ? 'text' : 'password'"
              v-model="form.kfSecret"
              placeholder="请输入微信客服Secret"></el-input>
            <el-button style="margin-left: 20px" plain v-if="kfSecretEditState" @click="cancelEditKfSecret">
              取消
            </el-button>
            <el-button type="primary" plain v-if="kfSecretEditState" @click="submitEditKfSecret">保存</el-button>
            <el-button type="primary" style="margin-left: 20px" plain v-if="!kfSecretEditState" @click="editKfSecret">
              修改
            </el-button>
          </div>
          <div class="tips">用于通过API管理客服，在企微后台->应用管理->微信客服中获取</div>
        </el-form-item>
        <!-- <el-form-item label="Token:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入Token"></el-input>
          <div class="tips">用于生成签名校验回调请求的合法性</div>
        </el-form-item>
        <el-form-item label="EncodingAESKey:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入EncodingAESKey"></el-input>
          <div class="tips">用于解密回调消息内容对应的密文</div>

        </el-form-item> -->
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  name: 'enterprise-wechat-part3',
  data() {
    return {
      kfSecretCopy: '',
      kfSecretEditState: false,
      form: {},
      rules: {
        kfSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
      },
    }
  },
  watch: {
    data: 'setData',
  },
  props: {
    data: {
      type: Object,
      default: {},
    },
  },
  methods: {
    editKfSecret() {
      this.kfSecretEditState = true
      this.kfSecretCopy = JSON.parse(JSON.stringify(this.form.kfSecret))
      this.form.kfSecret = ''
    },
    cancelEditKfSecret() {
      this.kfSecretEditState = false
      this.form.kfSecret = JSON.parse(JSON.stringify(this.kfSecretCopy))
    },
    submitEditKfSecret() {
      if (this.form.kfSecret) {
        this.$emit('submit', this.form)
        this.kfSecretEditState = false
      }
    },
    submit() {
      this.$refs['form'].validate((validate) => {
        if (validate) {
          this.$emit('submit', this.form)
        }
      })
    },
    setData() {
      console.log(this.data)
      if (Object.keys(this.data).length) {
        this.form = this.data
      }
    },
  },
  mounted() {},
  created() {},
}
</script>
<style lang="scss" scoped>
.my-title {
}
.tips {
  color: var(--font-black-7);
  font-size: 12px;
}
</style>
