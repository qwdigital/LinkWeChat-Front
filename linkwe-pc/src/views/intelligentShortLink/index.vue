<script>
import { getList, getAnalysis, remove } from '@/api/intelligentShortLink'
import { touchTypeDict } from './components/mixin'
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
      touchTypeDict,
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

    <el-form ref="queryForm" :inline="true" :model="query" class="top-search">
      <el-form-item label="" prop="shortLinkName">
        <el-input clearable v-model="query.shortLinkName" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="" prop="type">
        <el-select clearable v-model="query.type" placeholder="请选择">
          <el-option
            v-for="(item, index) in touchTypeDict"
            :key="index"
            :label="item.allName"
            :value="+index"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="" prop="status">
        <el-select clearable v-model="query.status" placeholder="请选择">
          <el-option v-for="(item, index) in dictStatus" :key="index" :label="item" :value="+index"></el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button type="success" @click="resetForm()">重置</el-button>
      </el-form-item>

      <el-form-item class="fr">
        <el-button type="primary" class="mr10" @click="goRoute()">新建短链</el-button>
        <el-button :disabled="!ids.length" type="danger" @click="remove()">批量删除</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list" @selection-change="(val) => (ids = val.map((e) => e.id))">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column label="短链名称" align="center" prop="shortLinkName" show-overflow-tooltip />
      <el-table-column label="类型" align="center" prop="type">
        <template slot-scope="{ row }">{{ touchTypeDict[row.type + ''].allName }}</template>
      </el-table-column>
      <el-table-column label="短链地址" align="center" prop="shortLink" show-overflow-tooltip>
        <!-- <template slot-scope="{ row }">{{ row.shortLink }}</template> -->
      </el-table-column>
      <el-table-column label="" align="center" prop="type" width="35">
        <template slot-scope="{ row }">
          <i class="el-icon-copy-document copy-btn cp" title="复制" :data-clipboard-text="row.shortLink"></i>
        </template>
      </el-table-column>
      <!-- <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="{ row }">{{ dictStatus[row.status + ''] }}</template>
      </el-table-column> -->
      <el-table-column label="最后更新时间" align="center" prop="updateTime" show-overflow-tooltip></el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="{ row }">
          <el-button type="text" @click="goRoute(row, 'detail')">详情|统计</el-button>
          <el-button type="text" @click="goRoute(row)">编辑</el-button>
          <el-button @click="remove(row.id)" type="text">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
  </div>
</template>

<style lang="scss" scoped>
.el-icon-copy-document {
  &:hover {
    color: $blue;
  }
}
</style>
