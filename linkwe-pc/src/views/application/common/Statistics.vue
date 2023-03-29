<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :showMore="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px;" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
  </div>
</template>
<script>
  import { dateFormat } from '@/utils/index'
  import ChartLine from '@/components/ChartLine.vue'
  import SearchTitle from '@/components/SearchTitle.vue'
  import { getTotal, getLineData } from '../taskGroup/api'
  export default {
    name: 'fission-statistics',
    components: {
      SearchTitle,
      ChartLine
    },
    props: {
      fissionType: {
        type: Number,
        default: 1
      }
    },
    watch: {
      fissionType(val) {
        this.$forceUpdate()
      }
    },
    data() {
      return {
        legend: ['访问总数（pv）', '访问总人数（uv）', '小程序打开数'],
        xdata: [],
        series: [],
        cardData: [
          {
            title: this.fissionType == 1 ? '员工邀请老客总数' : '员工触达客群总数',
            tips: this.fissionType == 1 ? '在当前任务中员工已送达的客户总数' : '在当前任务中员工已送达的客群总数',
            value: 0
          },
          {
            title: this.fissionType == 1 ? '完成任务老客总数' : '完成任务客户总数',
            tips: this.fissionType == 1 ? '在当前任务中完成裂变任务的老客总数' : '在当前任务中完成裂变任务的客户总数',
            value: 0
          },
          {
            title: '裂变新客总数',
            tips: this.fissionType == 1 ? '在当前任务中成功添加员工的新客总数' : '在当前任务中成功添加客群的新客总数',
            value: 0
          },
          {
            title: this.fissionType == 1 ? '今日完成任务老客数' : '今日完成任务客户数',
            tips:
              this.fissionType == 1 ? '在当前任务中今日完成裂变任务的老客数' : '在当前任务中今日完成裂变任务的客户数',
            value: 0,
            title1: '较昨日',
            value1: 0
          },
          {
            title: '今日裂变新客数',
            tips:
              this.fissionType == 1 ? '在当前任务中今日成功添加员工的新客数' : '在当前任务中今日成功添加客群的新客总数',
            value: 0,
            title1: '较昨日',
            value1: 0
          }
        ],
        value: [],
        id: ''
      }
    },
    methods: {
      getTabTotalFn() {
        getTotal(this.id).then((res) => {
          this.cardData[0].value = res.data.inviterOldCustomerNum
          this.cardData[1].value = res.data.completeTaskOldCustomerNum
          this.cardData[2].value = res.data.fissionCustomerNum
          this.cardData[3].value = res.data.tdCompleteTaskOldCustomerNum
          this.cardData[3].value1 =
            Number(res.data.tdCompleteTaskOldCustomerNum) - Number(res.data.ydCompleteTaskOldCustomerNum)
          this.cardData[4].value = res.data.tdFissionCustomerNum
          this.cardData[4].value1 = Number(res.data.tdFissionCustomerNum) - Number(res.data.ydFissionCustomerNum)
        })
      },
      getLineData(data) {
        this.$forceUpdate()
        data.promotionId = this.id
        getLineData(data).then(({ data }) => {
          this.xdata = data.xAxis
          this.series = [data.yAxis.pv, data.yAxis.uv, data.yAxis.open]
          this.$forceUpdate()
        })
      }
    },
    created() {
      this.id = this.$route.query.id
      this.getTabTotalFn()
    }
  }
</script>
<style lang="scss" scoped></style>
