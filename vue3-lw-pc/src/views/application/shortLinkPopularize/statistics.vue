<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :showMore="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
  </div>
</template>
<script>
import { dateFormat } from '@/utils/index'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import { getTotal, getLineData } from './api'
export default {
  name: 'short-link-statistics',
  components: {
    SearchTitle,
    ChartLine,
  },
  data() {
    return {
      legend: ['访问总数（pv）', '访问总人数（uv）', '小程序打开数'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: '访问总数（pv）',
          tips: '在当前任务中短链页面访问的总次数',
          value: 0,
        },
        {
          title: '访问总人数（uv）',
          tips: '在当前任务中短链页面访问的独立IP数',
          value: 0,
        },
        {
          title: '小程序打开数',
          tips: '在当前任务中小程序成功打开的总次数',
          value: 0,
        },
        {
          title: '今日访问总数（pv）',
          tips: '今日在当前任务中短链页面访问的总次数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日访问总人数（uv）',
          tips: '今日在当前任务中短链页面访问的独立IP数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '今日小程序打开数',
          tips: '今日在当前任务中小程序成功打开的总次数',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
      ],
      value: [],
      id: '',
    }
  },
  methods: {
    getTabTotalFn() {
      getTotal(this.id).then((res) => {
        this.cardData[0].value = res.data.pv
        this.cardData[1].value = res.data.uv
        this.cardData[2].value = res.data.open
        this.cardData[3].value = res.data.todayPv
        this.cardData[3].value1 = res.data.comparedYesterdayPv
        this.cardData[4].value = res.data.todayUv
        this.cardData[4].value1 = res.data.comparedYesterdayUv
        this.cardData[5].value = res.data.todayOpen
        this.cardData[5].value1 = res.data.comparedYesterdayOpen
      })
    },
    getLineData(data) {
      // this.$forceUpdate()
      data.promotionId = this.id
      getLineData(data).then(({ data }) => {
        this.xdata = data.xAxis
        this.series = [data.yAxis.pv, data.yAxis.uv, data.yAxis.open]
        // this.$forceUpdate()
      })
    },
  },
  created() {
    this.id = this.$route.query.id
    this.getTabTotalFn()
  },
}
</script>
<style lang="scss" scoped></style>
