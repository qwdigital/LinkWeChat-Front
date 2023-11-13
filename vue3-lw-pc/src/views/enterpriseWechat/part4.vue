<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="130px">
      <div class="g-card">
        <div class="my-title">微信支付</div>
        <el-form-item label="商户名称:" prop="merChantName">
          <el-input v-model="form.merChantName" placeholder="请输入"></el-input>
          <!-- <div class="tips"></div> -->
        </el-form-item>
        <el-form-item label="商户号:" prop="merChantNumber">
          <el-input v-model="form.merChantNumber" placeholder="请输入"></el-input>
          <div class="tips">用于通过API支付商户，在微信支付后台->账号中心->个人信息中获取</div>
        </el-form-item>
        <el-form-item label="商户支付Secret:" prop="merChantSecret">
          <el-input
            :disabled="!merChantSecretEditState"
            :type="merChantSecretEditState ? 'text' : 'password'"
            v-model="form.merChantSecret"
            placeholder="请输入"></el-input>
          <el-button style="margin-left: 20px" plain v-if="merChantSecretEditState" @click="cancelEditMerChantSecret">
            取消
          </el-button>
          <el-button type="primary" plain v-if="merChantSecretEditState" @click="submitEditMerChantSecret">
            保存
          </el-button>
          <el-button
            type="primary"
            style="margin-left: 20px"
            plain
            v-if="!merChantSecretEditState"
            @click="editMerChantSecret">
            修改
          </el-button>
          <div class="tips">用于通过API进行支付，在微信支付后台->账号中心->API安全中获取</div>
        </el-form-item>
        <el-form-item label="API证书文件" prop="certP12Url">
          <div style="display: flex; align-items: center; width: 200px">
            <div v-if="form.certP12Url">
              <img style="height: 60px; width: 60px" src="../../assets/image/success.png" />
            </div>
            <upload class="image-uploader" v-model:fileUrl="form.certP12Url" :format="mat" type="3">
              <span style="font-size: 14px; color: var(--font-black); margin-left: 20px; break-word: no-warp">
                {{ form.certP12Url ? '重新上传' : '上传' }}
              </span>
            </upload>
          </div>
          <div class="tips">用于校验支付环境，在微信支付后台->账户中心->账户设置->API安全中下载</div>
        </el-form-item>
      </div>
      <div class="g-card">
        <div class="my-title">商品图册</div>
        <el-form-item label="对外收款Secret:" prop="billSecret">
          <el-input v-model="form.billSecret" type="password" placeholder="请输入"></el-input>
          <div class="tips">用于通过API收款，在企微管理后台->应用管理->对外收款API中获取</div>
        </el-form-item>
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  name: 'enterprise-wechat-part4',
  data() {
    return {
      mat: ['p12'],
      merChantSecretCopy: '',
      merChantSecretEditState: false,
      form: {},
      rules: {
        merChantName: [{ required: true, message: '必填项', trigger: 'blur' }],
        merChantNumber: [{ required: true, message: '必填项', trigger: 'blur' }],
        merChantSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        certP12Url: [{ required: true, message: '必填项', trigger: 'blur' }],
        billSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
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
    editMerChantSecret() {
      this.merChantSecretEditState = true
      this.merChantSecretCopy = JSON.parse(JSON.stringify(this.form.merChantSecret))
      this.form.merChantSecret = ''
    },
    cancelEditMerChantSecret() {
      this.merChantSecretEditState = false
      this.form.merChantSecret = JSON.parse(JSON.stringify(this.merChantSecretCopy))
    },
    submitEditMerChantSecret() {
      if (this.form.merChantSecret) {
        this.$emit('submit', this.form)
        this.merChantSecretEditState = false
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
