<template>
  <div>
    <!-- 表格拖拽组件 -->
    <el-table :data="tableData" ref="singleTable" highlight-current-row row-key="id" class="load_table">
      <!-- <el-table-column type="index" width="50" label="序号" align="center"></el-table-column> -->
      <el-table-column label="" width="50" align="left" v-if="dargAble">
        <svg-icon icon="dragIcon" />
      </el-table-column>

      <el-table-column prop="name" label="素材" align="left">
        <template #default="{ row }">
          <el-tooltip
            :content="row.materialName"
            placement="top"
            :disabled="row.materialName ? row.materialName.length < 12 : true">
            <span class="title">{{ coverContent(row.materialName, 12) }}</span>
          </el-tooltip>
          <!-- 文本 -->
          <div v-if="row.mediaType === '4'">
            <el-tooltip placement="top" :disabled="row.content ? row.content.length < 50 : true">
              <template #content><p style="white-space: pre-line" v-html="row.content"></p></template>
              <span class="twosplice">{{ coverContent(row.content, 50) }}</span>
            </el-tooltip>
          </div>
          <!-- 图片 -->
          <div v-if="row.mediaType === '0'">
            <el-image :src="row.materialUrl" fit="contain" class="imgsize"></el-image>
          </div>
          <!-- 图文 -->
          <div v-if="row.mediaType === '9'" style="display: flex">
            <el-image :src="row.coverUrl" fit="contain" class="imgsize" v-if="row.coverUrl"></el-image>
            <div class="icon-style" v-else>
              <svg-icon class="icon-style" icon="imgText"></svg-icon>
            </div>
            <el-tooltip :content="row.content" placement="top" :disabled="row.content ? row.content.length < 50 : true">
              <span class="twosplice distStyle">{{ coverContent(row.content, 50) }}</span>
            </el-tooltip>
          </div>
          <!-- 图文 -->
          <div v-if="row.mediaType === '19'" style="display: flex">
            <el-image :src="row.coverUrl" fit="contain" class="imgsize" v-if="row.coverUrl"></el-image>
            <div class="icon-style" v-else>
              <svg-icon class="icon-style" icon="outLine"></svg-icon>
            </div>
            <el-tooltip :content="row.content" placement="top" :disabled="row.content ? row.content.length < 50 : true">
              <span class="twosplice distStyle">{{ coverContent(row.content, 50) }}</span>
            </el-tooltip>
          </div>
          <!-- 小程序 -->
          <div v-if="row.mediaType === '11'">
            <el-image :src="row.coverUrl" fit="contain" class="imgsize"></el-image>
          </div>
          <!-- 文章 -->
          <div v-if="row.mediaType === '12'" style="display: flex">
            <el-image :src="row.coverUrl" fit="contain" class="imgsize" v-if="row.coverUrl"></el-image>
            <div class="icon-style" v-else>
              <svg-icon class="icon-style" icon="article"></svg-icon>
            </div>
            <el-tooltip :content="row.digest" placement="top" :disabled="row.digest ? row.digest.length < 50 : true">
              <span class="twosplice distStyle">{{ coverContent(row.digest, 50) }}</span>
            </el-tooltip>
          </div>
          <!-- 视频 -->
          <div v-if="row.mediaType === '2'" style="display: flex">
            <el-image :src="row.coverUrl" fit="contain" class="imgsize"></el-image>
            <el-tooltip :content="row.digest" placement="top" :disabled="row.digest ? row.digest.length < 50 : true">
              <span class="twosplice distStyle">{{ coverContent(row.digest, 50) }}</span>
            </el-tooltip>
          </div>
          <!-- 文件 -->
          <div v-if="row.mediaType === '3'" style="display: flex">
            <!-- <el-image :src="row.coverUrl" fit="contain" class="imgsize"></el-image> -->
            <div class="icon-style" v-if="row.materialUrl">
              <svg-icon class="icon-style" :icon="row.materialUrl ? filType(row.materialUrl) : ''"></svg-icon>
            </div>
            <el-tooltip :content="row.digest" placement="top" :disabled="row.digest ? row.digest.length < 50 : true">
              <span class="twosplice distStyle">{{ coverContent(row.digest, 50) }}</span>
            </el-tooltip>
          </div>
          <!-- 海报 -->
          <div v-if="row.mediaType === '5'" style="display: flex">
            <el-image :src="row.materialUrl" fit="contain" class="imgsize"></el-image>
            <el-tooltip :content="row.digest" placement="top" :disabled="row.digest ? row.digest.length < 50 : true">
              <span class="twosplice distStyle">{{ coverContent(row.digest, 50) }}</span>
            </el-tooltip>
          </div>
        </template>
      </el-table-column>

      <el-table-column prop="mediaType" width="" label="类型" align="center">
        <template #default="{ row }">
          <div>
            {{ deltype(row.mediaType) }}
          </div>
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
          <!-- <el-button
            text
            @click="edit(scope.row)"
            v-if="
              scope.row.moduleType != 1 && ['4', '5', '9', '11', '12'].includes(scope.row.mediaType)
            "
            >编辑</el-button
          > -->
          <el-button text @click="edit(scope.row)" v-if="scope.row.moduleType != 1">编辑</el-button>
          <el-button text @click="remove(scope.row.delId)" v-if="!isDeatail">移除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import Sortable from 'sortablejs'
