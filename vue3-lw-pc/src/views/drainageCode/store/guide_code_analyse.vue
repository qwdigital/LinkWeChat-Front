<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :showMore="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">门店新增客户Top10</div>
      <search-title @search="getTop10Fn"></search-title>
      <chart-bar style="height: 300px" :xData="bar" :series="value" :legend="barLegend"></chart-bar>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <div class="mid-action">
        <search-title :showMore="true" @search="getTableFn"></search-title>
        <el-button type="primary" @click="exportFn" v-loading="exportLoading">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="日期" align="center" min-width="100" prop="createTime" show-overflow-tooltip />
        <el-table-column label="所属地区" align="center" min-width="100" prop="area" show-overflow-tooltip />
        <el-table-column
          label="门店名称"
          align="center"
          prop="storeName"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="点击/扫码总次数"
          align="center"
          prop="totalScannNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="新增客户总数"
          align="center"
          prop="customerTotalNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="今日点击/扫码总数"
          align="center"
          prop="tdScannNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="今日新增客户数"
          align="center"
          prop="tdCustomerNumber"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180">
          <template #default="{ row }">
            <el-button
              text
              @click="
                $router.push({
                  path: 'detail',
                  query: {
                    id: row.storeCodeId,
                  },
                })
              ">
              详情
            </el-button>
          </template>
        </el-table-column>
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
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '../components/SearchTitleInStore.vue'

import {
  getGuideCodeTab,
  getLineDataGuideCode,
  getBarTop10GuideCode,
  getTableInGuideCode,
  getTableGuideCodeExport,
} from '@/api/drainageCode/store'
import { download } from '@/utils/common'
export default {
  name: 'guide-code-statistics',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
  },
  data() {
    return {
      exportLoading: false,
      barLegend: ['门店'],
      legend: ['点击/扫码次数', '新增客户数'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: '点击/扫码总次数',
          tips: '进入门店导购码页面的总人数（去重）',
          value: 0,
          noArrow: true,
        },
        {
          title: '新增客户总人数',
          tips: '成功添加门店导购的客户数（去重）',
          value: 0,
          noArrow: true,
        },
        {
          title: '今日点击/扫码次数',
          tips: '今日进入门店导购码页面的总人数（去重）',
          value: 0,
          title1: '较前日',
          value1: 0,
        },
        {
          title: '今日新增客户数',
          tips: '今日成功添加门店导购的客户数（去重）',
          value: 0,
          title1: '较前日',
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
          return getTableGuideCodeExport(Object.assign({}, this.query, this.tableSearch))
        })
        .then((res) => {
          download(res.data)
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    getTabTotalFn() {
      getGuideCodeTab().then((res) => {
        this.cardData[0].value = res.data.totalShopGuideScannNumber
        this.cardData[1].value = res.data.customerTotalNumber
        this.cardData[2].value = res.data.tdShopGuideScannNumber
        this.cardData[2].value1 = res.data.ydShopGuideScannNumber
        this.cardData[3].value = res.data.ydCustomerNumber
        this.cardData[3].value1 = res.data.tdCustomerNumber
      })
    },
    getLineData(data) {
      // this.$forceUpdate()
      getLineDataGuideCode(data).then((res) => {
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        if (res.data && res.data.length) {
          res.data.forEach((dd) => {
            this.xdata.push(dd.dataTime)
            arr1.push(dd.totalShopGuideScannNumber)
            arr2.push(dd.customerTotalNumber)
          })
          this.series = [arr1, arr2]
          // this.$forceUpdate()
        }
      })
    },
    getTop10Fn(data) {
      getBarTop10GuideCode(data).then((res) => {
        if (res.data && res.data.length) {
          this.bar = []
          this.value = []
          res.data.forEach((dd) => {
            this.bar.push(dd.storeName)
            this.value.push(dd.customerNumber)
          })
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      getTableInGuideCode(Object.assign({}, this.query, this.tableSearch)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
    getTableFn(data) {
      this.loading = true
      this.tableSearch = data
      getTableInGuideCode(Object.assign({}, this.query, data)).then((res) => {
        this.tableList = res.rows
        this.total = Number(res.total)
        this.loading = false
      })
    },
  },
  created() {
    this.getTabTotalFn()
    // this.getTop5Fn()
  },
}
</script>
<style lang="scss" scoped>
.total-list {
  .item {
    padding: 10px;
    background: var(--bg-white);
  }
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
