<script>
import TabContent from './components/TabContent'

import * as api from '@/api/operateCenter/customerAnalysis'
export default {
  name: '',
  components: { TabContent },
  data() {
    return {
      cardData: [],
      active: '0',
      api,
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>企业客户相关数据统计与分析</div>
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
              title: '客户总数',
              tips: '企业员工全部客户数量（包含重复）',
              value: data.totalCnt,
              title1: '含重复',
              value1: data.repeatCnt,
              noArrow: true,
            },
            {
              title: '今日新增客户',
              tips: '企业员工今日添加的客户数（包含重复及已流失）',
              value: data.tdCnt,
              title1: '较昨日',
              value1: data.ydCnt,
            },
            {
              title: '今日流失客户',
              tips: '今日删除企业员工的客户数',
              value: data.tdLostCnt,
              title1: '较昨日',
              value1: data.ydLostCnt,
            },
            {
              title: '今日净增客户',
              tips: '企业员工今日添加的客户数（不包含重复及已流失）',
              value: data.tdNetCnt,
              title1: '较昨日',
              value1: data.ydNetCnt,
            },
            {
              title: '昨日发送申请',
              tips: '企业员工每天通过搜索手机号、扫一扫等渠道主动向客户发起的好友申请数',
              value: data.ydNewApplyCnt,
              title1: '较前日',
              value1: data.bydNewApplyCnt,
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
      <el-tabs v-model="active">
        <el-tab-pane label="客户总数">
          <TabContent type="customerTotalChart" legend="客户总数" :request="api.getTotalCnt"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="实时数据">
          <TabContent
            type="realDataChart"
            :legend="['新增客户数', '流失客户数', '净增客户数', '发送申请数']"
            :request="api.getRealCnt"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div class="g-card">
      <div class="g-card-title">员工客户Top10</div>
      <TabContent type="staffCustomerBar" :request="api.getRankCnt"></TabContent>
    </div>

    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <TabContent type="customerTotalTable" :request="api.getRealCnt" :requestExport="api.realDataExport"></TabContent>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
