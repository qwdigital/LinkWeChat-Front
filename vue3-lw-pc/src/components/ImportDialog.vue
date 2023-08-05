<template>
  <!--
    导入表格模板弹窗 组件
    由透传属性，可直接使用 el-dialog 的所有props，
    用法示例：<ImportDialog v-model="dialogVisible" title="title"/>
  -->
  <el-dialog width="600px" :close-on-click-modal="false">
    <el-form v-loading="loading" ref="ruleForm" label-width="100px">
      <el-form-item label="选择表格:" style="margin-bottom: 0">
        <div style="display: flex; align-items: center; justify-content: space-between; height: 100%">
          <div>
            <input ref="input" type="file" style="display: none" @change="changeFile" />
            <span v-if="file?.name" style="margin-right: 15px" @click="$refs.input.click()">{{ file?.name }}</span>
            <el-button text @click="$refs.input.click()">
              {{ file?.name ? '重新上传' : '上传表格' }}
            </el-button>
          </div>
          <el-button v-if="downloadTemplateRequest" text @click="downloadTemplate">模版下载</el-button>
        </div>
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="$emit('update:model-value', false)">取消</el-button>
      <el-button :disabled="!file?.name" type="primary" @click="importFile">确定</el-button>
    </template>
  </el-dialog>
</template>

<script>
export default {
  props: {
    // 导入文件格式, eg：xlsx, xls
    format: {
      type: Array,
      default: () => ['xlsx', 'xls'], // xlsx
    },
    // 文件体积限制大小
    maxSize: {
      type: Number,
      default: 50, // 50M
    },
    // 下载模板api
    downloadTemplateRequest: {
      type: Function,
      default: undefined,
    },
    // 导出文件名(需包含后缀名)
    downloadFileName: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      loading: false,
      file: {},
    }
  },
  mounted() {},
  methods: {
    // 下载模板
    downloadTemplate() {
      this.loading = true
      this.downloadTemplateRequest()
        .then((res) => {
          res && this.downloadBlob(res, this.downloadFileName)
        })
        .finally(() => {
          this.loading = false
        })
    },
    changeFile(event) {
      let file = event.target.files[0]
      const isOk = this.checkFile(file)
      if (!isOk) return
      this.file = file
    },
    // 文件校验
    checkFile(file) {
      const { size, name } = file
      const reg = new RegExp(`\\.(${this.format.join('|')})$`, 'ig') // /\.(xlsx|xls)$/ig
      const isXlsx = reg.test(name)
      const isLimit = size / 1024 / 1024 < this.maxSize

      if (!isXlsx) {
        this.msgError(`上传文件只能是 ${this.format.join(',')} 格式!`)
      }
      if (!isLimit) {
        this.msgError(`上传文件大小不能超过 ${this.maxSize}MB!`)
      }
      return isXlsx && isLimit
    },
    // 确认导入事件
    importFile() {
      const isOk = this.checkFile(this.file)
      if (!isOk) return
      this.$emit('confirm', this.$data)
    },
  },
}
</script>

<style lang="scss" scoped></style>
