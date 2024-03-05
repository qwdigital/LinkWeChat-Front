<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div style="display: flex; justify-content: space-between; align-items: center">
        <search-title @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="date" show-overflow-tooltip />
        <el-table-column
          label="累计新增客户数"
          align="center"
          prop="addWeCustomerNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="累计活跃客户数"
          align="center"
          prop="weCustomerActiveNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="今日新增客户数"
          align="center"
          prop="tdAddWeCustomerNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="今日活跃客户数"
          align="center"
          prop="tdWeCustomerActiveNumber"
          min-width="120"
          show-overflow-tooltip></el-table-column>
      </el-table>
      <!-- <div class="bottom"> -->
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getTableChangeSize()" />
      <!-- </div> -->
    </div>
  </div>
</template>
<script>
import { dateFormat } from '@/utils/index'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import { getTabData, getLineData, getTableData, getTableExport } from './api.js'
export default {
  name: 'customer-assistant-statistics',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
  },
  data() {
    return {
      exportLoading: false,
      legend: ['今日新增客户数', '今日活跃客户数'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: '累计新增客户数',
          tips: '通过当前链接新增的全部客户数(去重)',
          value: 0,
        },
        {
          title: '累计活跃客户数',
          tips: '新增客户中累计发起会话的客户数(去重)',
          value: 0,
        },
        {
          title: '今日新增客户数',
          tips: '今日通过当前链接新增的客户数(去重)',
          value: 0,
        },
        {
          title: '今日活跃客户数',
          tips: '今日新增客户中发起会话的客户数(去重)',
          value: 0,
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
      id: '',
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
          return getTableExport(Object.assign({}, this.query, this.tableSearch))
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
      getTabData(this.id).then((res) => {
        this.cardData[0].value = res.data.addWeCustomerNumber
        this.cardData[1].value = res.data.weCustomerActiveNumber
        this.cardData[2].value = res.data.tdAddWeCustomerNumber
        this.cardData[3].value = res.data.tdWeCustomerActiveNumber
      })
    },
    getLineData(data) {
      data.linkId = this.id
      getLineData(data).then((res) => {
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        if (res.data && res.data.length) {
          res.data.forEach((dd) => {
            this.xdata.push(dd.date)
            arr1.push(dd.addWeCustomerNumber)
            arr2.push(dd.weCustomerActiveNumber)
          })
          this.series = [arr1, arr2]
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      this.query.linkId = this.id
      getTableData(Object.assign({}, this.query, this.tableSearch)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.loading = true
      this.tableSearch = data
      this.query.linkId = this.id
      getTableData(Object.assign({}, this.query, data)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
  },
  created() {
    this.id = this.$route.query.linkId
    this.getTabTotalFn()
  },
}
</script>
<style lang="scss" scoped></style>
