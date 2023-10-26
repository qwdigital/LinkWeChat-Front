<template>
  <div>
    <CardGroupIndex :data="$datas.cardData" />

    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <DateSearchChartTable
        :request="api.getDataTrend"
        :legend="['导入线索数', '添加客户数', '线索日跟进人数']"
        :dealDataFun="dealDataTrend" />
    </div>

    <div style="display: grid; grid: auto/auto auto; gap: 0 var(--card-margin); margin-top: var(--card-margin)">
      <div class="g-card">
        <div class="g-card-title">线索转化Top5</div>
        <DateSearchChartTable
          :request="api.getConversionTop"
          type="barChart"
          :option="{
            xAxis: [{ type: 'value' }],
            yAxis: [{ type: 'category', data: $datas.xDataConversionTop }],
          }"
          :dealDataFun="dealDataConversionTop" />
      </div>
      <div class="g-card mt0">
        <div class="g-card-title">线索日跟进Top5</div>
        <DateSearchChartTable :request="api.getFollowTop" type="barChart" :dealDataFun="dealDataFollowTop" />
      </div>
    </div>

    <div class="g-card">
      <div class="g-card-title">导入记录</div>
      <DateSearchChartTable
        ref="importRecord"
        :isTimeQuery="false"
        :request="api.getImportRecord"
        :requestExport="api.getImportRecordExport"
        exportFileName="导入记录.xls"
        type="table">
        <template #query="{ query }">
          <el-input
            style="width: 280px"
            v-model="query.name"
            placeholder="请输入表格名称"
            @keyup.enter="$refs.importRecord.getList()">
            <template #append>
              <el-button icon="elIconSearch" @click="$refs.importRecord.getList()" />
            </template>
          </el-input>
        </template>
        <template #table="{ data }">
          <el-table :data="data">
            <el-table-column align="center" prop="importSourceFileName" label="导入来源"></el-table-column>
            <el-table-column align="center" prop="num" label="导入线索总数"></el-table-column>
            <el-table-column align="center" prop="importTime" label="导入时间"></el-table-column>
            <el-table-column align="center" prop="seaName" label="所属公海池"></el-table-column>
            <el-table-column align="center" prop="conversionRate" label="线索转化率"></el-table-column>
            <el-table-column align="center" prop="returnRate" label="线索退回率"></el-table-column>
            <el-table-column align="center" prop="followNum" label="线索日跟进人次"></el-table-column>
            <el-table-column align="center" prop="customerNum" label="已添加客户数"></el-table-column>
          </el-table>
        </template>
      </DateSearchChartTable>
    </div>

    <div class="g-card">
      <div class="g-card-title">员工统计</div>
      <DateSearchChartTable
        :request="api.getStatisticUser"
        :requestExport="api.getStatisticUserExport"
        exportFileName="员工统计.xls"
        isStaffQuery
        type="table">
        <template #table="{ data }">
          <el-table :data="data">
            <!-- <el-table-column align="center" prop="" label="日期"></el-table-column> -->
            <el-table-column align="center" prop="userName" label="员工名称"></el-table-column>
            <el-table-column align="center" prop="deptName" label="所属部门"></el-table-column>
            <el-table-column align="center" prop="conversionRate" label="线索转化率"></el-table-column>
            <el-table-column align="center" prop="returnRate" label="线索退回率"></el-table-column>
            <el-table-column align="center" prop="followNum" label="线索日跟进人次"></el-table-column>
            <el-table-column align="center" prop="customerNum" label="已添加客户数"></el-table-column>
          </el-table>
        </template>
      </DateSearchChartTable>
    </div>
  </div>
</template>

<script setup>
import * as api from '@/views/clue/clueAnalysis/api'
import { reactive } from 'vue'
import stores from '@/stores'

stores().setBusininessDesc(`对全部公海池以及公海池内的线索数据进行数据解析并支持导入本地`)

// 响应式变量统一放到$datas，避免繁琐的.value和遍地的ref、reactive定义
let $datas = reactive({ loading: false })

// 获取指标数据
;(function getStatistic() {
  $datas.loading = true
  api
    .getStatistic()
    .then(({ data }) => {
      $datas.cardData = [
        {
          title: '添加客户总数',
          tips: '通过此活码添加的客户总数(去重)',
          value: data.totalNum,
        },
        {
          title: '进群客户总数',
          tips: '添加客户中成功进群的总数(去重)',
          value: data.customerNum,
        },
        {
          title: '今日添加客户数',
          tips: '今日通过此活码添加的客户数(去重)',
          // tips: '当日内被员工产生过跟进行为的客户人数（去重）',
          value: data.followNum,
        },
        {
          title: '今日进群客户数',
          tips: '今日添加客户中成功进群数(去重)',
          value: data.conversionRate,
          // unit: '%',
        },
      ]
    })
    .finally(() => {
      $datas.loading = false
    })
})()

// 数据趋势 数据处理
function dealDataTrend(data, series, xData) {
  xData.length = 0
  series.length = 0
  let _data = [[], [], []]
  data.forEach((element) => {
    xData.push(element.dateStr)
    _data[0].push(element.leadsNum) // 导入线索数
    _data[1].push(element.customerNum) // 添加客户数
    _data[2].push(element.followNum) // 线索日跟进人数
  })
  series.push(..._data)
}

// 线索转化Top5 数据处理
function dealDataConversionTop(data, series, xData) {
  series.length = 0
  $datas.xDataConversionTop = []
  if (data?.length) {
    let _data = []
    data.forEach((element) => {
      $datas.xDataConversionTop.push(element.userName)
      _data.push(element.rate)
    })
    series.push(_data)
  }
}

// 线索日跟进Top5 数据处理
function dealDataFollowTop(data, series, xData) {
  xData.length = 0
  series.length = 0
  if (data?.length) {
    let _data = []
    data.forEach((element) => {
      xData.push(element.userName)
      _data.push(element.followNum)
    })
    series.push(_data)
  }
}
</script>

<style lang="scss" scoped></style>
