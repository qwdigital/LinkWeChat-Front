<template>
  <div>
    <!-- 话术素材 -->
    <el-dialog
      title="话术素材"
      v-model="dialogVisible"
      width="60%"
      append-to-body
      :close-on-click-modal="false"
      @close="dialogClose">
      <el-table :data="tableData" ref="singleTable" v-loading="loading">
        <!-- <el-table-column type="index" width="50" label="序号" align="center"></el-table-column> -->
        <el-table-column prop="name" align="center" label="素材" width="260">
          <template #default="{ row }">
            <PicTitContent :row="row" />
          </template>
        </el-table-column>
        <el-table-column prop="mediaType" width="50" label="类型" align="center">
          <template #default="{ row }">
            <div>
              {{ deltype(row.mediaType) }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="发送总次数" align="center" prop="sendTotalNum" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.sendTotalNum || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="查看总次数" align="center" prop="viewTotalNum" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.viewTotalNum || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="查看总人数" align="center" prop="viewByTotalNum" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.viewByTotalNum || '-' }}
          </template>
        </el-table-column>

        <el-table-column prop="height" label="操作" align="center">
          <template #default="scope">
            <el-button text v-if="['2', '5', '9'].includes(scope.row.mediaType)">
              <!-- 视频,海报,图文 -->
              <a :href="scope.row.materialUrl" target="_blank">预览</a>
            </el-button>
            <!-- 文件 -->
            <el-button text v-if="scope.row.mediaType == '3'">
              <a :href="$previewFile(scope.row.materialUrl)" target="_blank">预览</a>
            </el-button>
            <!-- 文章 -->
            <el-button text v-if="scope.row.mediaType == '12'" @click="preview(scope.row)">
              <span>预览</span>
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { getLexicalDetail } from '@/api/contentCenter/scriptCenter'
import { string } from 'clipboard'
import PicTitContent from '@/views/contentCenter/components/PicTitContent'
export default {
  components: { PicTitContent },
  props: {
    // 添加标签显隐
    visible: {
      type: Boolean,
      default: false,
    },
    // 表单参数
    query: {
      type: Object,
      default: () => ({
        talkId: '',
      }),
    },
    talkType: {
      type: String,
      default: '',
    },
    //
    resourceType: {
      type: String,
      default: '',
    },
  },
  watch: {
    visible: {
      handler(val) {
        this.dialogVisible = val
        if (this.dialogVisible) {
          this.getList()
        }
      },
      immediate: true,
    },
  },
  data() {
    return {
      loading: false,
      tableData: [],
      dialogVisible: false,
    }
  },
  methods: {
    // filType(file) {
    //   let filecontent = JSON.parse(JSON.stringify(file))
    //   filecontent = filecontent.split('.')
    //   let type = filecontent[filecontent.length - 1]
    //   if (type === 'pdf') {
    //     return 'pdf'
    //   } else if (['doc', 'docx'].includes(type)) {
    //     return 'word'
    //   } else if (['ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
    //     return 'ppt'
    //   } else {
    //     return ''
    //   }
    // },
    preview(row) {
      // let routeData = this.$router.resolve({
      //   path: '/preview',
      //   query: { obj: encodeURIComponent(JSON.stringify(row)) },
      // })
      // window.open(routeData.href, '_blank')
      window.open(window.lwConfig.PRIVIEW_PATH + row.id + '&otherModle=' + true, '_blank')
    },
    deltype(type) {
      switch (type) {
        case '4':
          return '文本'
          break
        case '0':
          return '图片'
          break
        case '9':
          return '图文'
          break
        case '11':
          return '小程序'
          break
        case '12':
          return '文章'
          break
        case '2':
          return '视频'
          break
        case '3':
          return '文件'
          break
        case '5':
          return '海报'
          break
        case '19':
          return '外链'
          break
      }
    },
    // 超过50个。。。展示
    coverContent(str) {
      if (str && str.length > 50) {
        str = str.substr(0, 50) + '...'
      }
      return str
    },
    dialogClose() {
      this.$emit('visibleChange', false)
    },
    getList() {
      let form = {}
      form.talkId = this.query.id
      form.talkType = this.talkType
      form.resourceType = this.resourceType
      getLexicalDetail(form).then((res) => {
        // console.log(res.data)
        this.tableData = res.data
      })
    },
  },
  mounted() {},
}
</script>

<style lang="scss" scoped>
.title {
  width: 80%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: bold;
  color: var(--font-black-7);
  font-size: 12px;
}
.imgsize {
  width: 60px;
  height: 60px;
  margin-right: 10px;
}
</style>
