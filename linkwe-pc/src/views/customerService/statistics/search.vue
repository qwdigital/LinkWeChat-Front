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
        <!-- <el-tabs v-model="activeName">
          <el-tab-pane label="客户总数" name="first">
          </el-tab-pane>
        </el-tabs> -->
        <div class="chart-content">
          <search-title :showScene="false" :showMember="true" @search="getLineData"></search-title>
          <chart-line style="height: 300px;" :legend="legend" :xData="xdata" :series="series"></chart-line>
        </div>
      </div>
    </div>
    <div class="g-card g-pad20" style="margin-top: 20px;">
      <div class="title">
        接待员工top5
      </div>
      <div class="data-content" style="margin-top: 20px;">
        <div class="chart-content">
          <search-title @search="getTop5Fn"></search-title>
          <div class="column">
            <div class="column-item">
              <chart-bar id="1" style="height: 300px;" :xData="barData1" :series="value3" :legend="barLegend1"></chart-bar>
            </div>
            <div class="column-item">
              <chart-bar id="2" style="height: 300px;" :xData="barData2" :series="value4" :legend="barLegend2"></chart-bar>
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
          <search-title :showMember="true" @search="getTableFn"></search-title>
          <el-button type="primary" @click="exportFn" v-loading="exportLoading" size="mini">导出Excel</el-button>
        </div>
        <div class="table-content">
          <el-table v-loading="loading" :data="tableList" style="width: 100%">
            <el-table-column label="日期" align="center" min-width="100" prop="xtime" show-overflow-tooltip />
            <el-table-column label="咨询客户总数" align="center" min-width="100" prop="consultTotalCnt" show-overflow-tooltip />
            <el-table-column label="接待客户总数" align="center" prop="receptionTotalCnt" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="回复客户总数" align="center" prop="replyTotalCnt" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="回复客户占比" align="center" prop="replyProportionCnt" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="平均咨询响应时长" align="center" prop="avgConsultReplyDuration" min-width="100" show-overflow-tooltip></el-table-column>
            <el-table-column label="平均咨询时长" align="center" prop="avgConsultDuration" min-width="100" show-overflow-tooltip></el-table-column>
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
  import { getConsultTableExport, getConsultTableTotal, getConsultBarTop5Total, getConsultLineChartTotal, getConsultTotal } from '@/api/drainageCode/customerService.js'
  import { download } from '@/utils/common'
  export default {
    name: 'scene-statistics-search',
    components: {
      CardGroupIndex,
      SearchTitle,
      ChartLine,
      ChartBar
    },
    data () {
      return {
        exportLoading: false,
        barLegend1: ['回复客户总数'],
        barLegend2: ['平均咨询响应时长(s)'],
        legend: ['咨询客户总数', '接待客户总数', '回复客户总数'],
        xdata: [],
        series: [],
        activeName: 'first',
        cardData: [
          {
            title: '咨询客户总数',
            tips: '发送咨询消息的客户总数(包含重复)',
            value: 0,
            noArrow: true
          },
          {
            title: '接待客户总数',
            tips: '人工客服接待的客户总数(包含重复)',
            value: 0,
          },
          {
            title: '回复客户总数',
            tips: '人工客服回复的客户总数(包含重复)',
            value: 0,
          },
          {
            title: '回复客户占比',
            tips: '回复客户总数/咨询客户总数',
            value: "0%",
          },
          {
            title: '平均咨询响应时长',
            tips: '客户首条咨询消息与客服首条回复的平均时间间隔',
            value: "0s",
          },
          {
            title: '平均咨询时长',
            tips: '咨询开始时间与咨询结束时间的平均时间间隔',
            value: '0s',
          }
        ],
        total: 0,
        query: {
          pageSize: 10,
          pageNum: 1
        },
        tableList: [],
        loading: false,
        barData1: [],
        barData2: [],
        value3: [],
        value4: [],
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
            return getConsultTableExport(Object.assign({}, this.query, this.tableSearch))
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
      getConsultTotalFn () {
        getConsultTotal().then(res => {
          this.cardData[0].value = res.data.consultCnt
          this.cardData[1].value = res.data.receptionCnt
          this.cardData[2].value = res.data.replyCnt
          this.cardData[3].value = res.data.replyProportionCnt
          this.cardData[4].value = res.data.avgConsultReplyDuration
          this.cardData[5].value = res.data.avgConsultDuration
        })
      },
      getLineData (data) {
        this.$forceUpdate()
        getConsultLineChartTotal(data).then(res => {
          this.xdata = []
          this.series = []
          let arr1 = []
          let arr2 = []
          let arr3 = []
          if (res.data && res.data.length) {
            res.data.forEach(dd => {
              this.xdata.push(dd.xtime)
              arr1.push(dd.consultTotalCnt)
              arr2.push(dd.receptionTotalCnt)
              arr3.push(dd.replyTotalCnt)
            })
            this.series = [arr1, arr2, arr3]
          }
        })
      },
      getTop5Fn (data) {
        getConsultBarTop5Total(data).then(res => {
          if (res.data.reply && res.data.reply.length) {
            this.barData1 = []
            this.value3 = []
            res.data.reply.forEach(dd => {
              this.barData1.push(dd.userName)
              this.value3.push(dd.total ? dd.total : 0)
            })
          }
          console.log(this.barData1)
          if (res.data.avgReplyDuration && res.data.avgReplyDuration.length) {
            this.barData2 = []
            this.value4 = []
            res.data.avgReplyDuration.forEach(dd => {
              this.barData2.push(dd.userName)
              this.value4.push(dd.total ? dd.total : 0)
            })
          }
          console.log(this.barData2)
          this.$forceUpdate()
        })
      },
      getTableChangeSize () {
        this.loading = true
        getConsultTableTotal(Object.assign({}, this.query, this.tableSearch)).then(res => {
          this.tableList = res.rows
          this.total = Number(res.total)
          this.loading = false
        })
      },
      getTableFn (data) {
        this.loading = true
        this.tableSearch = data
        getConsultTableTotal(Object.assign({}, this.query, data)).then(res => {
          this.tableList = res.rows
          this.total = Number(res.total)
          this.loading = false
        })
      }
    },
    created () {
      this.getConsultTotalFn()
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