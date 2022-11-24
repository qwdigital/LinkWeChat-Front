<script>
import { appMsg } from '@/api/internalCollaborate/groupRobot'

export default {
  name: '',
  components: {},
  props: {
    id: {
      type: String | Number,
      required: true,
    },
  },
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        id: this.id,
      },
      total: 0,
      list: [],
      loading: false,

      typeDict: {
        text: '文本',
        image: '图片',
        news: '图文',
        video: '视频',
        file: '文件',
      },
      type: [
        '图片',
        '语音',
        '视频',
        '文件',
        '文本',
        '海报',
        '活码',
        '人群',
        '旅程',
        '图文',
        '链接',
        '小程序',
        '文章',
        '企业话术',
        '客服话术',
      ],
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    getList(page) {
      // if (this.dateRange) {
      //   this.query.beginTime = this.dateRange[0]
      //   this.query.endTime = this.dateRange[1]
      // } else {
      //   this.query.beginTime = ''
      //   this.query.endTime = ''
      // }
      page && (this.query.pageNum = page)
      this.loading = true
      appMsg
        .getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
        })
        .finally(() => {
          this.loading = false
        })
    },
    edit(data, type) {
      this.form = Object.assign({}, data || {})
    },
    removke(id, action, tip) {
      // const operIds = id || this.ids + ''
      this.$confirm('是否确认' + tip + '？该操作不可撤销，请谨慎操作。', {
        title: '警告',
        type: 'warning',
      })
        .then(function () {
          return appMsg[action](id)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
  },
}
</script>

<template>
  <div>
    <el-table v-loading="loading" :data="list">
      <el-table-column label="消息标题" align="center" prop="title" />
      <el-table-column prop="msgType" label="类型" align="center">
        <template slot-scope="{ row }">{{ typeDict[row.msgType] }}</template>
      </el-table-column>
      <el-table-column label="发送时间" align="center" prop="sendTime" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <el-button type="text" @click="edit(row, 'detail')">详情</el-button>
          <!-- v-hasPermi="['customerManage:tag:remove']" -->
        </template>
      </el-table-column>
    </el-table>
    <pagination
      style="text-align: center"
      class="mt20"
      v-show="total > 0"
      :total="total"
      :background="false"
      layout="prev, pager, next"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()" />
  </div>
</template>

<style lang="less" scoped></style>
