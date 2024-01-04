<template>
  <div>
    <CardGroupIndex :data="cardData" />

    <RequestChartTable
      type="lineChart"
      title="数据趋势"
      isTimeQuery
      :isCreateRequest="false"
      :params="{ keywordGroupId: $route.query.id }"
      :request="api.getDataTrend"
      :legend="['今日访问客户数', '今日进群客户数']"
      :dealDataFun="dealDataTrend" />

    <RequestChartTable
      title="数据明细"
      ref="importRecord"
      :request="getDataDetail"
      :params="{ keywordGroupId: $route.query.id }"
      :requestExport="api.getDataDetailExport"
      exportFileName="关键词群数据明细导出.xls">
      <template #queryMiddle="{ query }">
        <el-form-item label="" prop="customerName">
          <el-input v-model="query.customerName" placeholder="请输入客户名称"></el-input>
        </el-form-item>
        <el-form-item label="">
          <el-date-picker
            v-model="query.dateRangeAddTime"
            value-format="YYYY-MM-DD"
            type="daterange"
            v-bind="pickerOptions"
            range-separator="-"
            start-placeholder="添加开始"
            end-placeholder="结束日期"
            align="right"></el-date-picker>
        </el-form-item>
        <!-- <el-form-item label="" prop="isJoinGroup">
          <el-select v-model="query.isJoinGroup" placeholder="请选择是否进群">
            <el-option v-for="(item, index) in dictAddStatus" :key="index" :label="item" :value="index"></el-option>
          </el-select>
        </el-form-item> -->
      </template>

      <template #="{ data }">
        <el-table :data="data">
          <el-table-column align="center" prop="customerName" label="客户">
            <template #default="{ row }">
              <div class="cp flex aic">
                <el-image class="avatar" :src="row.avatar" fit="fill"></el-image>
                <div class="ml10">
                  <p class="blod">{{ row.customerName }}</p>
                  <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[row.gender]]" />
                  <span :style="{ color: row.customerType === 1 ? '#4bde03' : '#f9a90b' }">
                    {{ { 1: '@微信', 2: '@企业微信' }[row.customerType] }}
                  </span>
                </div>
              </div>
            </template>
          </el-table-column>
          <el-table-column align="center" prop="addUserName" label="添加员工">
            <template #default="{ row }">{{ row.addUserName || '—' }}</template>
          </el-table-column>
          <el-table-column align="center" prop="addTime" label="添加时间">
            <template #default="{ row }">{{ row.addTime || '—' }}</template>
          </el-table-column>
          <el-table-column align="center" prop="groupName" label="进入客群">
            <template #default="{ row }">
              <div
                v-if="row.joinGroupNumber && row.joinGroupNumber + '' >= '0'"
                class="g-color cp"
                @click="
                  ;(externalUserid = row.externalUserid),
                    (dialogVisible = true),
                    $refs.RequestChartTableDialog?.getList()
                ">
                {{ row.joinGroupNumber }}
              </div>
              <div v-else>—</div>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center">
            <template #default="{ row }">
              <el-button
                text
                @click="
                  $router.push({
                    name: lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
                    query: { externalUserid: row.externalUserid, userId: row.addUserId },
                  })
                ">
                客户详情
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>
    </RequestChartTable>

    <el-dialog title="进入客群" v-model="dialogVisible" :close-on-click-modal="false">
      <RequestChartTable
        ref="RequestChartTableDialog"
        style="padding: 0 0 20px 0"
        :params="{ keywordGroupId: $route.query.id, externalUserid }"
        :request="api.getCustomerToGroupList">
        <template #="{ data }">
          <el-table :data="data">
            <el-table-column label="客群名称" align="center" prop="groupName"></el-table-column>
            <el-table-column align="center" prop="joinTime" label="进群时间">
              <template #default="{ row }">{{ row.joinTime || '—' }}</template>
            </el-table-column>
          </el-table>
        </template>
      </RequestChartTable>
    </el-dialog>
  </div>
</template>

<script setup>
import * as api from './api'

let loading = ref(false)
let id = useRoute().query.id
let cardData = ref([])
let dictAddStatus = { 0: '未进群', 1: '已进群' }
let dialogVisible = ref(false)

// 获取指标数据
;(function getStatistic() {
  loading.value = true
  api
    .getStatistic(id)
    .then(({ data }) => {
      cardData.value = [
        {
          title: '访问客户总数',
          tips: '访问关键词链接的客户总数(去重)',
          value: data.totalViewNumber,
        },
        {
          title: '进群客户总数',
          tips: '访问客户中成功进群的总数(去重)',
          value: data.totalJoinGroupNmber,
        },
        {
          title: '今日访问客户数',
          tips: '今日访问关键词链接的客户数(去重)',
          value: data.tdViewNumber,
        },
        {
          title: '今日进群客户数',
          tips: '今日访问客户中成功进群数(去重)',
          value: data.tdJoinGroupNmber,
          // unit: '%',
        },
      ]
    })
    .finally(() => {
      loading.value = false
    })
})()

// 数据趋势 数据处理
function dealDataTrend(data, series, xData) {
  xData.length = 0
  series.length = 0
  let _data = [[], []]
  data.forEach((element) => {
    xData.push(element.date)
    _data[0].push(element.tdViewNumber)
    _data[1].push(element.tdJoinGroupNmber)
  })
  series.push(..._data)
}

// 数据明细
function getDataDetail(query) {
  query.id = id
  if (query.dateRangeAddTime) {
    query.startAddTime = query.dateRangeAddTime[0]
    query.endAddTime = query.dateRangeAddTime[1]
  } else {
    delete query.startAddTime
    delete query.endAddTime
  }
  delete query.dateRangeAddTime

  if (query.dateRangeJoinTime) {
    query.startJoinTime = query.dateRangeJoinTime[0]
    query.endJoinTime = query.dateRangeJoinTime[1]
  } else {
    delete query.startJoinTime
    delete query.endJoinTime
  }
  delete query.dateRangeJoinTime
  return api.getDataDetail(query)
}

/** 获取详情中客群列表 */
// let groups = []
// ;(function getDetail() {
//   api.getDetail(id).then(({ data }) => {
//     groups = data.groups
//   })
// })()
</script>

<style lang="scss" scoped>
.avatar {
  width: 56px;
  height: 56px;
  flex: none;
  border-radius: var(--border-radius-big);
}
.el-icon-Avatar {
  font-size: 16px;
  // margin-left: 4px;
  color: var(--font-black-6);
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
</style>
