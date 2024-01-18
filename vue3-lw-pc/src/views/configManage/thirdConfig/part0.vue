<script>
export default {
  name: '',

  props: {
    data: {
      type: Object,
      default: {},
    },
  },
  components: {},
  data() {
    return {
      form: {},
      rules: {
        // miniAppId: [{ required: true, message: '必填项', trigger: 'blur' }],
        // miniSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
        // wxAppletOriginalId: [{ required: true, message: '必填项', trigger: 'blur' }],
        // miniMaToken: [{ required: true, message: '必填项', trigger: 'blur' }],
        // miniMaEncodingaeskey: [{ required: true, message: '必填项', trigger: 'blur' }],
      },
    }
  },
  computed: {},
  watch: {
    data: {
      deep: true,
      immediate: true,
      handler(newData, old) {
        if (Object.keys(newData).length) {
          this.form = newData
        }
      },
    },
  },
  created() {},
  mounted() {},
  methods: {
    // 父级调用
    submit() {
      return this.$refs['form'].validate().then(() => this.form)
    },
  },
}
</script>

<template>
  <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="180px">
    <div class="g-card">
      <div class="g-card-title">AI 大模型</div>

      <el-form-item label="小程序原始ID:" prop="wxAppletOriginalId">
        <el-input v-model="form.wxAppletOriginalId" placeholder="请输入小程序原始ID"></el-input>
        <div class="g-tip">选择后需要点击下方保存配置按钮后生效</div>
      </el-form-item>
    </div>

    <div class="g-card">
      <div class="g-card-title">腾讯混元大模型</div>

      <el-form-item label="APPID:" prop="shopAppId">
        <el-input v-model="form.shopAppId" placeholder="请输入APPID"></el-input>
        <div class="g-tip">腾讯云后台 -> 账号中心 -> 账号信息中获取</div>
      </el-form-item>

      <el-form-item label="SecretID:" prop="shopSecret">
        <el-input v-model="form.shopSecret" placeholder="请输入SecretID"></el-input>
        <div class="g-tip">腾讯云后台 -> 访问管理 -> 访问密钥 -> API 密钥管理中获取</div>
      </el-form-item>

      <el-form-item label="SecretKey:" prop="shopMaEnsodingeskey">
        <el-input v-model="form.shopMaEnsodingeskey" placeholder="请输入SecretKey"></el-input>
        <div class="g-tip">腾讯云后台 -> 访问管理 -> 访问密钥 -> API 密钥管理中获取</div>
      </el-form-item>
    </div>
  </el-form>
</template>

<style lang="scss" scoped></style>
