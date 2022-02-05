<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" size="small" label-width="130px">
      <div class="g-card g-pad20">
        <div class="my-title">
          企业配置
        </div>
        <el-form-item label="企业ID:" prop="corpId">
          <el-input style="width: 40%;" :disabled="form.id" v-model="form.corpId" placeholder=""></el-input>
          <div class="tips">企业ID即CorpID，在企微后台->我的企业中获取</div>
        </el-form-item>
        <el-form-item label="企业名称:" required>
          <el-input style="width: 40%;" v-model="form.companyName" disabled placeholder="企业名称"></el-input>
          <div class="tips">根据企业 ID 配置后回显</div>
        </el-form-item>
      </div>
      <div class="g-card g-pad20">
        <div class="my-title">
          通讯录配置
        </div>
        <el-form-item label="通讯录Secret:" prop="corpSecret">
          <div>
            <el-input style="width: 40%;" type="password" v-model="form.corpSecret" placeholder="请输入通讯录Secret"></el-input>
            <el-button style="margin-left:20px;" plain>取消</el-button>
            <el-button type="primary" plain>保存</el-button>
            <!-- <el-button type="primary" plain v-if="form.corpSecret">修改</el-button> -->
          </div>
          <div class="tips">用于同步企微通讯录，在企微后台->管理工具->通讯录同步中获取</div>
        </el-form-item>
        <el-form-item label="Token:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入Token"></el-input>
        </el-form-item>
        <el-form-item label="EncodingAESKey:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入EncodingAESKey"></el-input>
        </el-form-item>
      </div>
      <div class="g-card g-pad20">
        <div class="my-title">
          客户联系配置
        </div>
        <el-form-item label="客户联系Secret:" prop="contactSecret">
          <div>
            <el-input style="width: 40%;" v-model="form.contactSecret" placeholder="请输入客户联系Secret"></el-input>
            <el-button style="margin-left:20px;" plain>取消</el-button>
            <el-button type="primary" plain>保存</el-button>
            <!-- <el-button type="primary" plain v-if="form.corpSecret">修改</el-button> -->
          </div>
          <div class="tips">用于管理客户和联系客户，在企微后台->客户联系->客户 API中获取</div>
        </el-form-item>
        <el-form-item label="Token:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入Token"></el-input>
        </el-form-item>
        <el-form-item label="EncodingAESKey:" prop="">
          <el-input style="width: 40%;" v-model="form.companyName" placeholder="请输入EncodingAESKey"></el-input>
        </el-form-item>
      </div>
      <el-form-item label="" class="ar">
        <el-button type="primary" @click="submit" v-show="!disabled">保存配置</el-button>
      </el-form-item>
    </el-form>

  </div>
</template>
<script>
  export default {
    name: 'enterprise-wechat-part1',
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