<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card" style="margin-top: 0">
      <div class="g-card-title">数据趋势</div>
      <search-title @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="column flex mt20">
      <div class="column-item g-card mr20">
        <div class="g-card-title">商品订单top5</div>
        <search-title @search="getGoodsTop5Fn"></search-title>
        <el-table v-loading="goodsTableLoading" :data="goodsTableList" style="width: 100%">
          <el-table-column label="商品" align="center" width="200" prop="xtime" show-overflow-tooltip>
            <template #default="{ row }">
              <div style="display: flex">
                <el-image
                  style="width: 50px; height: 50px; margin-right: 5px; flex-shrink: 0"
                  :src="row.picture"></el-image>
                <span class="limit_span">{{ row.productDesc }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="订单总数" align="center" prop="orderNum" show-overflow-tooltip />
          <el-table-column
            label="订单总额（元）"
            align="center"
            prop="totalFee"
            show-overflow-tooltip></el-table-column>
          <el-table-column label="净收入（元）" align="center" prop="netIncome" show-overflow-tooltip></el-table-column>
        </el-table>
      </div>
      <div class="column-item">
        <div class="g-card">
          <div class="g-card-title">员工订单top5</div>
          <search-title @search="getMemebersTop5Fn"></search-title>
          <el-table v-loading="memberTableLoading" :data="memberTableList" style="width: 100%">
            <el-table-column
              label="员工"
              align="center"
              min-width="100"
              prop="weUserName"
              show-overflow-tooltip></el-table-column>
            <el-table-column label="订单总数" align="center" prop="orderNum" show-overflow-tooltip />
            <el-table-column
              label="订单总额（元）"
              align="center"
              prop="totalFee"
              show-overflow-tooltip></el-table-column>
          </el-table>
        </div>
      </div>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div class="mid-action">
        <search-title :showScene="true" @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="dateStr" show-overflow-tooltip />
        <el-table-column label="订单总数" align="center" min-width="100" prop="orderNum" show-overflow-tooltip />
        <el-table-column
          label="订单总额（元）"
          align="center"
          prop="totalFee"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="退款总额（元）"
          align="center"
          prop="refundFee"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="净收入（元）"
          align="center"
          prop="netIncome"
          min-width="100"
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
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/common/TimeSearchTitle.vue'

import {
  getTableExport,
  getTableTotal,
  getGoodsTop5,
  getMembersTop5,
  getLineChartTotal,
  getGoodsTotal,
} from '@/api/commodityCenter/commodityManage'
import { dateFormat } from '@/utils/index'

export default {
  name: 'commodity-statistics',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
  },
  data() {
    return {
      exportLoading: false,
      legend: ['订单总额(元)', '退款总额(元)', '净收入(元)'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: '订单总数',
          tips: '所有商品全部的订单总数',
          value: 0,
          noArrow: true,
        },
        {
          title: '订单总额(元)',
          tips: '所有商品全部的订单总额，精确到两位小数点',
          value: 0,
        },
        {
          title: '退款总额(元)',
          tips: '所有商品全部的退款总额，精确到两位小数点',
          value: 0,
        },
        {
          title: '净收入(元)',
          tips: '订单总额-退款总额，精确到两位小数点',
          value: 0,
        },
        {
          title: '今日订单总数',
          tips: '今日所有商品全部的订单总数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日订单总额(元)',
          tips: '今日所有商品全部的订单总额，精确到两位小数点',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日退款总额(元)',
          tips: '今日所有商品全部的退款总额，精确到两位小数点',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日净收入(元)',
          tips: '今日订单总额-退款总额，精确到两位小数点',
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
      goodsTableLoading: false,
      goodsTableList: [],
      memberTableLoading: false,
      memberTableList: [],
      tableSearch: {},
    }
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
          return getTableExport(Object.assign({}, this.tableSearch))
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型
          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '商品分析')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_商品分析.xlsx' //指定下载文件名
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    getSceneTotalFn() {
      getGoodsTotal().then((res) => {
        this.cardData[0].value = res.data.orderNum
        this.cardData[1].value = res.data.totalFee
        this.cardData[2].value = res.data.refundFee
        this.cardData[3].value = res.data.netIncome
        this.cardData[4].value = res.data.todayOrderNum
        this.cardData[4].value1 = res.data.orderNumComparedToYes
        this.cardData[5].value = res.data.todayTotalFee
        this.cardData[5].value1 = res.data.totalFeeComparedToYes
        this.cardData[6].value = res.data.todayRefundFee
        this.cardData[6].value1 = res.data.refundFeeComparedToYes
        this.cardData[7].value = res.data.todayNetIncome
        this.cardData[7].value1 = res.data.netIncomeComparedToYes
      })
    },
    getLineData(data) {
      // this.$forceUpdate()
      getLineChartTotal({
        type: 'customization',
        startDate: data.beginTime,
        endDate: data.endTime,
      }).then((res) => {
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        let arr3 = []
        this.xdata = res.data.xAxis.data
        arr1 = res.data.series[0].data
        arr2 = res.data.series[1].data
        arr3 = res.data.series[2].data
        this.series = [arr1, arr2, arr3]
      })
    },
    getGoodsTop5Fn(data) {
      this.goodsTableLoading = true
      getGoodsTop5({
        type: 'customization',
        startDate: data.beginTime,
        endDate: data.endTime,
      }).then((res) => {
        this.goodsTableList = res.data
        this.goodsTableLoading = false
      })
    },
    getMemebersTop5Fn(data) {
      this.memberTableLoading = true
      getMembersTop5({
        type: 'customization',
        startDate: data.beginTime,
        endDate: data.endTime,
      }).then((res) => {
        this.memberTableList = res.data
        this.memberTableLoading = false
      })
    },
    getTableChangeSize() {
      this.loading = true
      getTableTotal(Object.assign({}, this.query, this.tableSearch)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.loading = true
      let obj = {
        type: 'customization',
        startDate: data.beginTime,
        endDate: data.endTime,
      }
      this.tableSearch = obj
      getTableTotal(Object.assign({}, this.query, obj)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
  },
  created() {
    this.$store.setBusininessDesc(
      `
			     <div>全部商品及订单数据总览与数据分析。</div>
			   `,
    )
    this.getSceneTotalFn()
  },
}
</script>
<style lang="scss" scoped>
.column {
  display: flex;
  .column-item {
    flex: 1;
  }
}
</style>
