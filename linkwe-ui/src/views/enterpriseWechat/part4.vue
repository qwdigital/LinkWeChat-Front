<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" size="small" label-width="130px">
      <div class="g-card g-pad20">
        <div class="my-title">
          微信支付
        </div>
        <el-form-item label="商户号:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入商户号"></el-input>
          <div class="tips">用于通过API支付商户，在微信支付后台->账号中心->个人信息中获取</div>
        </el-form-item>
        <el-form-item label="商户支付Secret:" prop="corpSecret">
          <el-input style="width: 40%;" type="password" v-model="form.corpSecret" placeholder="请输入商户支付Secret"></el-input>
          <div class="tips">用于通过API进行支付，在微信支付后台->账号中心->API安全中获取</div>
        </el-form-item>
      </div>
      <el-form-item label="" class="ar">
        <el-button type="primary" @click="submit">保存配置</el-button>
      </el-form-item>
    </el-form>

  </div>
</template>
<script>
  export default {
    name: 'enterprise-wechat-part4',
    data () {
      return {
        form: {
          corpId: '',
          companyName: '',
          corpSecret: '',
          contactSecret: ''

        },
        rules: {
          corpId: [{ required: true, message: '必填项', trigger: 'blur' }],
          corpSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
          agentId: [{ required: true, message: '必填项', trigger: 'blur' }],
          agentSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
          contactSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
          seasRedirectUrl: [{ required: true, message: '必填项', trigger: 'blur' }],
          sopTagRedirectUrl: [{ required: true, message: '必填项', trigger: 'blur' }]
        }
      }
    },
    methods: {
      submit () {

      }
    },
    mounted () {

    },
    created () {

    }
  }
</script>
<style lang="scss" scoped>
  .my-title {
  }
  .tips {
    color: #aaa;
    font-size: 12px;
  }
</style>