<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :showMore="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div style="display: flex; justify-content: space-between">
        <search-title :showMore="true" @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="date" show-overflow-tooltip />
        <el-table-column
          :label="fassionType == 1 ? '完成任务老客总数' : '完成任务客户总数'"
          align="center"
          prop="completeTaskOldCustomerNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="裂变新客总数"
          align="center"
          prop="fissionCustomerNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          :label="fassionType == 1 ? '今日完成任务老客数' : '今日完成任务客户数'"
          align="center"
          prop="tdCompleteTaskOldCustomerNum"
          min-width="120"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="今日裂变新客数"
          align="center"
          prop="tdFissionCustomerNum"
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
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'
import { getTotal, getLineData, getTableData, getTableExport } from '../taskGroup/api'
export default {
  name: 'fission-statistics',
  components: {
    SearchTitle,
    ChartLine,
  },
  props: {
    fassionType: {
      type: Number,
      default: 1,
    },
  },
  watch: {
    fassionType: {
      handler(val) {
        if (val == 1) {
          this.legend = ['完成任务老客数', '裂变新客数']
        } else {
          this.legend = ['完成任务客户数', '裂变新客数']
        }
      },
      immediate: true,
    },
  },
  data() {
    return {
      legend: ['完成任务老客数', '裂变新客数'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: this.fassionType == 1 ? '员工邀请老客总数' : '员工触达客群总数',
          tips: this.fassionType == 1 ? '在当前任务中员工已送达的客户总数' : '在当前任务中员工已送达的客群总数',
          value: 0,
        },
        {
          title: this.fassionType == 1 ? '完成任务老客总数' : '完成任务客户总数',
          tips: this.fassionType == 1 ? '在当前任务中完成裂变任务的老客总数' : '在当前任务中完成裂变任务的客户总数',
          value: 0,
        },
        {
          title: '裂变新客总数',
          tips: this.fassionType == 1 ? '在当前任务中成功添加员工的新客总数' : '在当前任务中成功添加客群的新客总数',
          value: 0,
        },
        {
          title: this.fassionType == 1 ? '今日完成任务老客数' : '今日完成任务客户数',
          tips: this.fassionType == 1 ? '在当前任务中今日完成裂变任务的老客数' : '在当前任务中今日完成裂变任务的客户数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日裂变新客数',
          tips:
            this.fassionType == 1 ? '在当前任务中今日成功添加员工的新客数' : '在当前任务中今日成功添加客群的新客总数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
      ],
      value: [],
      id: '',
      exportLoading: false,
      tableList: [],
      loading: false,
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
      },
      tableSearch: {},
    }
  },
  methods: {
    getTabTotalFn() {
      getTotal(this.id).then((res) => {
        this.cardData[0].value = res.data.inviterOldCustomerNum
        this.cardData[1].value = res.data.completeTaskOldCustomerNum
        this.cardData[2].value = res.data.fissionCustomerNum
        this.cardData[3].value = res.data.tdCompleteTaskOldCustomerNum
        this.cardData[3].value1 =
          Number(res.data.tdCompleteTaskOldCustomerNum) - Number(res.data.ydCompleteTaskOldCustomerNum)
        this.cardData[4].value = res.data.tdFissionCustomerNum
        this.cardData[4].value1 = Number(res.data.tdFissionCustomerNum) - Number(res.data.ydFissionCustomerNum)
      })
    },
    getLineData(data) {
      // this.$forceUpdate()
      data.id = this.id
      getLineData(data).then(({ data }) => {
        let arr1 = []
        let arr2 = []
        let arr3 = []
        data.forEach((dd) => {
          arr1.push(dd.date)
          arr2.push(dd.completeTaskOldCustomerNum)
          arr3.push(dd.fissionCustomerNum)
        })
        this.xdata = arr1
        this.series = [arr2, arr3]
        // this.$forceUpdate()
      })
    },
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
    getTableChangeSize() {
      this.loading = true
      getTableData(Object.assign({}, this.query)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.tableSearch = data
      this.loading = true
      this.query.id = this.id
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
  },
  created() {
    this.id = this.$route.query.id
    this.getTabTotalFn()
  },
}
</script>
<style lang="scss" scoped></style>
