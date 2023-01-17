<script>
import { getList, getAnalysis, remove } from '@/api/intelligentShortLink'
export default {
  name: '',
  components: {
    CardGroupIndex: () => import('@/components/CardGroupIndex'),
  },
  data() {
    return {
      loading: false,
      cardData: [],
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      dictTouchType: Object.freeze({
        0: '跳入微信-公众号-文章',
        1: '跳入微信-公众号-二维码',
        2: '跳入微信-个人微信-个人二维码',
        3: '跳入微信-个人微信-群二维码',
        4: '跳入微信-企业微信-员工活码',
        5: '跳入微信-企业微信-客群活码',
        6: '跳入微信-企业微信-门店导购码',
        8: '跳入微信-企业微信-门店群活码',
        7: '跳入微信-小程序-个人小程序',
        9: '跳入微信-小程序-企业小程序',
        10: '跳入微信-小程序-小程序二维码',
      }),
      dictStatus: Object.freeze({
        1: '启用',
        2: '关闭',
      }),

      list: [],
      ids: [],
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
    this.getAnalysis()
    this.$store.dispatch('app/setBusininessDesc', ` <div>生成智能短链，一键跳转公众号、小程序、企业微信</div> `)
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  destroyed() {
    this.clipboard.destroy()
  },
  methods: {
    getAnalysis() {
      this.loading = true
      getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '访问总数(pv)',
              tips: '短链页面访问的总次数',
              value: data.pvTotalCount,
            },
            {
              title: '访问总人数(uv)',
              tips: '短链页面访问的独立IP数',
              value: data.uvTotalCount,
            },
            {
              title: '小程序打开数',
              tips: '小程序成功打开的总次数',
              value: data.openTotalCount,
            },
            {
              title: '今日访问总数(pv)',
              tips: '今日短链页面访问的总次数',
              value: data.pvTodayCount,
              title1: '较昨日',
              value1: data.pvDiff,
            },
            {
              title: '今日访问总人数(uv)',
              tips: '今日短链页面访问的独立IP数',
              value: data.uvTodayCount,
              title1: '较昨日',
              value1: data.uvDiff,
            },
            {
              title: '今日小程序打开数',
              tips: '今日小程序成功打开的总次数',
              value: data.openTodayCount,
              title1: '较昨日',
              value1: data.openDiff,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
        })
        .catch(() => {})
        .finally(() => {
          this.loading = false
        })
    },
    resetForm() {
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    goRoute(row = {}, detail) {
      let { id } = row
      this.$router.push({
        path: './' + (detail || 'addEdit'),
        query: { id },
      })
    },
    remove(id) {
      const ids = id || this.ids + ''
      this.$confirm('是否确认删除吗?', '警告', {
        type: 'warning',
      })
        .then(function () {
          return remove(ids)
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
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div class="table-content">
      <el-form ref="queryForm" :inline="true" :model="query" class="top-search">
        <el-form-item label="" prop="shortLinkName">
          <el-input clearable v-model="query.shortLinkName" placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item label="" prop="touchType">
          <el-select clearable v-model="query.touchType" placeholder="请选择">
            <el-option v-for="(item, index) in dictTouchType" :key="index" :label="item" :value="index"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="" prop="status">
          <el-select clearable v-model="query.status" placeholder="请选择">
            <el-option v-for="(item, index) in dictStatus" :key="index" :label="item" :value="index"></el-option>
          </el-select>
        </el-form-item>

        <el-form-item label=" ">
          <el-button type="primary" @click="getList(1)">查询</el-button>
          <el-button type="success" @click="resetForm()">重置</el-button>
        </el-form-item>
      </el-form>

      <div class="mid-action">
        <el-button type="primary" class="mr10" @click="goRoute()">新建短链</el-button>
        <el-button :disabled="!ids.length" type="danger" @click="remove()">批量删除</el-button>
      </div>

      <el-table v-loading="loading" :data="list">
        <el-table-column label="短链名称" align="center" min-width="100" prop="shortLinkName" show-overflow-tooltip />
        <el-table-column label="类型" align="center" prop="touchType" min-width="100">
          <template slot-scope="{ row }">{{ dictTouchType[row.touchType + ''] }}</template>
        </el-table-column>
        <el-table-column label="短链地址" align="center" prop="consultTotalCnt" min-width="100" show-overflow-tooltip>
          <template slot-scope="{ row }">
            <span>{{ row.shortLink }}</span>
            <i class="el-icon-copy-document copy-btn ml20 cp" :data-clipboard-text="row.shortLink"></i>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status" min-width="100">
          <template slot-scope="{ row }">{{ dictStatus[row.status + ''] }}</template>
        </el-table-column>
        <el-table-column
          label="最后更新时间"
          align="center"
          prop="tdVisitCnt"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="{ row }">
            <el-button type="text" @click="goRoute(row, 'detail')">详情|统计</el-button>
            <el-button type="text" @click="goRoute(row)">编辑</el-button>
            <el-button @click="remove(row.id)" type="text">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
    </div>
  </div>
</template>

<style lang="less" scoped></style>
