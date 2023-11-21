<script>
import TabContent from './components/TabContent'

import TabContentRealGroupData from './components/TabContentRealGroupData'
import * as api from '@/api/operateCenter/groupAnalysis'
export default {
  name: '',
  components: { TabContent, TabContentRealGroupData },
  data() {
    return {
      cardData: [],
      activeTrend: '0',
      activeSheet: '0',
      api,
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>企业客户群相关数据统计与分析</div>
      `,
    )
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      api
        .getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '客群总数',
              tips: '企业员工全部客户群数量',
              value: data.totalCnt,
            },
            {
              title: '今日新增客群',
              tips: '今日新创建的客群数',
              value: data.tdGroupAddCnt,
              title1: '较昨日',
              value1: data.ydGroupAddCnt,
            },
            {
              title: '今日解散客群',
              tips: '今日解散的客户群数',
              value: data.tdGroupDissolveCnt,
              title1: '较昨日',
              value1: data.ydGroupDissolveCnt,
            },
            {
              title: '客群成员总数',
              tips: '全部客群成员的总数，包括企业员工',
              value: data.memberTotalCnt,
              title1: '含员工',
              value1: data.memberUserCnt,
              noArrow: true,
            },
            {
              title: '今日新增客群成员',
              tips: '今日进入群聊的成员数量，包括企业员工',
              value: data.tdMemberAddCnt,
              title1: '较昨日',
              value1: data.ydMemberAddCnt,
            },
            {
              title: '今日退出客群成员',
              tips: '今日退出群聊的成员数量，包括企业员工',
              value: data.tdMemberQuitCnt,
              title1: '较前日',
              value1: data.ydMemberQuitCnt,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <el-tabs v-model="activeTrend">
        <el-tab-pane label="客群总数">
          <TabContent type="customerGroupTotalChart" legend="客群总数" :request="api.getTotalCnt"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="客群成员总数">
          <TabContent
            type="customerGroupMemberTotalChart"
            legend="客群成员总数"
            :request="api.getTotalCntMember"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="实时数据">
          <TabContentRealGroupData></TabContentRealGroupData>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <el-tabs v-model="activeSheet">
        <el-tab-pane label="客群总数">
          <TabContent
            type="customerGroupTotalTable"
            :request="api.getRealCnt"
            :requestExport="api.realDataExport"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="客群成员总数">
          <TabContent
            type="customerGroupMemberTotalTable"
            :request="api.getRealCntMember"
            :requestExport="api.realDataExportMember"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
