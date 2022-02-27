<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" size="small" label-width="130px">
      <div class="g-card g-pad20">
        <div class="my-title">
          微信客服
        </div>
        <el-form-item label="微信客服Secret:" prop="corpSecret">
          <div>
            <el-input style="width: 40%;" type="password" v-model="form.corpSecret" placeholder="请输入微信客服Secret"></el-input>
            <el-button style="margin-left:20px;" plain>取消</el-button>
            <el-button type="primary" plain>保存</el-button>
            <!-- <el-button type="primary" plain v-if="form.corpSecret">修改</el-button> -->
          </div>
          <div class="tips">用于通过API管理客服，在企微后台->应用管理->微信客服中获取</div>
        </el-form-item>
        <el-form-item label="Token:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入Token"></el-input>
          <div class="tips">用于生成签名校验回调请求的合法性</div>

        </el-form-item>
        <el-form-item label="EncodingAESKey:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入EncodingAESKey"></el-input>
          <div class="tips">用于解密回调消息内容对应的密文</div>

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
    name: 'enterprise-wechat-part3',
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