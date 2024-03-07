<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <RequestChartTable
      title="数据趋势"
      type="lineChart"
      isTimeQuery
      :isCreateRequest="false"
      :legend="['累计扫码总数', '今日扫码数', '今日短链访问数', '今日短链访问人数']"
      :params="query"
      :request="getStatisticsLine"
      :dealDataFun="dealDataFun"></RequestChartTable>

    <RequestChartTable
      title="数据报表"
      isTimeQuery
      :request="getStatisticsTable"
      :params="query"
      :requestExport="exportStatisticsTable"
      exportFileName="客群活码数据报表导出.xls">
      <template #="{ data }">
        <el-table :data="data">
          <el-table-column label="日期" prop="dateTime" align="center"></el-table-column>
          <el-table-column label="累计扫码总数" prop="total" align="center"></el-table-column>
          <el-table-column label="今日扫码数" prop="today" align="center"></el-table-column>
          <!-- <el-table-column label="今日H5访问数" prop="errorMsg" align="center"></el-table-column>
          <el-table-column label="今日H5访问人数" prop="linkVisitsPeopleTotal" align="center"></el-table-column> -->
          <el-table-column label="今日短链访问数" prop="todayLinkVisitsTotal" align="center"></el-table-column>
          <el-table-column label="今日短链访问人数" prop="todayLinkVisitsPeopleTotal" align="center"></el-table-column>
        </el-table>
      </template>
    </RequestChartTable>
  </div>
</template>

<script setup>
import { getTotal, getStatisticsLine, getStatisticsTable, exportStatisticsTable } from '@/api/drainageCode/group'
import { useRoute } from 'vue-router'
const route = useRoute()

let query = {
  id: route.query.id,
}

let cardData = ref([])
;(function () {
  getTotal(query).then(({ data }) => {
    cardData.value = [
      {
        title: '累计扫码总数',
        tips: '当前累计扫码添加成功的总数(去重)',
        value: data.total,
      },
      {
        title: '今日扫码数',
        tips: '今日扫码添加成功的总人数(去重',
        value: data.today,
      },
      // {
      //   title: 'H5访问总数',
      //   tips: 'H5链接访问的总数(PV)',
      //   value: data.completionRate + '%',
      // },
      // {
      //   title: 'H5访问总人数',
      //   tips: 'H5链接访问的总人数(UV)',
      //   value: data.waitAddCustomerNum,
      // },
      {
        title: '短链访问总数',
        tips: '智能短链访问的总数(PV)',
        value: data.linkVisitsTotal,
      },
      {
        title: '短链访问总人数',
        tips: '智能短链访问的总人数(UV)',
        value: data.linkVisitsPeopleTotal,
      },
    ]
  })
})()

function dealDataFun(res, series, xData) {
  series.length = 0
  xData.length = 0
  res.forEach((e) => {
    ;(series[0] ??= []).push(e.total)
    ;(series[1] ??= []).push(e.today)
    ;(series[2] ??= []).push(e.todayLinkVisitsTotal)
    ;(series[3] ??= []).push(e.todayLinkVisitsPeopleTotal)
    xData.push(e.dateTime)
  })
}
</script>

<style lang="scss" scoped></style>