export default {
  props: {
    tableData2: {
      type: Array,
      default: [],
    },
    // 是否可拖拽
    dargAble: {
      type: Boolean,
      default: false,
    },
    // 是否为详情页面
    isDeatail: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      tableData: [],
    }
  },
  watch: {
    tableData2: {
      handler(val) {
        this.tableData = JSON.parse(JSON.stringify(val))
        this.tableData.forEach((item, index) => {
          item.delId = index
        })
      },
      immediate: true,
      deep: true,
    },
  },

  mounted() {
    if (this.dargAble) {
      this.dragSort()
    }
  },

  methods: {
    preview(row) {
      // let routeData = this.$router.resolve({
      //   path: '/preview',
      //   query: { obj: encodeURIComponent(JSON.stringify(row)) },
      // })
      // window.open(routeData.href, '_blank')
      window.open(window.lwConfig.PRIVIEW_PATH + row.id + '&otherModle=' + true, '_blank')
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
    // 编辑
    edit(row) {
      this.$emit('getEdit', row)
    },
    remove(delId) {
      this.tableData = this.tableData.filter((item) => {
        return item.delId != delId
      })
      this.$emit('setData', this.tableData)
    },
    // 超过50个。。。展示
    // coverContent(str) {
    //   if (str && str.length > 50) {
    //     str = str.substr(0, 50) + '...'
    //   }
    //   return str
    // },
    // 超过num个。。。展示
    coverContent(str, num) {
      if (str && str.length > num) {
        str = str.substr(0, num) + '...'
      }
      return str
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
    //表格拖动排序
    dragSort() {
      const el = this.$refs.singleTable.$el.querySelectorAll('.el-table__body-wrapper  table > tbody')[0]

      this.sortable = Sortable.create(el, {
        ghostClass: 'sortable-ghost',

        setData: function (dataTransfer) {
          dataTransfer.setData('Text', '')
        },

        onEnd: (e) => {
          //e.oldIndex为拖动一行原来的位置，e.newIndex为拖动后新的位置

          const targetRow = this.tableData.splice(e.oldIndex, 1)[0]

          this.tableData.splice(e.newIndex, 0, targetRow)

          // console.log(this.tableData, '排序后的数据')
          this.$emit('setData', this.tableData)

          let dragId = this.tableData[e.newIndex].id //拖动行的id

          let oneId, twoId

          //拖动行的前一行

          if (this.tableData[e.newIndex - 1]) {
            oneId = this.tableData[e.newIndex - 1].id
          } else {
            oneId = ''
          }

          //拖动行的后一行

          if (this.tableData[e.newIndex + 1]) {
            twoId = this.tableData[e.newIndex + 1].id
          } else {
            twoId = ''
          }

          console.log(dragId, oneId, twoId)
          // debugger
          // this.postRequest({
          //   url: this.dragUrl,

          //   data: {
          //     dragId: dragId,

          //     oneId: oneId,

          //     twoId: twoId,

          //     projectId: '',
          //   },

          //   success: (result) => {
          //     if (result) {
          //       this.$message({
          //         message: '拖动排序成功!',

          //         type: 'success',
          //       })
          //     } else {
          //       this.$message({
          //         message: '拖动排序失败！',

          //         type: 'error',
          //       })
          //     }
          //   },
          // })
        },
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.icon-style {
  width: 50px;
  height: 50px;
  align-items: center;
}
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
  width: 50px;
  height: 50px;
  margin-right: 10px;
}
.distStyle {
  align-items: center;
  margin-left: 10px;
}
</style>
