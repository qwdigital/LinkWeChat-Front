<template>
  <div>
    <div style="display: flex">
      <div class="g-card" style="flex: 0.4">
        <div class="title">门店导购码</div>
        <div class="header_content">
          <div class="unit">
            <div class="title">
              点击/扫码总次数
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div style="margin-left: 8px; cursor: pointer">
                    <img src="../../../assets/marketstrategy/help.svg" alt="" />
                  </div>
                </template>
                <div>进入门店导购码页面的总人数（去重）</div>
              </el-popover>
            </div>
            <div class="value">
              {{ data.totalShopGuideScannNumber || '-' }}
            </div>
            <div class="sub_content">
              <span>今日</span>
              <span style="font-size: 14px">{{ data.tdShopGuideScannNumber || '-' }}</span>
            </div>
          </div>
          <div class="unit">
            <div class="title">
              新增客户总人数
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div style="margin-left: 8px; cursor: pointer">
                    <img src="../../../assets/marketstrategy/help.svg" alt="" />
                  </div>
                </template>
                <div>成功添加门店导购的客户数（去重）</div>
              </el-popover>
            </div>
            <div class="value">
              {{ data.customerTotalNumber || '-' }}
            </div>
            <div class="sub_content">
              <span>今日</span>
              <span style="font-size: 14px">{{ data.ydCustomerNumber || '-' }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="g-card" style="flex: 0.6; margin-top: 0; margin-left: 20px">
        <div class="title">门店群活码</div>
        <div class="header_content">
          <div class="unit">
            <div class="title">
              点击/扫码总次数
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div style="margin-left: 8px; cursor: pointer">
                    <img src="../../../assets/marketstrategy/help.svg" alt="" />
                  </div>
                </template>
                <div>进入门店导购码页面的总人数（去重）</div>
              </el-popover>
            </div>
            <div class="value">
              {{ data.totalStoreGroupScannNumber || '-' }}
            </div>
            <div class="sub_content">
              <span>今日</span>
              <span style="font-size: 14px">{{ data.tdStoreGroupScannNumber || '-' }}</span>
            </div>
          </div>
          <div class="unit">
            <div class="title">
              进群总客户数
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div style="margin-left: 8px; cursor: pointer">
                    <img src="../../../assets/marketstrategy/help.svg" alt="" />
                  </div>
                </template>
                <div>成功添加门店客户群的客户数（去重）</div>
              </el-popover>
            </div>
            <div class="value">
              {{ data.totalJoinGroupMemberNumber || '-' }}
            </div>
            <div class="sub_content">
              <span>今日</span>
              <span style="font-size: 14px">{{ data.tdJoinGroupMemberNumber || '-' }}</span>
            </div>
          </div>
          <div class="unit">
            <div class="title">
              退群总客户数
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <div style="margin-left: 8px; cursor: pointer">
                    <img src="../../../assets/marketstrategy/help.svg" alt="" />
                  </div>
                </template>
                <div>退出门店客户群的客户数（去重）</div>
              </el-popover>
            </div>
            <div class="value">
              {{ data.totalExitGroupMemberNumber || '-' }}
            </div>
            <div class="sub_content">
              <span>今日</span>
              <span style="font-size: 14px">{{ data.tdExitGroupMemberNumber || '-' }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="g-card">
      <div class="g-card-title">数据概览</div>
      <div class="data-content">
        <el-tabs v-model="activeName">
          <el-tab-pane label="门店导购码" name="first"></el-tab-pane>
          <el-tab-pane label="门店群活码" name="second"></el-tab-pane>
        </el-tabs>
        <div class="chart-content">
          <search-title key="11" v-if="activeName === 'first'" @search="getLineDataFirst"></search-title>
          <search-title key="22" v-if="activeName === 'second'" @search="getLineDataSecond"></search-title>
          <chart-line
            key="444"
            style="height: 300px"
            v-if="activeName === 'first'"
            :legend="legend"
            :xData="xdata"
            :series="series"></chart-line>
          <chart-line
            key="333"
            style="height: 300px"
            v-if="activeName === 'second'"
            :legend="legend1"
            :xData="xdata1"
            :series="series1"></chart-line>
        </div>
      </div>
    </div>

    <RequestChartTable
      title="数据明细"
      ref="importRecord"
      :request="getDataDetail"
      :requestExport="(query) => ((query.storeCodeId = $route.query.id), getDataDetailExport(query))"
      exportFileName="门店活码数据明细导出.xls">
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
        <el-form-item label="" prop="isJoinGroup">
          <el-select v-model="query.isJoinGroup" placeholder="请选择是否进群">
            <el-option v-for="(item, index) in dictAddStatus" :key="index" :label="item" :value="index"></el-option>
          </el-select>
        </el-form-item>
      </template>

      <template #="{ data }">
        <el-table :data="data">
          <el-table-column align="center" prop="customerName" label="客户名称"></el-table-column>
          <el-table-column align="center" prop="addUserId" label="添加员工"></el-table-column>
          <el-table-column align="center" prop="addTime" label="添加时间"></el-table-column>
          <el-table-column align="center" prop="isJoinGroup" label="是否进群">
            <template #default="{ row }">{{ dictAddStatus[row.isJoinGroup] }}</template>
          </el-table-column>
          <el-table-column align="center" prop="groupName" label="进入客群">
            <template #default="{ row }">
              <div
                class="g-color cp"
                @click="
                  ;(externalUserid = row.externalUserid),
                    (dialogVisible = true),
                    $refs.RequestChartTableDialog?.getList()
                ">
                {{ row.joinGroupNumber }}
              </div>
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
        :params="{ storeCodeId: $route.query.id, externalUserid: externalUserid }"
        :request="getCustomerToGroupList">
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
<script>
import SearchTitle from '@/components/SearchTitle'
import { crowdAnalyse } from '@/api/marketStrategy/people'
import ChartLine from '@/components/ChartLine.vue'

import {
  getTabTotalInStore,
  getLineDataGuideCode,
  getLineDataStoreCode,
  getDataDetail,
  getDataDetailExport,
  getCustomerToGroupList,
} from '@/api/drainageCode/store'
export default {
  name: 'store-analyse',
  components: {
    ChartLine,
    SearchTitle,
  },
  data() {
    return {
      activeName: 'first',
      xdata: [],
      series: [],
      legend: ['点击/扫码次数', '新增客户数'],
      xdata1: [],
      series1: [],
      legend1: ['点击/扫码次数', '进群客户数', '退群客户数'],
      query: {
        beginTime: '',
        endTime: '',
        storeCodeId: '',
      },
      data: {
        totalShopGuideScannNumber: 0, // 导购码 扫码总次数
        tdShopGuideScannNumber: 0, // 导购码 今日扫码总次数
        customerTotalNumber: 0, // 导购码 新增客户总数
        ydCustomerNumber: 0, // 导购码 今日新增客户数
        totalStoreGroupScannNumber: 0, // 门店群活码  扫码总次数
        tdStoreGroupScannNumber: 0, // 门店群活码  今日扫码总次数
        totalJoinGroupMemberNumber: 0, // 门店群活码 扫码进群总次数
        tdJoinGroupMemberNumber: 0, // 门店群活码 今日扫码进去总次数
        totalExitGroupMemberNumber: 0, // 门店群活码 离群总次数
        tdExitGroupMemberNumber: 0, // 门店群活码 今日离群总次数
      },
      getDataDetailExport,
      getCustomerToGroupList,
      externalUserid: '',
      dialogVisible: false,
      dictAddStatus: { 0: '未进群', 1: '已进群' },
    }
  },
  created() {
    this.query.storeCodeId = this.$route.query.id
    this.initData()
  },
  methods: {
    initData() {
      getTabTotalInStore(this.query.storeCodeId).then((res) => {
        if (res.code === 200) {
          this.data = res.data
        }
      })
    },
    getLineDataSecond(data) {
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      getLineDataStoreCode(this.query).then((res) => {
        this.xdata1 = []
        this.series1 = []
        let arr1 = []
        let arr2 = []
        let arr3 = []
        if (res.data && res.data.length) {
          res.data.forEach((dd) => {
            this.xdata1.push(dd.dataTime)
            arr1.push(dd.totalStoreGroupScannNumber)
            arr2.push(dd.totalJoinGroupMemberNumber)
            arr3.push(dd.totalExitGroupMemberNumber)
          })
          this.series1 = [arr1, arr2, arr3]
          // this.$forceUpdate()
        }
      })
    },
    getLineDataFirst(data) {
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      getLineDataGuideCode(this.query).then((res) => {
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
    // 数据明细
    getDataDetail(query) {
      query.storeCodeId = this.$route.query.id
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
      return getDataDetail(query)
    },
  },
}
</script>
<style lang="scss" scoped>
.title {
  font-size: 16px;
  color: var(--font-black);
  font-weight: 600;
}
.header_content {
  display: flex;
  flex: 1;
  .unit {
    background: var(--bg-white);
    // box-shadow: 0px 6px 30px 5px rgba(59, 59, 59, 0.05);
    border-radius: 8px;
    margin-right: 16px;
    flex: 1;
    // height: 100px;
    padding: 18px 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    .title {
      font-size: 14px;
      font-weight: 500;
      color: var(--font-black-5);
      display: flex;
      justify-content: space-between;
    }
    .value {
      margin: 10px 0;
      font-size: 28px;
      font-weight: bold;
      color: var(--color);
    }
    .sub_content {
      font-size: 12px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }
}
.bar_content {
  margin-top: 16px;
  background: var(--bg-white);
  border-radius: 8px;
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
