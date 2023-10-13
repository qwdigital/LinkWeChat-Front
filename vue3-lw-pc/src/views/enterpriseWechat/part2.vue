<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="130px">
      <div class="g-card">
        <div class="my-title">自建应用</div>
        <el-form-item label="消息应用ID:" prop="agentId">
          <el-input style="width: 40%" v-model="form.agentId" placeholder="请输入消息应用ID"></el-input>
          <div class="tips">用于接收应用消息，在企微后台->应用工具->自建应用中配置并获取</div>
        </el-form-item>
        <el-form-item label="消息应用Secret:" prop="agentSecret">
          <div>
            <el-input
              style="width: 40%"
              :disabled="!agentSecretEditState"
              :type="agentSecretEditState ? 'text' : 'password'"
              v-model="form.agentSecret"
              placeholder="请输入消息应用Secret"></el-input>
            <el-button style="margin-left: 20px" plain v-if="agentSecretEditState" @click="cancelEditAgentSecret">
              取消
            </el-button>
            <el-button type="primary" plain v-if="agentSecretEditState" @click="submitEditAgentSecret">保存</el-button>
            <el-button
              type="primary"
              style="margin-left: 20px"
              plain
              v-if="!agentSecretEditState"
              @click="editAgentSecret">
              修改
            </el-button>
          </div>
          <div class="tips">用于接收应用消息，在企微后台->应用工具->自建应用中配置并获取</div>
        </el-form-item>
      </div>
      <div class="g-card">
        <div class="my-title">会话存档</div>
        <el-form-item label="会话存档Secret:" prop="chatSecret">
          <div>
            <el-input
              style="width: 40%"
              :disabled="!chatSecretEditState"
              :type="chatSecretEditState ? 'text' : 'password'"
              v-model="form.chatSecret"
              placeholder="请输入会话存档Secret"></el-input>
            <el-button style="margin-left: 20px" plain v-if="chatSecretEditState" @click="cancelEditChatSecret">
              取消
            </el-button>
            <el-button type="primary" plain v-if="chatSecretEditState" @click="submitEditChatSecret">保存</el-button>
            <el-button
              type="primary"
              style="margin-left: 20px"
              plain
              v-if="!chatSecretEditState"
              @click="editChatSecret">
              修改
            </el-button>
          </div>
          <div class="tips">用于同步企微会话，在企微后台->管理工具->会话存档中获取</div>
        </el-form-item>
        <el-form-item label="消息加密私钥:" prop="financePrivateKey">
          <el-input
            style="width: 40%"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 6 }"
            v-model="form.financePrivateKey"
            placeholder="请输入消息加密私钥"></el-input>
          <div class="tips">用于同步企微会话，在企微后台->管理工具->会话存档中获取</div>
        </el-form-item>
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  name: 'enterprise-wechat-part2',
  data() {
    return {
      agentSecretCopy: '',
      agentSecretEditState: false,
      chatSecretCopy: '',
      chatSecretEditState: false,
      form: {},
      rules: {
        agentId: [{ required: true, message: '必填项', trigger: 'blur' }],
        agentSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        chatSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        financePrivateKey: [{ required: true, message: '必填项', trigger: 'blur' }],
        // seasRedirectUrl: [{ required: true, message: '必填项', trigger: 'blur' }],
        // sopTagRedirectUrl: [{ required: true, message: '必填项', trigger: 'blur' }]
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
    editAgentSecret() {
      this.agentSecretEditState = true
      this.agentSecretCopy = JSON.parse(JSON.stringify(this.form.agentSecret))
      this.form.agentSecret = ''
    },
    cancelEditAgentSecret() {
      this.agentSecretEditState = false
      this.form.agentSecret = JSON.parse(JSON.stringify(this.agentSecretCopy))
    },
    submitEditAgentSecret() {
      if (this.form.agentSecret) {
        this.$emit('submit', this.form)
        this.agentSecretEditState = false
      }
    },
    editChatSecret() {
      this.chatSecretEditState = true
      this.chatSecretCopy = JSON.parse(JSON.stringify(this.form.chatSecret))
      this.form.chatSecret = ''
    },
    cancelEditChatSecret() {
      this.chatSecretEditState = false
      this.form.chatSecret = JSON.parse(JSON.stringify(this.chatSecretCopy))
    },
    submitEditChatSecret() {
      if (this.form.chatSecret) {
        this.$emit('submit', this.form)
        this.chatSecretEditState = false
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
