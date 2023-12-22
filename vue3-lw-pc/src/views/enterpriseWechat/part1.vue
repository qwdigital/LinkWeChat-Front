<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="130px">
      <div class="g-card">
        <div class="my-title">企业配置</div>
        <el-form-item label="企业ID:" prop="corpId">
          <el-input style="width: 40%" v-model="form.corpId" placeholder=""></el-input>
          <div class="tips">企业ID即CorpID，在企微后台->我的企业中获取</div>
        </el-form-item>
        <el-form-item label="企业名称:" prop="companyName" required>
          <el-input style="width: 40%" v-model="form.companyName" placeholder="企业名称"></el-input>
          <!-- <div class="tips">根据企业 ID 配置后回显</div> -->
        </el-form-item>
        <el-form-item label="企业logo" required prop="logoUrl">
          <upload class="image-uploader" v-model:fileUrl="form.logoUrl" type="0"></upload>
          <div class="tips">建议大小 2M 以内，仅支持 png/jpg 等图片类型</div>
        </el-form-item>
      </div>
      <div class="g-card">
        <div class="my-title">通讯录配置</div>
        <el-form-item label="通讯录Secret:" prop="corpSecret">
          <div>
            <el-input
              :disabled="!corpSecretEditState"
              style="width: 40%"
              :type="corpSecretEditState ? 'text' : 'password'"
              v-model="form.corpSecret"
              placeholder="请输入通讯录Secret"></el-input>
            <el-button style="margin-left: 20px" plain v-if="corpSecretEditState" @click="cancelEditCorpSecret">
              取消
            </el-button>
            <el-button type="primary" plain v-if="corpSecretEditState" @click="submitEditCorpSecret">保存</el-button>
            <el-button
              type="primary"
              style="margin-left: 20px"
              plain
              v-if="!corpSecretEditState"
              @click="editCorpSecret">
              修改
            </el-button>
          </div>
          <div class="tips">用于同步企微通讯录，在企微后台->管理工具->通讯录同步中获取</div>
        </el-form-item>
      </div>
      <!-- <div class="g-card">
        <div class="my-title">客户联系配置</div>
        <el-form-item label="客户联系Secret:" prop="contactSecret">
          <div>
            <el-input
              :disabled="!contactSecretEditState"
              style="width: 40%"
              :type="contactSecretEditState ? 'text' : 'password'"
              v-model="form.contactSecret"
              placeholder="请输入客户联系Secret"></el-input>
            <el-button style="margin-left: 20px" plain v-if="contactSecretEditState" @click="cancelEditContactSecret">
              取消
            </el-button>
            <el-button type="primary" plain v-if="contactSecretEditState" @click="submitEditContactSecret">
              保存
            </el-button>
            <el-button
              type="primary"
              style="margin-left: 20px"
              plain
              v-if="!contactSecretEditState"
              @click="editContactSecret">
              修改
            </el-button>
          </div>
          <div class="tips">用于管理客户和联系客户，在企微后台->客户联系->客户 API中获取</div>
        </el-form-item>
      </div> -->
      <div class="g-card">
        <div class="my-title">回调配置</div>
        <el-form-item label="Token:" prop="token">
          <el-input style="width: 40%" v-model="form.token" placeholder="请输入Token"></el-input>
        </el-form-item>
        <el-form-item label="EncodingAESKey:" prop="encodingAesKey">
          <el-input style="width: 40%" v-model="form.encodingAesKey" placeholder="请输入EncodingAESKey"></el-input>
        </el-form-item>
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  name: 'enterprise-wechat-part1',
  data() {
    return {
      corpSecretCopy: '',
      corpSecretEditState: false,
      // contactSecretCopey: '',
      // contactSecretEditState: false,
      form: {},
      rules: {
        corpId: [{ required: true, message: '必填项', trigger: 'blur' }],
        corpSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        companyName: [{ required: true, message: '必填项', trigger: 'blur' }],
        // contactSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        logoUrl: [{ required: true, message: '必填项', trigger: 'blur' }],
        token: [{ required: true, message: '必填项', trigger: 'blur' }],
        encodingAesKey: [{ required: true, message: '必填项', trigger: 'blur' }],
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
    // editContactSecret() {
    //   this.contactSecretEditState = true
    //   this.contactSecretCopy = JSON.parse(JSON.stringify(this.form.contactSecret))
    //   this.form.contactSecret = ''
    // },
    // cancelEditContactSecret() {
    //   this.contactSecretEditState = false
    //   this.form.contactSecret = JSON.parse(JSON.stringify(this.contactSecretCopy))
    // },
    // submitEditContactSecret() {
    //   if (this.form.contactSecret) {
    //     this.$emit('submit', this.form)
    //     this.contactSecretEditState = false
    //   }
    // },

    editCorpSecret() {
      this.corpSecretEditState = true
      this.corpSecretCopy = JSON.parse(JSON.stringify(this.form.corpSecret))
      this.form.corpSecret = ''
    },
    cancelEditCorpSecret() {
      this.corpSecretEditState = false
      this.form.corpSecret = JSON.parse(JSON.stringify(this.corpSecretCopy))
    },
    submitEditCorpSecret() {
      if (this.form.corpSecret) {
        this.$emit('submit', this.form)
        this.corpSecretEditState = false
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
