<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :id="$route.query.id" :showScene="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <!--  <div class="g-card">
      <div class="g-card-title">
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
    </div> -->
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div class="mid-action">
        <search-title :id="$route.query.id" :showScene="true" @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="date" show-overflow-tooltip />
        <el-table-column label="总访问数" align="center" min-width="100" prop="totalVisits" show-overflow-tooltip />
        <el-table-column
          label="总访问用户"
          align="center"
          prop="totalUser"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="有效收集量"
          align="center"
          prop="collectionVolume"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="收集率"
          align="center"
          prop="collectionRate"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="平均完成时间"
          align="center"
          prop="averageTime"
          min-width="100"
          show-overflow-tooltip></el-table-column>
      </el-table>
      <div class="bottom">
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getTableChangeSize(query.pageNum, query.pageSize)" />
      </div>
    </div>
  </div>
</template>
<script>
import { selectStatistics, lineChart, overviewExport, StatisticsDataList } from '@/api/drainageCode/smartForms.js'
import SearchTitle from '../components/SearchTitle.vue'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'

import { download } from '@/utils/common'
export default {
  name: 'scene-statistics-scene',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
  },
  data() {
    return {
      loading: false,
      baseList: '',
      exportLoading: false,
      barLegend1: ['访问客户总数'],
      barLegend2: ['咨询客户总数'],
      legend: ['总访问量', '总访问用户', '有效收集量'],
      xdata: [],
      series: [],
      activeName: 'first',
      cardData: [
        {
          title: '总访问量',
          tips: '全部渠道访问当前表单的PV',
          value: 0,
          title1: '较前日',
          value1: 0,
        },
        {
          title: '总访问用户',
          tips: '全部渠道访问当前表单的UV',
          value: 0,
          title1: '较前日',
          value1: 0,
        },
        {
          title: '有效收集量',
          tips: '全部渠道成功提交表单的UV',
          value: 0,
          title1: '较前日',
          value1: 0,
        },
        {
          title: '收集率',
          tips: '有效收集量/总访问用户，精确到两位小数',
          value: 0 + '%',
        },
        {
          title: '平均完成时间',
          tips: '有效收集用户从进入表单到提交表单的平均时长',
          value: 0 + 'm',
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
      bar1: [],
      bar2: [],
      value1: [],
      value2: [],
      tableSearch: {},
    }
  },
  methods: {
    exportFn() {
      let that = this
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        this.exportLoading = true
        let datas = this.tableSearch

        if (!datas.dataSource) {
          datas.dataSource = '默认渠道'
        }
        datas.belongId = this.$route.query.id
        overviewExport(datas)
          .then((res) => {
            console.log('数据报表导出返回值', res)
            if (res != null) {
              let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
              let url = window.URL.createObjectURL(blob)
              const link = document.createElement('a') // 创建a标签
              link.href = url
              link.download = '数据报表.xlsx' //指定下载文件名
              link.click()
              URL.revokeObjectURL(url) // 释放内存
            }
          })
          .catch((error) => {
            console.error(error)
          })
          .finally(() => {
            this.exportLoading = false
          })
        // delete datas.pageNum
        // delete datas.pageSize
        // StatisticsDataList(datas).then((res) => {
        //   let DtableList
        //   console.log('数据报表返回值1', res)
        //   let arr1 = []
        //   let arr2 = []
        //   let arr3 = []
        //   let b = []
        //   if (res.data && res.data.result.length) {
        //     DtableList = []
        //     for (let i = 0; i < res.data.result.length; i++) {
        //       let a = {
        //         xtime: res.data.result[i].createTime,
        //         visitTotalCnt: res.data.result[i].totalVisits,
        //         consultTotalCnt: res.data.result[i].totalUser,
        //         EffectiveCollectionQuantity: res.data.result[i].collectionVolume,
        //         CollectionQuantity: res.data.result[i].collectionRate,
        //         average: res.data.result[i].averageTime,
        //       }
        //       b.push(a)
        //     }
        //     DtableList = b
        //   } else {
        //     DtableList = []
        //   }
        //   let data = []
        //   for (let i = 0; i < DtableList.length; i++) {
        //     let a = {
        //       createTime: DtableList[i].xtime,
        //       totalVisits: DtableList[i].visitTotalCnt,
        //       totalUser: DtableList[i].consultTotalCnt,
        //       collectionVolume: DtableList[i].EffectiveCollectionQuantity,
        //       collectionRate: DtableList[i].CollectionQuantity,
        //       averageTime: DtableList[i].average,
        //     }
        //     data.push(a)
        //   }
        //   console.log('DtableList', DtableList)
        //   console.log('data', JSON.stringify(data))
        //   overviewExport(data)
        //     .then((res) => {
        //       console.log('数据报表导出返回值', res)
        //       download(res.msg)
        //     })
        //     .catch((error) => {
        //       console.error(error)
        //     })
        //     .finally(() => {
        //       this.exportLoading = false
        //     })
        // })
      })
    },
    setTabs(e) {
      this.getLineData(this.searchData)
    },
    formatSeconds(value) {
      var theTime = parseInt(value) // 秒
      var middle = 0 // 分
      var hour = 0 // 小时
      if (theTime > 60) {
        middle = parseInt(theTime / 60)
        theTime = parseInt(theTime % 60)
        if (middle > 60) {
          hour = parseInt(middle / 60)
          middle = parseInt(middle % 60)
        }
      }
      var result = '' + parseInt(theTime) + 's'
      if (middle > 0) {
        result = '' + parseInt(middle) + 'm' + result
      }
      if (hour > 0) {
        result = '' + parseInt(hour) + 'h' + result
      }
      return result
    },
    selectStatistics() {
      let data = {
        belongId: this.$route.query.id,
      }
      selectStatistics(data).then((res) => {
        if (res.data.length) {
          // let time = this.formatSeconds(res.data[0].averageTime)
          this.baseList = res.data[0]
          this.cardData[0].value = res.data[0].totalVisits
          this.cardData[0].value1 = res.data[0].yesTotalVisits
          this.cardData[2].value = res.data[0].collectionVolume
          this.cardData[2].value1 = res.data[0].yesCollectionVolume
          this.cardData[1].value = res.data[0].totalUser
          this.cardData[1].value1 = res.data[0].yesTotalUser
          this.cardData[3].value = res.data[0].collectionRate
          this.cardData[4].value = res.data[0].averageTime
        }
      })
    },
    //获取折现统计图数据
    getLineData(data) {
      let that = this
      console.log('xxxxxxxxxxxxxxxxxxxxx', data)
      data.belongId = this.$route.query.id
      data.beginTime ??= data.startDate
      data.endTime ??= data.endDate
      if (!data.dataSource) {
        data.dataSource = '默认渠道'
      }
      this.searchData = data
      // this.$forceUpdate()
      lineChart(data).then((res) => {
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        let arr3 = []
        if (this.activeName === 'first') {
          res.data?.forEach((e) => {
            this.xdata.push(e.date)
            arr1.push(e.totalVisits)
            arr2.push(e.totalUser)
            arr3.push(e.collectionVolume)
          })
          this.series = [arr1, arr2, arr3]
          console.log('this.xdata', this.xdata)
          console.log('this.series', this.series)
          // this.total = Number(res.data.xAxis.data.length)
          // this.loading = false
        }
      })
    },

    // getTop5Fn(data) {
    //   getBarTop5Total(data).then((res) => {
    //     if (res.data.consult && res.data.consult.length) {
    //       this.bar1 = []
    //       this.value1 = []
    //       res.data.consult.forEach((dd) => {
    //         this.bar1.push(dd.sceneName)
    //         this.value1.push(dd.total)
    //       })
    //     }
    //     if (res.data.visit && res.data.visit.length) {
    //       this.bar2 = []
    //       this.value2 = []
    //       res.data.consult.forEach((dd) => {
    //         this.bar2.push(dd.sceneName)
    //         this.value2.push(dd.total)
    //       })
    //     }
    //   })
    // },
    getTableChangeSize(a, b) {
      console.log('a', a, b)
      let that = this
      this.loading = true
      let data = this.tableSearch
      data.pageSize = b
      data.pageNum = a
      console.log('data', data)
      if (!data.dataSource) {
        data.dataSource = '默认渠道'
      }
      StatisticsDataList(data).then((res) => {
        that.tableList = res.rows || []
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      let that = this
      this.loading = true
      data.belongId = this.$route.query.id
      // getTableTotal(Object.assign({}, this.query, data)).then(res => {
      //   this.tableList = res.rows
      //   this.total = Number(res.total)
      //   this.loading = false
      // })
      if (!data.dataSource) {
        this.loading = false
        return
      }
      data.beginTime ??= data.startDate
      data.endTime ??= data.endDate
      this.tableSearch = data
      that.getTableChangeSize(1, 10)
    },
  },
  created() {
    // this.getTableChangeSize()
    this.selectStatistics()
    // this.getTop5Fn()
  },
  mounted() {
    // this.getTableChangeSize(1,10)
  },
}
</script>
<style lang="scss" scoped></style>
