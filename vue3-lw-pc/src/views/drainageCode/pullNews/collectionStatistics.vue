<template>
  <div>
    <!-- 领取统计 -->
    <CardGroupIndex :data="form.type === 1 ? cardDataRed : cardDataCard"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title @search="getLineData"></search-title>
      <div style="display: flex; justify-content: space-between">
        <chart-line
          style="height: 300px; width: 48%"
          :legend="legendRedOne"
          :xData="xdataOne"
          :series="seriesOne"></chart-line>
        <chart-line
          style="height: 300px; width: 48%"
          :legend="legendRedTwo"
          :xData="xdata"
          :series="series"></chart-line>
      </div>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div style="display: flex; justify-content: space-between">
        <search-title @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>

      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="dateTime" show-overflow-tooltip />
        <el-table-column
          :label="true ? '红包领取总数' : '卡券领取总数'"
          align="center"
          prop="totalNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          :label="true ? '红包领取总金额(元)' : '卡券领取总金额(元)'"
          align="center"
          prop="totalAmount"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          :label="true ? '今日红包领取数' : '今日卡券领取数'"
          align="center"
          prop="todayNum"
          min-width="120"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          :label="true ? '今日红包领取金额(元)' : '今日卡券领取金额(元)'"
          align="center"
          prop="todayAmount"
          min-width="120"
          show-overflow-tooltip></el-table-column>
      </el-table>
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getTableChangeSize()" />
    </div>
  </div>
</template>
<script>
import { dateFormat } from '@/utils/index'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import {
  getTotalData,
  getRedTableData,
  getMoneyLineData,
  getNumLineData,
  getRedTableExport,
} from '@/api/drainageCode/pullNews'
export default {
  name: 'identity-code-statistics',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
  },
  data() {
    return {
      exportLoading: false,
      legend: ['新客扫码人数', '添加新客人数', '老客扫码人数', '流失客户人数'],
      legendRedOne: ['红包领取个数'],
      legendRedTwo: ['红包领取金额（元）'],
      legendCardOne: ['卡券领取个数'],
      legendCardTwo: ['卡券领取面额（元）'],
      xdata: [],
      series: [],
      xdataOne: [],
      seriesOne: [],
      cardData: [],
      cardDataRed: [
        {
          title: '红包领取总数',
          tips: '当前活码新客累计领取红包的总个数',
          value: 0,
        },
        {
          title: '红包领取总金额(元)',
          tips: '当前活码新客累计领取红包的总金额',
          value: 0,
        },
        {
          title: '今日红包领取数',
          tips: '当前活码今日新客领取红包的总个数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日红包领取金额(元)',
          tips: '当前活码今日新客领取红包的总金额',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
      ],
      cardDataCard: [
        {
          title: '卡券领取总数',
          tips: '当前活码新客累计领取卡券的总个数',
          value: 0,
        },
        {
          title: '卡券领取总面额(元)',
          tips: '当前活码新客累计领取卡券的总面额',
          value: 0,
        },
        {
          title: '今日卡券领取数',
          tips: '当前活码今日新客领取卡券的总个数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日红包领取面额(元)',
          tips: '当前活码今日新客领取卡券的总面额',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
      ],
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      tableList: [],
      loading: false,
      searchData: {},
      bar: [],
      value: [],
      tableSearch: {},
      addWeUserState: null,
      id: '',
    }
  },
  props: {
    form: {
      type: Object,
      default: {},
    },
  },

  methods: {
    exportFn() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          return getRedTableExport(Object.assign({}, this.query, this.tableSearch))
        })
        .then((res) => {
          if (res) {
            let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '数据明细-' + dateFormat(new Date()) + '.xlsx' // 重命名文件
            link.click()
            URL.revokeObjectURL(url)
          }
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    getTabTotalFn() {
      getTotalData({ qrId: this.id }).then((res) => {
        this.cardDataRed[0].value = res.data.totalNum
        this.cardDataRed[1].value = res.data.totalAmount
        this.cardDataRed[2].value = res.data.todayNum
        res.data.todayNumDiff ? (this.cardDataRed[2].value1 = res.data.todayNumDiff) : ''
        this.cardDataRed[3].value = res.data.todayAmount
        res.data.todayAmountDiff ? (this.cardDataRed[3].value1 = res.data.todayAmountDiff) : ''
      })
    },
    getLineData(data) {
      // this.$forceUpdate()
      data.qrId = this.id
      getMoneyLineData(data).then((res) => {
        this.xdata = []
        this.series = []
        if (res.data) {
          this.xdata = res.data.xaxis
          this.series = [res.data.yaxis]
          // this.$forceUpdate()
        }
      })
      getNumLineData(data).then((res) => {
        this.xdataOne = []
        this.seriesOne = []
        if (res.data) {
          this.xdataOne = res.data.xaxis
          this.seriesOne = [res.data.yaxis]
          // this.$forceUpdate()
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      // this.query.id = this.id
      getRedTableData(Object.assign({}, this.query)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.loading = true
      this.query.qrId = this.id
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
  },
  created() {
    this.addWeUserState = this.$route.query.addWeUserState
    this.id = this.$route.query.groupId
    this.getTabTotalFn()
  },
}
</script>
<style lang="scss" scoped></style>
