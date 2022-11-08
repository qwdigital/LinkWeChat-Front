<script>
import { appMsg } from '@/api/internalCollaborate/groupRobot'

export default {
  name: '',
  components: {},
  props: {
    id: {
      type: String,
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

      dialogVisibleHistoryMsg: false,
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
        .then(({ data, total }) => {
          this.list = data
          this.total = +total
        })
        .finally(() => {
          this.loading = false
        })
    },
    edit(data, type) {
      this.form = Object.assign({}, data || {})
      this.dialogVisible = true
      type || !data ? (this.disabled = false) : (this.disabled = true)
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
      <el-table-column prop="type" label="类型" align="center">
        <template slot-scope="{ row }">{{ type[row.type] }}</template>
      </el-table-column>
      <el-table-column label="发送时间" align="center" prop="groupName" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="{ row }">
          <!-- <el-button type="text" @click="edit(row, 'detail')">详情</el-button>
          <el-button v-if="[0, 1].includes(row.status)" type="text" @click="edit(row, 'edit')">编辑</el-button> -->
          <el-button v-if="row.status == 2" type="text" @click="removke(row.id, 'revoke', '撤回')">撤回</el-button>
          <el-button v-else @click="removke(row.id, 'remove', '删除')" type="text">删除</el-button>
          <!-- v-hasPermi="['customerManage:tag:remove']" -->
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total > 0"
      :total="total"
      layout="prev, pager, next"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()" />
  </div>
</template>

<style lang="less" scoped></style>
