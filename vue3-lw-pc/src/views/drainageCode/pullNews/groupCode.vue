<script>
export default {
  props: {
    // 实际群活码
    groupCodeId: {
      type: String,
      default: '',
    },
    query: {
      type: Object,
      default: {
        imgUrl: '',
      },
    },
    groupCode: {
      type: Object,
      default: {},
    },
  },
  data() {
    return {
      // groupCode: null,
      clipboard: null,
    }
  },
  watch: {
    query: {
      handler(val) {},
      immediate: true,
    },
  },
  computed: {
    // codeUrl() {
    //   return this.groupCode ? this.groupCode.codeUrl : ''
    // },
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('#copyUrl')
  },
  created() {
    // this.getGroupDetail()
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    // 获取群活码信息
    // getGroupDetail() {
    //   if (!this.groupCodeId) return
    //   this.groupCode = this.data
    // },
    transInfo() {
      this.$emit('getGroupCode', this.groupCode)
    },
    // 下载
    handleDownload(url, name) {
      let image = new Image()
      image.setAttribute('crossOrigin', 'anonymous')
      image.src = url
      image.onload = () => {
        let canvas = document.createElement('canvas')
        canvas.width = image.width
        canvas.height = image.height
        let ctx = canvas.getContext('2d')
        ctx.drawImage(image, 0, 0, image.width, image.height)
        canvas.toBlob((blob) => {
          let url = URL.createObjectURL(blob)
          let Link = document.createElement('a')
          Link.download = name
          Link.href = url
          Link.click()
          Link.remove()
          // 用完释放URL对象
          URL.revokeObjectURL(url)
        })
      }
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
      <div class="code-text">拉新活码创建成功，支持复制二维码链接或直接下载</div>
      <el-image :src="query.imageUrl" class="code-image" style="width: 160px; height: 200px"></el-image>
      <div class="code-actions">
        <el-button id="copyUrl" :data-clipboard-text="query.linkPath">复制链接</el-button>
        <el-button type="primary" @click="handleDownload(query.imageUrl, query.qrName)">下载二维码</el-button>
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
