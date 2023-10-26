<template>
  <div>
    <!--话术中心的数据明细  -->
    <div class="margin-top: 10px;">
      <el-table :data="tableList" style="width: 100%">
        <el-table-column prop="name" label="素材" align="left">
          <template #default="{ row }">
            <span class="title">{{ row.materialName }}</span>
            <!-- 文本 -->
            <div v-if="row.mediaType === '4'">
              <span class="twosplice">{{ coverContent(row.content) }}</span>
            </div>
            <!-- 图片 -->
            <div v-if="row.mediaType === '0'">
              <el-image :src="row.materialUrl" fit="contain" class="imgsize"></el-image>
            </div>
            <!-- 图文 -->
            <div v-if="row.mediaType === '9'" style="display: flex">
              <el-image v-if="row.coverUrl" :src="row.coverUrl" fit="contain" class="imgsize"></el-image>
              <div class="icon-style" v-else>
                <svg-icon class="icon-style" icon="imgText"></svg-icon>
              </div>
              <span class="twosplice mt10">{{ coverContent(row.content) }}</span>
            </div>
            <!-- 小程序 -->
            <div v-if="row.mediaType === '11'">
              <el-image :src="row.coverUrl" fit="contain" class="imgsize"></el-image>
            </div>
            <!-- 文章 -->
            <div v-if="row.mediaType === '12'" style="display: flex">
              <el-image v-if="row.coverUrl" :src="row.coverUrl" fit="contain" class="imgsize"></el-image>
              <div class="icon-style" v-else>
                <svg-icon class="icon-style" icon="article"></svg-icon>
              </div>
              <span class="twosplice mt10">{{ coverContent(row.digest) }}</span>
            </div>
            <!-- 视频 -->
            <div v-if="row.mediaType === '2'" style="display: flex">
              <el-image :src="row.coverUrl" fit="contain" class="imgsize"></el-image>
              <span class="twosplice mt10">{{ coverContent(row.digest) }}</span>
            </div>
            <!-- 文件 -->
            <div v-if="row.mediaType === '3'" style="display: flex">
              <!-- <el-image :src="row.coverUrl" fit="contain" class="imgsize"></el-image> -->
              <svg-icon
                class="icon-style"
                :icon="row.materialUrl ? filType(row.materialUrl) : ''"
                v-if="row.materialUrl"></svg-icon>
              <span class="twosplice mt10">{{ coverContent(row.digest) }}</span>
            </div>
            <!-- 海报 -->
            <div v-if="row.mediaType === '5'" style="display: flex">
              <el-image :src="row.materialUrl" fit="contain" class="imgsize"></el-image>
              <span class="twosplice mt10">{{ coverContent(row.digest) }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="mediaType" width="50" label="类型" align="center">
          <template #default="{ row }">
            <div>
              {{ deltype(row.mediaType) }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="发送次数" align="center" prop="sendTotalNum" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="scriptNum" @click="sendNum(row)">
              {{ row.sendTotalNum }}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="查看人数" align="center" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="scriptNum" @click="viewNum(row)">
              {{ row.viewByTotalNum }}
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="bottom">
        <!-- <pagination
          :total="total"
           v-model:page="query.pageNum"
           v-model:limit="query.pageSize"
          @pagination="getTableChangeSize()"
        /> -->
      </div>
    </div>
    <el-dialog
      :title="send ? '发送明细' : '查看明细'"
      v-model="dialogVisible"
      :close-on-click-modal="false"
      width="60%">
      <el-table v-loading="loading" :data="detailList" style="width: 100%">
        <!-- 发送明细 -->
        <template v-if="send">
          <el-table-column prop="sendBy" label="发送员工" align="center" min-width="100" />
          <el-table-column prop="sendTotalNum" label="发送次数" align="center" min-width="100" />
        </template>
        <!-- 查看明细 -->
        <template v-else>
          <el-table-column label="查看用户" align="center" min-width="100" prop="viewBy" show-overflow-tooltip>
            <template #default="scope">
              <el-image
                :src="scope.row.viewAvatar"
                fit="contain"
                class="imgsize"
                v-if="scope.row.viewAvatar"></el-image>
              {{ scope.row.viewBy }}
            </template>
          </el-table-column>
          <el-table-column label="是否是企业客户" align="center" min-width="100" show-overflow-tooltip>
            <template #default="scope">
              {{ scope.row.isCustomer === 1 ? '是' : '否' }}
            </template>
          </el-table-column>

          <el-table-column label="查看次数" align="center" min-width="100" prop="viewTotalNum" show-overflow-tooltip />
          <el-table-column
            label="查看时长"
            align="center"
            min-width="100"
            prop="viewDurationCpt"
            show-overflow-tooltip />
          <el-table-column label="操作" align="center">
            <template #default="scope">
              <el-button text @click="goDetail(scope.row)" v-if="scope.row.isCustomer">客户详情</el-button>
            </template>
          </el-table-column>
        </template>
      </el-table>
      <div class="bottom">
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getTableChangeSize()" />
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getTableDetail } from '@/api/contentCenter/common.js'
export default {
  data() {
    return {
      dialogVisible: false,
      detailList: [], // 发送/查看明细
      send: true,
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      total: 0,
      loading: false,
    }
  },
  props: {
    timeObj: {
      type: Object,
      default: {
        beginTime: '',
        endTime: '',
      },
    },
    tableList: {
      type: Array,
      default: [],
    },
    // 1素材中心 2企业话术 3客服话术
    resourceType: {
      type: Number,
      default: null,
    },
  },
  methods: {
    // 查看人数
    viewNum(row) {
      this.dialogVisible = true
      this.query.detailsType = 2
      this.query.contentId = row.id
      this.query.talkId = row.talkId
      this.query.beginTime = this.timeObj.beginTime
      this.query.endTime = this.timeObj.endTime
      this.detailList = []
      this.getTableChangeSize()
      this.send = false
    },
    // 发送人数
    sendNum(row) {
      this.send = true
      this.dialogVisible = true
      this.query.detailsType = 1
      this.query.contentId = row.id
      this.query.talkId = row.talkId
      this.query.beginTime = this.timeObj.beginTime
      this.query.endTime = this.timeObj.endTime
      this.detailList = []
      this.getTableChangeSize()
    },
    getTableChangeSize() {
      this.loading = true
      this.query.resourceType = this.resourceType
      getTableDetail(this.query).then((res) => {
        this.detailList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    goDetail(row) {
      let { externalUserid, firstUserId: userId } = row
      this.$router.push({
        name: window.lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
        query: { externalUserid, userId },
      })
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
    // 超过50个。。。展示
    coverContent(str) {
      if (str && str.length > 50) {
        str = str.substr(0, 50) + '...'
      }
      return str
    },
  },
}
</script>

<style lang="scss" scoped>
.icon-style {
  width: 50px;
  height: 50px;
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
.scriptNum {
  font-size: 14px;
  color: var(--color);
  cursor: pointer;
}
</style>
