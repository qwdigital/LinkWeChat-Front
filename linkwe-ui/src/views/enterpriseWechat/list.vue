<template>
  <div>
    <el-tabs v-model="currentActive" align-center>
      <el-tab-pane label="基础配置" name="1">
        <part1 @submit="savePart1" :data="form"></part1>
      </el-tab-pane>
      <el-tab-pane label="应用配置" name="2">
        <part2></part2>
      </el-tab-pane>
      <el-tab-pane label="客服配置" name="3">
        <part3></part3>
      </el-tab-pane>
      <el-tab-pane label="支付配置" name="4">
        <part4></part4>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
  import Part1 from './part1.vue'
  import Part2 from './part2.vue'
  import Part3 from './part3.vue'
  import Part4 from './part4.vue'
  import * as api from '@/api/enterpriseId'
  // import clipboard from "clipboard";
  export default {
    components: {
      Part1,
      Part2,
      Part3,
      Part4
    },
    props: {},
    data () {
      return {
        currentActive: "1",
        form: {},
        disabled: false,
        loading: false,
        rules: Object.freeze({
          // companyName: [{ required: true, message: '必填项', trigger: 'blur' }],
          corpId: [{ required: true, message: '必填项', trigger: 'blur' }],
          corpSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
          agentId: [{ required: true, message: '必填项', trigger: 'blur' }],
          agentSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
          contactSecret: [{ required: true, message: '必填项', trigger: 'blur' }],
          seasRedirectUrl: [{ required: true, message: '必填项', trigger: 'blur' }],
          sopTagRedirectUrl: [{ required: true, message: '必填项', trigger: 'blur' }]
        })
      }
    },
    watch: {},
    computed: {},
    created () {
      this.getDetail()
    },
    mounted () {
    },
    methods: {
      savePart1 (data) {
        api.addOrUpdate(data).then(() => {
          this.msgSuccess('操作成功')
          // this.dialogVisible = false
          this.getDetail()
        })
          .catch(() => {
            // this.dialogVisible = false
          })
      },
      getDetail () {
        this.loading = true
        api.getDetail()
          .then(({ data }) => {
            this.form = data
            this.loading = false
          })
          .catch(() => {
            this.loading = false
          })
      },
      submit () {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            api
              .addOrUpdate(this.form)
              .then(() => {
                this.msgSuccess('操作成功')
                // this.dialogVisible = false
                this.getDetail()
              })
              .catch(() => {
                // this.dialogVisible = false
              })
          }
        })
      },
      start (corpId) {
        api.start(corpId).then(({ rows, total }) => {
          this.msgSuccess('操作成功')
          this.getList()
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .tips {
    color: #aaa;
    font-size: 12px;
  }
</style>
