<template>
  <div>
    <div class="total-list">
      <CardGroupIndex :data="cardData"></CardGroupIndex>
    </div>
    <div class="g-card g-pad20" style="margin-top: 0;">
      <div class="title">
        数据趋势
      </div>
      <div class="data-content" style="margin-top: 20px;">
        <div class="chart-content">
          <search-title @search="getLineData"></search-title>
          <chart-line style="height: 300px;" :legend="legend" :xData="xdata" :series="series"></chart-line>
        </div>
      </div>
    </div>
    <div class="g-card g-pad20" style="margin-top: 20px;">
      <div class="title">
        访问场景top5
      </div>
      <div class="data-content" style="margin-top: 20px;">
        <div class="chart-content">
          <search-title @search="getTop5Fn"></search-title>
          <div class="column">
            <div class="column-item">
              <chart-bar style="height: 300px;" :xData="bar1" :series="value1" :legend="barLegend1"></chart-bar>
            </div>
            <div class="column-item">
              <chart-bar style="height: 300px;" :xData="bar2" :series="value2" :legend="barLegend2"></chart-bar>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="g-card g-pad20" style="margin-top: 20px;">
      <div class="title">
        数据报表
      </div>
      <div class="data-content" style="margin-top: 20px;">
        <div class="search-content">
          <search-title :showScene="true" @search="getTableFn"></search-title>
          <el-button type="primary" size="mini" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
        </div>
        <div class="table-content">
          <el-table v-loading="loading" :data="tableList" style="width: 100%;">
            <el-table-column label="日期" align="center" min-width="100" prop="xtime" show-overflow-tooltip />
            <el-table-column
              label="访问客户总数"
              align="center"
              min-width="100"
              prop="visitTotalCnt"
              show-overflow-tooltip
            />
            <el-table-column
              label="咨询客户总数"
              align="center"
              prop="consultTotalCnt"
              min-width="100"
              show-overflow-tooltip
            ></el-table-column>
            <el-table-column
              label="接待客户总数"
              align="center"
              prop="receptionTotalCnt"
              min-width="100"
              show-overflow-tooltip
            ></el-table-column>
            <el-table-column
              label="今日新增访问客户"
              align="center"
              prop="tdVisitCnt"
              min-width="100"
              show-overflow-tooltip
            ></el-table-column>
            <el-table-column
              label="今日新增咨询客户"
              align="center"
              prop="tdConsultCnt"
              min-width="100"
              show-overflow-tooltip
            ></el-table-column>
            <el-table-column
              label="今日新增接待客户"
              align="center"
              prop="tdReceptionCnt"
              min-width="100"
              show-overflow-tooltip
            ></el-table-column>
          </el-table>
          <pagination
            :total="total"
            :page.sync="query.pageNum"
            :limit.sync="query.pageSize"
            @pagination="getTableChangeSize()"
          />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import ChartBar from '@/components/ChartBar.vue'
  import ChartLine from '@/components/ChartLine.vue'
  import SearchTitle from '@/components/common/TimeSearchTitle.vue'
  import CardGroupIndex from '@/components/CardGroupIndex.vue'
  import {
    getTableExport,
    getTableTotal,
    getBarTop5Total,
    getLineChartTotal,
    getGoodsTotal
  } from '@/api/commodityCenter/commodityManage'
  import { dateFormat } from '@/utils/index'

  export default {
    name: 'commodity-statistics',
    components: {
      CardGroupIndex,
      SearchTitle,
      ChartLine,
      ChartBar
    },
    data() {
      return {
        exportLoading: false,
        barLegend1: ['访问客户总数'],
        barLegend2: ['咨询客户总数'],
        legend: ['订单总额(元)', '退款总额(元)', '净收入(元)'],
        xdata: [],
        series: [],
        cardData: [
          {
            title: '订单总数',
            tips: '所有商品全部的订单总数',
            value: 0,
            noArrow: true
          },
          {
            title: '订单总额(元)',
            tips: '所有商品全部的订单总额，精确到两位小数点',
            value: 0
          },
          {
            title: '退款总额(元)',
            tips: '所有商品全部的退款总额，精确到两位小数点',
            value: 0
          },
          {
            title: '净收入(元)',
            tips: '订单总额-退款总额，精确到两位小数点',
            value: 0
          },
          {
            title: '今日订单总数',
            tips: '今日所有商品全部的订单总数',
            value: 0,
            title1: '较昨日',
            value1: 0
          },
          {
            title: '今日订单总额(元)',
            tips: '今日所有商品全部的订单总额，精确到两位小数点',
            value: 0,
            title1: '较昨日',
            value1: 0
          },
          {
            title: '今日退款总额(元)',
            tips: '今日所有商品全部的退款总额，精确到两位小数点',
            value: 0,
            title1: '较昨日',
            value1: 0
          },
          {
            title: '今日净收入(元)',
            tips: '今日订单总额-退款总额，精确到两位小数点',
            value: 0,
            title1: '较昨日',
            value1: 0
          }
        ],
        total: 0,
        query: {
          pageSize: 10,
          pageNum: 1
        },
        tableList: [],
        loading: false,
        bar1: [],
        bar2: [],
        value1: [],
        value2: [],
        tableSearch: {}
      }
    },
    methods: {
      exportFn() {
        this.$confirm('确认导出吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            this.exportLoading = true
            return getTableExport(Object.assign({}, this.query, this.tableSearch))
          })
          .then((res) => {
            if (!res) return
            const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型
            if (window.navigator.msSaveOrOpenBlob) {
              //兼容IE10
              navigator.msSaveBlob(blob, '场景分析')
            } else {
              const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
              const a = document.createElement('a') //创建a标签
              a.style.display = 'none'
              a.href = href // 指定下载链接
              a.download = dateFormat(new Date(), 'yyyy-MM-dd') + '_场景分析.xlsx' //指定下载文件名
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
        this.$forceUpdate()
        getLineChartTotal({
          startDate: data.beginTime,
          endDate: data.endTime
        }).then((res) => {
          this.xdata = []
          this.series = []
          let arr1 = []
          let arr2 = []
          let arr3 = []
          if (res.data && res.data.length) {
            res.data.forEach((dd) => {
              this.xdata.push(dd.xtime)
              arr1.push(dd.visitTotalCnt)
              arr2.push(dd.consultTotalCnt)
              arr3.push(dd.receptionTotalCnt)
            })
            this.series = [arr1, arr2, arr3]
          }
        })
      },
      getTop5Fn(data) {
        getBarTop5Total(data).then((res) => {
          if (res.data.consult && res.data.consult.length) {
            this.bar1 = []
            this.value1 = []
            res.data.consult.forEach((dd) => {
              this.bar1.push(dd.sceneName)
              this.value1.push(dd.total)
            })
          } else {
            this.bar1 = []
            this.value1 = []
          }
          if (res.data.visit && res.data.visit.length) {
            this.bar2 = []
            this.value2 = []
            res.data.visit.forEach((dd) => {
              this.bar2.push(dd.sceneName)
              this.value2.push(dd.total)
            })
          } else {
            this.bar2 = []
            this.value2 = []
          }
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
        this.tableSearch = data
        getTableTotal(Object.assign({}, this.query, data)).then((res) => {
          this.tableList = res.rows
          this.total = Number(res.total)
          this.loading = false
        })
      }
    },
    created() {
      this.getSceneTotalFn()
    }
  }
</script>
<style lang="scss" scoped>
  .total-list {
    .item {
      padding: 10px;
      background-color: #fff;
    }
  }
  .title {
    font-size: 16px;
    color: #333;
    font-weight: 600;
  }
  .data-content {
    margin-top: 10px;
    .chart-content {
      margin-top: 10px;
      .my_button {
        float: right;
      }
      .column {
        display: flex;
        .column-item {
          flex: 1;
        }
      }
    }
    .search-content {
      display: flex;
      justify-content: space-between;
    }
    .table-content {
      margin-top: 10px;
    }
  }
</style>
