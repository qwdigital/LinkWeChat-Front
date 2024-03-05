<template>
  <div>
    <!-- 活码统计 -->
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div style="display: flex; justify-content: space-between">
        <search-title @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>

      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="dateTime" show-overflow-tooltip>
          <template #default="scope">
            <span>{{ dealDate(scope.row.dateTime) }}</span>
          </template>
        </el-table-column>
        <!-- <el-table-column
          label="总扫码次数"
          align="center"
          prop="newCustomerScanNumber"
          min-width="100"
          show-overflow-tooltip
        ></el-table-column> -->
        <el-table-column
          label="新增新客总数"
          align="center"
          prop="totalNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <!-- <el-table-column
          label="今日扫码次数"
          align="center"
          prop="oldCustomerScanNumber"
          min-width="100"
          show-overflow-tooltip
        ></el-table-column> -->
        <el-table-column
          label="今日新增新客数"
          align="center"
          prop="todayNum"
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
import moment from 'moment'
import { getLineData, getTableData, getTableExport } from '@/api/drainageCode/pullNews'
export default {
  name: 'identity-code-statistics',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
  },
  props: {
    form: {
      type: Object,
      default: {},
    },
  },
  watch: {},
  data() {
    return {
      exportLoading: false,
      legend: ['新增新客数'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: '新增新客总数',
          tips: '当前活码累计新增的新客总数',
          value: 0,
        },
        {
          title: '今日新增新客数',
          tips: '今日通过当前活码新增的客户总数',
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
  methods: {
    dealDate(data) {
      return moment(data).format('YYYY-MM-DD')
    },
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
    // getTabTotalFn() {
    //   getIdentityCodeTab({ id: this.id, addWeUserState: this.addWeUserState }).then((res) => {
    //     this.cardData[0].value = res.data.tdNewCustomerScanNumber
    //     // this.cardData[0].value1 =
    //     //   Number(res.data.tdNewCustomerScanNumber) - Number(res.data.ydNewCustomerScanNumber)
    //     this.cardData[1].value = res.data.tdAddCustomerNumber
    //     this.cardData[1].value1 =
    //       Number(res.data.tdAddCustomerNumber) - Number(res.data.ydAddCustomerNumber)
    //     // this.cardData[2].value = res.data.tdOldCustomerScanNumber
    //     // this.cardData[2].value1 =
    //     //   Number(res.data.tdOldCustomerScanNumber) - Number(res.data.ydOldCustomerScanNumber)
    //     // this.cardData[3].value = res.data.tdLostCustomerNumber
    //     // this.cardData[3].value1 =
    //     //   Number(res.data.tdLostCustomerNumber) - Number(res.data.ydLostCustomerNumber)
    //   })
    // },
    getLineData(data) {
      // this.$forceUpdate()
      // console.log(177, this.form)
      data.qrId = this.form.id
      data.qrName = this.form.name
      let qrUserIds = []
      if (this.form.qrUserInfos) {
        this.form.qrUserInfos.forEach((item) => {
          if (item.scopeType === 1) {
            qrUserIds.push(item.userId)
          }
        })
      }
      data.qrUserIds = qrUserIds.toString()
      data.type = this.form.type
      getLineData(data).then((res) => {
        this.xdata = []
        this.series = []
        if (res.data) {
          this.cardData[0].value = res.data.total
          this.cardData[1].value = res.data.today
          this.cardData[1].value1 = res.data.todayDiff
          this.xdata = res.data.xaxis
          this.series = [res.data.yaxis]
          // this.$forceUpdate()
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      // this.query.id = this.id
      getTableData(Object.assign({}, this.query)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.loading = true

      this.query.qrId = this.form.id
      this.query.qrName = this.form.name
      let qrUserIds = []
      if (this.form.qrUserInfos) {
        this.form.qrUserInfos.forEach((item) => {
          if (item.scopeType === 1) {
            qrUserIds.push(item.userId)
          }
        })
      }

      this.query.qrUserIds = qrUserIds.toString()
      this.query.type = this.form.type
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
      // getTableData(Object.assign({}, this.query, data)).then((res) => {
      //   this.tableList = res.rows
      //   this.total = Number(res.total)
      //   this.loading = false
      // })
    },
  },
  created() {
    this.addWeUserState = this.$route.query.addWeUserState
    this.id = this.$route.query.groupId
    // this.getTabTotalFn()
    // this.getTableFn()
  },
}
</script>
<style lang="scss" scoped></style>
