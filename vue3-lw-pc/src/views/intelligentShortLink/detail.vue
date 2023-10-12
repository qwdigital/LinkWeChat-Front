<script>
import { getDetail, getLineAnalysis, getAnalysis } from '@/api/intelligentShortLink'
export default {
  name: '',
  components: {
    TimeSearchTitle: defineAsyncComponent(() => import('@/components/common/TimeSearchTitle')),
    PhonePreview: defineAsyncComponent(() => import('./components/PhonePreview.vue')),
    ChartLine: defineAsyncComponent(() => import('@/components/ChartLine')),
    Add: defineAsyncComponent(() => import('./components/Add')),
  },
  data() {
    return {
      loading: false,
      data: {},
      cardData: [],
      xData: [],
      series: [],
    }
  },
  computed: {},
  watch: {},
  created() {
    let id = this.$route.query.id
    this.getDetail(id)
    this.getAnalysis(id)
  },
  mounted() {},
  methods: {
    getDetail(id) {
      this.loading = true
      getDetail(id)
        .then(({ data }) => {
          this.data = data
        })
        .catch(() => {})
        .finally(() => {
          this.loading = false
        })
    },
    getAnalysis(id) {
      this.loading = true
      getAnalysis(id)
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
        this.xData = data.xaxis
        // this.series = data.yaxis
        this.series = [data.yaxis.pv, data.yaxis.uv, data.yaxis.open]
        // this.series.push(data.map((e) => e.pvTodayCount))
        // this.series.push(data.map((e) => e.uvTodayCount))
        // this.series.push(data.map((e) => e.openTodayCount))
      })
    },
  },
}
</script>

<template>
  <div class="fxbw ais">
    <div class="pr10" style="flex: auto; overflow: auto">
      <div class="g-card">
        <div class="g-card-title fxbw">
          短链内容
          <el-button type="primary" class="fr" @click="$router.push({ path: './addEdit', query: { id: data.id } })">
            编辑
          </el-button>
        </div>
        <Add v-if="data.type || data.type === 0" :form="data" />
      </div>
      <div class="g-card">
        <div class="g-card-title">数据趋势</div>
        <CardGroupIndex :data="cardData"></CardGroupIndex>
        <TimeSearchTitle @search="getLineAnalysis"></TimeSearchTitle>
        <ChartLine
          :xData="xData"
          :legend="['访问总数(pv)', '访问总人数(uv)', '小程序打开数']"
          :series="series"></ChartLine>
      </div>
    </div>
    <PhonePreview :data="data" />
  </div>
</template>

<style lang="scss" scoped></style>
