<script>
import ChartPie from '@/components/ChartPie'

import TabContent from '../components/TabContent'
import { getAnalysisArchive, getArchiveList } from '@/api/operateCenter/conversationAnalysis'
export default {
  name: '',
  components: { TabContent, ChartPie },
  data() {
    return {
      loading: false,
      // 查询参数
      query: {
        pageNum: undefined,
        pageSize: undefined,
      },
      cardData: [],
      pieData: {},
      total: 0,
      // 表格数据
      list: [],
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getAnalysisArchive()
    this.getList()
  },
  mounted() {},
  methods: {
    getAnalysisArchive() {
      this.loading = true
      getAnalysisArchive()
        .then(({ data }) => {
          data || (data = {})
          this.cardData = [
            {
              title: '开启会话存档员工',
              value: data.openUserCnt,
            },
            {
              title: '未开启会话存档员工',
              value: data.notOpenUserCnt,
            },
            {
              title: '已同意会话存档客户',
              value: data.openCustomerCnt,
            },
            {
              title: '未同意会话存档客户',
              value: data.notOpenCustomerCnt,
            },
          ]
          this.pieData.staff = [
            {
              name: '开启',
              value: (data.openUserCnt / (data.openUserCnt + data.notOpenUserCnt || 1)) * 100,
            },
            {
              name: '未开启',
              value: (data.notOpenUserCnt / (data.openUserCnt + data.notOpenUserCnt || 1)) * 100,
            },
          ]
          this.pieData.customer = [
            {
              name: '已同意',
              value: (data.openCustomerCnt / (data.openCustomerCnt + data.notopenCustomerCnt || 1)) * 100,
            },
            {
              name: '未同意',
              value: (data.notOpenCustomerCnt / (data.openCustomerCnt + data.notOpenCustomerCnt || 1)) * 100,
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
    getList() {
      this.loading = true
      getArchiveList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = Number(total)
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
      <div class="g-card-title">数据占比</div>
      <el-row :gutter="10">
        <el-col :span="12">
          <ChartPie
            :series="pieData.staff"
            :option="{ series: { tooltip: { valueFormatter: (value) => value + '%' } } }"></ChartPie>
          <div class="ac">会话存档员工开启情况统计</div>
        </el-col>
        <el-col :span="12">
          <ChartPie
            :series="pieData.customer"
            :option="{ series: { tooltip: { valueFormatter: (value) => value + '%' } } }"></ChartPie>
          <div class="ac">会话存档客户同意情况统计</div>
        </el-col>
      </el-row>
    </div>

    <div class="g-card">
      <div class="g-card-title">会话存档同意明细</div>
      <el-table :data="list" style="width: 100%">
        <el-table-column align="center" prop="userName" label="存档员工"></el-table-column>
        <el-table-column align="center" prop="customerName" label="客户"></el-table-column>
        <el-table-column align="center" prop="openChatTime" label="同意时间"></el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>
  </div>
</template>

<style lang="scss" scoped>
.chart-pie {
  height: 400px;
}
</style>
