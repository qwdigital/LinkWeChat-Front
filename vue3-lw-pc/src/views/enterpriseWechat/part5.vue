<template>
  <div>
    <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="130px">
      <div class="g-card">
        <div class="my-title">公众号配置</div>
        <div id="item1">
          <el-form-item label="公众号 ID:" prop="wxAppId">
            <el-input style="width: 40%" type="text" v-model="form.wxAppId" placeholder="请输入公众号 ID"></el-input>
            <div class="tips">在公众号后台->设置与开发->基本配置中获取</div>
          </el-form-item>
        </div>
        <div>
          <el-form-item label="公众号 Secret:" prop="wxSecret">
            <div>
              <el-input
                @input="onInput"
                style="width: 40%"
                :disabled="!wxSecretEditState"
                :type="wxSecretEditState ? 'text' : 'password'"
                v-model="form.wxSecret"
                placeholder="请输入公众号 Secret"></el-input>
              <el-button style="margin-left: 20px" plain v-if="wxSecretEditState" @click="cancelEditwxSecret">
                取消
              </el-button>
              <el-button type="primary" plain v-if="wxSecretEditState" @click="submitEditwxSecret">保存</el-button>
              <el-button type="primary" style="margin-left: 20px" plain v-if="!wxSecretEditState" @click="editwxSecret">
                修改
              </el-button>
            </div>
            <div class="tips">在公众号后台->设置与开发->基本配置中获取</div>
          </el-form-item>
        </div>
      </div>
    </el-form>
  </div>
</template>
<script>
// import { string } from 'clipboard'
export default {
  name: 'enterprise-wechat-part5',
  data() {
    return {
      wxSecretCopy: '',
      wxSecretEditState: false,
      form: {},
      rules: {
        wxSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        wxAppId: [{ required: true, message: '必填项', trigger: 'blur' }],
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
    onInput() {
      // this.$forceUpdate()
    },
    editwxSecret() {
      this.wxSecretEditState = true
      if (this.form.wxSecret) {
        this.wxSecretCopy = JSON.parse(JSON.stringify(this.form.wxSecret))
      } else {
        this.wxSecretCopy = ''
      }
      this.form.wxSecret = ''
    },
    cancelEditwxSecret() {
      this.wxSecretEditState = false
      this.form.wxSecret = JSON.parse(JSON.stringify(this.wxSecretCopy))
    },
    submitEditwxSecret() {
      if (this.form.wxSecret) {
        this.$emit('submit', this.form)
        this.wxSecretEditState = false
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
