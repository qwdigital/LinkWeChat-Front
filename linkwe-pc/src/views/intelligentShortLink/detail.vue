<script>
import { getDetail, getLineAnalysis, getAnalysis } from '@/api/intelligentShortLink'
export default {
  name: '',
  components: {
    TimeSearchTitle: () => import('@/components/common/TimeSearchTitle'),
    PhonePreview: () => import('./components/PhonePreview.vue'),
    CardGroupIndex: () => import('@/components/CardGroupIndex'),
    ChartLine: () => import('@/components/ChartLine'),
    Add: () => import('./components/Add'),
  },
  data() {
    return {
      loading: false,
      data: {},
      xData: [],
      series: [],
    }
  },
  computed: {},
  watch: {},
  created() {
    let id = this.$route.query.id
    this.getList(id)
    this.getAnalysis(id)
  },
  mounted() {},
  methods: {
    getDetail(id) {
      this.loading = true
      getDetail(id)
        .then(({ data }) => {
          this.form = data
        })
        .catch(() => {})
        .finally(() => {
          this.loading = false
        })
    },
    getAnalysis(id) {
      this.loading = true
      getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '访问总数(pv)',
              tips: '短链页面访问的总次数',
              value: data.pvTotalCount,
            },
            {
              title: '访问总人数(uv)',
              tips: '短链页面访问的独立IP数',
              value: data.uvTotalCount,
            },
            {
              title: '小程序打开数',
              tips: '小程序成功打开的总次数',
              value: data.openTotalCount,
            },
            {
              title: '今日访问总数(pv)',
              tips: '今日短链页面访问的总次数',
              value: data.pvTodayCount,
              title1: '较昨日',
              value1: data.pvDiff,
            },
            {
              title: '今日访问总人数(uv)',
              tips: '今日短链页面访问的独立IP数',
              value: data.uvTodayCount,
              title1: '较昨日',
              value1: data.uvDiff,
            },
            {
              title: '今日小程序打开数',
              tips: '今日小程序成功打开的总次数',
              value: data.openTodayCount,
              title1: '较昨日',
              value1: data.openDiff,
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
    getLineAnalysis(data) {
      let query = {
        id: this.$route.query.id,
        beginTime: data.beginTime,
        endTime: data.endTime,
      }
      getLineAnalysis(query).then(({ data }) => {
        this.series = []
        this.xData = data.xaxis
        this.series = data.yaxis
        // this.series.push(data.map((e) => e.pvTodayCount))
        // this.series.push(data.map((e) => e.uvTodayCount))
        // this.series.push(data.map((e) => e.openTodayCount))
      })
    },
  },
}
</script>

<template>
  <div>
    <div class="fxbw">
      <div style="width: 58%">
        <div class="g-title">短链内容</div>
        <div class="g-card g-pad20">
          <Add :form="data" />
        </div>
        <div class="g-title">数据趋势</div>
        <div class="g-card g-pad20">
          <CardGroupIndex :data="cardData"></CardGroupIndex>
          <div>
            <TimeSearchTitle @search="getLineAnalysis"></TimeSearchTitle>
          </div>
          <ChartLine
            :xData="xData"
            :legend="['访问总数(pv)', '访问总人数(uv)', '小程序打开数']"
            :series="series"></ChartLine>
        </div>
      </div>
      <div style="width: 40%">
        <PhonePreview :data="data" />
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
