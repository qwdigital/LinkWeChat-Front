<script>
import { getDetail, download } from '@/api/drainageCode/group'

export default {
  props: {
    // 实际群活码
    groupCodeId: {
      type: String,
      default: '',
    },
    data: {
      type: Object,
      default: {
        codeUrl: '',
      },
    },
  },
  data() {
    return {
      groupCode: null,
      clipboard: null,
    }
  },
  computed: {
    codeUrl() {
      return this.groupCode ? this.groupCode.codeUrl : ''
    },
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('#copyUrl')
  },
  created() {
    this.getGroupDetail()
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    // 获取群活码信息
    getGroupDetail() {
      if (!this.groupCodeId) return
      this.groupCode = this.data
    },
    // 下载
    handleDownload() {
      if (!this.groupCode) return
      const name = this.groupCode.activityName + '.png'
      download(this.groupCode.id).then((res) => {
        if (res != null) {
          let blob = new Blob([res], { type: 'application/zip' })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = name // 重命名文件
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
  },
}
</script>

<template>
  <div class="page">
    <div class="code-wrapper">
      <div class="code-success">
        <el-button type="success" icon="el-icon-check" circle></el-button>
      </div>
      <div class="code-text">群活码创建成功，支持复制二维码链接或直接下载</div>
      <el-image :src="codeUrl" class="code-image" style="width: 160px; height: 200px"></el-image>
      <div class="code-actions">
        <el-button id="copyUrl" text :data-clipboard-text="codeUrl">复制链接</el-button>
        <el-button text @click="handleDownload()">下载二维码</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.code-wrapper {
  text-align: center;

  .code-success,
  .code-text,
  .code-image,
  .code-actions {
    padding: 20px 0;
  }
}
</style>
