<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="130px">
      <div class="g-card">
        <div class="my-title">企微直播</div>
        <el-form-item label="直播Secret:" prop="liveSecret">
          <div>
            <el-input
              style="width: 40%"
              :disabled="!liveSecretEditState"
              :type="liveSecretEditState ? 'text' : 'password'"
              v-model="form.liveSecret"
              placeholder="请输入直播Secret"></el-input>
            <el-button style="margin-left: 20px" plain v-if="liveSecretEditState" @click="cancelEditKfSecret">
              取消
            </el-button>
            <el-button type="primary" plain v-if="liveSecretEditState" @click="submitEditKfSecret">保存</el-button>
            <el-button type="primary" style="margin-left: 20px" plain v-if="!liveSecretEditState" @click="editKfSecret">
              修改
            </el-button>
          </div>
          <div class="tips">用于通过API管理直播，在企微后台->应用管理->直播中获取</div>
        </el-form-item>
      </div>
    </el-form>
  </div>
</template>
<script>
export default {
  name: 'enterprise-wechat-part3',
  data() {
    return {
      liveSecretCopy: '',
      liveSecretEditState: false,
      form: {},
      rules: {
        liveSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
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
      this.liveSecretEditState = true
      this.liveSecretCopy = JSON.parse(JSON.stringify(this.form.liveSecret))
      this.form.liveSecret = ''
    },
    cancelEditKfSecret() {
      this.liveSecretEditState = false
      this.form.liveSecret = JSON.parse(JSON.stringify(this.liveSecretCopy))
    },
    submitEditKfSecret() {
      if (this.form.liveSecret) {
        this.$emit('submit', this.form)
        this.liveSecretEditState = false
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
