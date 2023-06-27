<template>
  <div>
    <el-dialog width="auto" :close-on-click-modal="false" :show-close="false" title="批量导入" v-model="dialogVisible">
      <div class="download_template">
        <span>请下载门店模板，按格式修改后导入</span>
        <el-button text plain @click="downloadFn">下载模板</el-button>
      </div>
      <div class="upload_content">
        <el-upload
          drag
          accept=".xls, .xlsx"
          :action="actionUrl"
          :limit="1"
          :headers="headers"
          ref="upload"
          :on-remove="handleRemove"
          :on-change="setFileData"
          :auto-upload="false"
          :on-exceed="handlerExceed">
          <el-icon-upload class="el-icon-upload"></el-icon-upload>
          <div style="font-size: 12px">
            将文件拖拽到此区域
            <p style="margin: 3px 0">仅支持xls、xlsx格式文件</p>
            <el-button type="primary" plain>上传文件</el-button>
          </div>
        </el-upload>
      </div>
      <div class="tip">
        <div class="title">填写说明</div>
        <div style="margin-bottom: 3px">1、门店名称、所属地区、门店地址必填；</div>
        <div style="margin-bottom: 3px">2、门店名称不可重复，重复则自动过滤；</div>
        <div>3、所属地区请务必按照“xxx省xxx市xxx区/县”格式填写。</div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click=";(dialogVisible = false), (file = '')">取 消</el-button>
          <el-button type="primary" @click="submitImport" v-loading="submitLoading">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>
<script>
import { download, toFormData } from '@/utils/common'
import { downloadTemplate, uploadStore } from '@/api/drainageCode/store'
export default {
  name: 'import-store',
  data() {
    return {
      headers: window.lwConfig.headers,
      submitLoading: false,
      actionUrl: '',
      file: '',
    }
  },
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    dialogVisible: {
      get() {
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
  },
  methods: {
    handlerExceed() {
      this.msgError('上传文件个数最大为1，请选择拖拽一份文件或删除已存在文件！')
    },
    submitImport() {
      if (!this.file) {
        this.msgInfo('请先上传文件！')
        return false
      }
      uploadStore(toFormData({ file: this.file })).then((res) => {
        if (res.code === 200) {
          this.msgSuccess(res.data)
          this.dialogVisible = false
          this.$emit('update')
        }
      })
    },
    handleRemove() {},
    setFileData(f, fl) {
      this.file = f.raw
    },
    downloadFn() {
      downloadTemplate().then((res) => {
        if (res != null) {
          let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = '门店模板.xlsx' //指定下载文件名
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
  },
  created() {},
}
</script>
<style lang="scss" scoped>
.download_template {
  padding: 5px 20px;
  // color: #ebb563;
  background-color: var(--bg-black-9);
  border-radius: 4px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.upload_content {
  margin-top: 10px;
  text-align: center;
  ::v-deep .el-upload-dragger {
    width: 460px;
    .el-icon-upload {
      margin: 20px 0 16px;
    }
  }
}
.tip {
  padding: 5px 20px;
  margin-top: 10px;
  font-size: 12px;
  color: var(--font-black-6);
  .title {
    margin-bottom: 10px;
    font-size: 14px;
  }
}
</style>
