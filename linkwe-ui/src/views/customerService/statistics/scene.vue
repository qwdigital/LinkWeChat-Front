<template>
  <div>
    <div class="total-list">
      <CardGroupIndex :data="cardData"></CardGroupIndex>
    </div>
    <div class="g-card g-pad20" style="margin-top: 0;">
      <div class="title">
        数据概览
      </div>
      <div class="data-content">
        <el-tabs v-model="activeName" @tab-click="setTabs">
          <el-tab-pane label="客户总数" name="first">
          </el-tab-pane>
          <el-tab-pane label="实时数据" name="second">
          </el-tab-pane>
        </el-tabs>
        <div class="chart-content">
          <search-title :showScene='true' @search="getLineData"></search-title>
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
          <search-title :showScene='true' @search="getTableFn"></search-title>
          <el-button type="primary" size="mini" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
        </div>
        <div class="table-content">
          <el-table v-loading="loading" :data="tableList" style="width: 100%">
            <el-table-column label="日期" align="center" min-width="100" prop="xtime" show-overflow-tooltip />
            <el-table-column label="访问客户总数" align="center" min-width="100" prop="visitTotalCnt" show-overflow-tooltip />
            <el-table-column label="咨询客户总数" align="center" prop="consultTotalCnt" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="接待客户总数" align="center" prop="receptionTotalCnt" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="今日新增访问客户" align="center" prop=tdVisitCnt "" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="今日新增咨询客户" align="center" prop="tdConsultCnt" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="今日新增接待客户" align="center" prop="tdReceptionCnt" min-width="100" show-overflow-tooltip></el-table-column>
          </el-table>
          <!-- <div class="bottom"> -->
          <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getTableChangeSize()" />
          <!-- </div> -->
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import ChartBar from '@/components/ChartBar.vue'
  import ChartLine from '@/components/ChartLine.vue'
  import SearchTitle from '../components/SearchTitle.vue'
  import CardGroupIndex from '@/components/CardGroupIndex.vue'
  import { getTableExport, getTableTotal, getBarTop5Total, getLineChartTotal, getSceneTotal } from '@/api/drainageCode/customerService.js'
  import { download } from '@/utils/common'
  export default {
    name: 'scene-statistics-scene',
    components: {
      CardGroupIndex,
      SearchTitle,
      ChartLine,
      ChartBar
    },
    data () {
      return {
        exportLoading: false,
        barLegend1: ['访问客户总数'],
        barLegend2: ['咨询客户总数'],
        legend: ['访问客户总数', '咨询客户总数', '接待客户总数'],
        xdata: [],
        series: [],
        activeName: 'first',
        cardData: [
          {
            title: '访问客户总数',
            tips: '进入咨询页面的客户总数(包含重复)',
            value: 0,
            noArrow: true
          },
          {
            title: '咨询客户总数',
            tips: '发送咨询消息的客户总数(包含重复)',
            value: 0,
          },
          {
            title: '接待客户总数',
            tips: '人工客服接待的客户总数(包含重复)',
            value: 0,
          },
          {
            title: '今日新增访问客户',
            tips: '今日进入咨询页面的客户数(包含重复)',
            value: 0,
            title1: '较前日',
            value1: 0
          },
          {
            title: '今日新增咨询客户',
            tips: '今日发送咨询消息的客户数(包含重复)',
            value: 0,
            title1: '较前日',
            value1: 0
          },
          {
            title: '今日新增接待客户',
            tips: '今日人工客服接待的客户数(包含重复)',
            value: 0,
            title1: '较前日',
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
        searchData: {},
        bar1: [],
        bar2: [],
        value1: [],
        value2: [],
        tableSearch: {}
      }
    },
    methods: {
      exportFn () {
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
            console.log(res)
            download(res.msg)
          })
          .catch((error) => {
            console.error(error)
          })
          .finally(() => {
            this.exportLoading = false
          })
      },
      setTabs (e) {
        this.getLineData(this.searchData)
      },
      getSceneTotalFn () {
        getSceneTotal().then(res => {
          this.cardData[0].value = res.data.visitCnt
          this.cardData[1].value = res.data.consultCnt
          this.cardData[2].value = res.data.receptionCnt
          this.cardData[3].value = res.data.tdVisitCnt
          this.cardData[3].value1 = res.data.ydVisitCnt
          this.cardData[4].value = res.data.tdConsultCnt
          this.cardData[4].value1 = res.data.ydConsultCnt
          this.cardData[5].value = res.data.tdReceptionCnt
          this.cardData[5].value1 = res.data.ydReceptionCnt
        })
      },
      getLineData (data) {
        this.searchData = data
        if (this.activeName === 'first') {
          this.legend = ['访问客户总数', '咨询客户总数', '接待客户总数']
        } else {
          this.legend = ['新增访问客户', '新增咨询客户', '新增接待客户']
        }
        this.$forceUpdate()
        getLineChartTotal(data).then(res => {
          this.xdata = []
          this.series = []
          let arr1 = []
          let arr2 = []
          let arr3 = []
          if (this.activeName === 'first') {
            if (res.data && res.data.length) {
              res.data.forEach(dd => {
                this.xdata.push(dd.xtime)
                arr1.push(dd.visitTotalCnt)
                arr2.push(dd.consultTotalCnt)
                arr3.push(dd.receptionTotalCnt)
              })
              this.series = [arr1, arr2, arr3]
            }
          } else {
            if (res.data && res.data.length) {
              res.data.forEach(dd => {
                this.xdata.push(dd.xtime)
                arr1.push(dd.tdVisitCnt)
                arr2.push(dd.tdConsultCnt)
                arr3.push(dd.tdReceptionCnt)
              })
              this.series = [arr1, arr2, arr3]
            }
          }
        })
      },
      getTop5Fn (data) {
        getBarTop5Total(data).then(res => {
          if (res.data.consult && res.data.consult.length) {
            this.bar1 = []
            this.value1 = []
            res.data.consult.forEach(dd => {
              this.bar1.push(dd.sceneName)
              this.value1.push(dd.total)
            })
          }
          if (res.data.visit && res.data.visit.length) {
            this.bar2 = []
            this.value2 = []
            res.data.consult.forEach(dd => {
              this.bar2.push(dd.sceneName)
              this.value2.push(dd.total)
            })
          }
        })
      },
      getTableChangeSize () {
        this.loading = true
        getTableTotal(Object.assign({}, this.query, this.tableSearch)).then(res => {
          this.tableList = res.rows
          this.total = Number(res.total)
          this.loading = false
        })
      },
      getTableFn (data) {
        this.loading = true
        this.tableSearch = data
        getTableTotal(Object.assign({}, this.query, data)).then(res => {
          this.tableList = res.rows
          this.total = Number(res.total)
          this.loading = false
        })
      }
    },
    created () {
      this.getSceneTotalFn()
      // this.getTop5Fn()
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