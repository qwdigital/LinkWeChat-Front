<template>
  <!-- 图片标题与描述 -->
  <div class="cp flex aic">
    <el-image
      style="width: 50px; height: 50px; flex: none"
      :src="objRow.coverUrl"
      fit="fill"
      v-if="objRow.coverUrl"
    ></el-image>
    <div class="icon" v-else-if="objRow.svgName">
      <svg-icon class="icon-style" :icon="objRow.svgName"></svg-icon>
    </div>
    <div class="ml10" :style="{ 'max-width': width }">
      <el-tooltip
        :content="objRow.materialName"
        placement="top"
        :disabled="objRow.materialName ? objRow.materialName.length < titleNum : true"
      >
        <p style="text-align: left">
          {{ coverContent(objRow.materialName, titleNum) }}
        </p>
      </el-tooltip>
      <el-tooltip
        placement="top"
        :disabled="objRow.digest ? objRow.digest.length < contentNum : true"
      >
        <template #content><p style="white-space: pre-line" v-html="objRow.digest"></p></template>
        <p style="color: var(--font-black-7); text-align: left">
          {{ coverContent(objRow.digest, contentNum) }}
        </p>
      </el-tooltip>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    row: {
      type: Object,
      default: {},
    },
    // // 封面图
    // coverUrl: {
    //   type: String,
    //   default: null,
    // },
    // // 标题名称
    // materialName: {
    //   type: String,
    //   default: null,
    // },
    // // 内容或描述
    // digest: {
    //   type: String,
    //   default: null,
    // },
    // 标题超过多少字符。。。展示
    titleNum: {
      type: Number,
      default: 12,
    },
    // 描述超过多少字符。。。展示
    contentNum: {
      type: Number,
      default: 50,
    },
    width: {
      type: String,
      default: '200px',
    },
    // svg图标名称
    // svgName: {
    //   type: String,
    //   default: null,
    // },
  },
  watch: {
    row(val) {
      this.dealData(val)
    },
  },
  data() {
    return {
      objRow: {},
    }
  },
  mounted() {
    this.dealData(this.row)
  },
  methods: {
    // 超过num个。。。展示
    coverContent(str, num) {
      if (str && str.length > num) {
        str = str.substr(0, num) + '...'
      }
      return str
    },
    // 处理列表数据
    dealData(data) {
      this.objRow = JSON.parse(JSON.stringify(data))
      if (this.objRow.mediaType === '9') {
        // 图文
        this.objRow.svgName = 'imgText'
        this.objRow.digest = data.content
      } else if (this.objRow.mediaType === '11') {
        // 小程序
        this.objRow.digest = null
      } else if (this.objRow.mediaType === '12') {
        // 文章
        this.objRow.svgName = 'article'
      } else if (this.objRow.mediaType === '2') {
        // 视频
        this.objRow.svgName = 'pic'
      } else if (this.objRow.mediaType === '3') {
        // 文件
        this.objRow.svgName = this.objRow.materialUrl ? this.filType(this.objRow.materialUrl) : null
      } else if (['5', '0'].includes(this.objRow.mediaType)) {
        // 海报 // 图片
        this.objRow.coverUrl = data.materialUrl
      } else if (this.objRow.mediaType === '4') {
        // 文本
        this.objRow.digest = data.content
      } else if (this.objRow.mediaType === '19') {
        // 外链

        this.objRow.svgName = 'outLine'
        this.objRow.digest = data.content
      }
    },
    // 处理文件类型
    filType(file) {
      let filecontent = JSON.parse(JSON.stringify(file))
      filecontent = filecontent.split('.')
      let type = filecontent[filecontent.length - 1]
      if (type === 'pdf') {
        return 'pdf'
      } else if (['doc', 'docx'].includes(type)) {
        return 'word'
      } else if (['ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
        return 'ppt'
      } else {
        return ''
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.icon-style {
  width: 50px;
  height: 50px;
}
</style>
