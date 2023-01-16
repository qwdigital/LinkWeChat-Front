<script>
import { getDetail, getLineAnalysis, getAnalysis } from '@/api/intelligentShortLink'
export default {
  name: '',
  components: {},
  data() {
    return {
      loading: false,
      form: {},
      dateRange: [new Date().setDate(-7)],
      data: [],
      xData: [],
      series: [],
    }
  },
  computed: {
    ChartLine: () => import('@/components/ChartLine'),
  },
  watch: {},
  created() {
    let id = this.$route.query.id
    this.getList(id)
    this.getAnalysis(id)
    this.getLineAnalysis()
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
    getLineAnalysis() {
      let query = {
        id: this.$route.query.id,
        beginTime: this.dateRange[0],
        endTime: this.dateRange[1],
      }
      getLineAnalysis(query).then(({ data }) => {
        this.xData = data.map((e) => e.xtime)
        this.series.push(data.map((e) => e.addCnt))
        this.series.push(data.map((e) => e.lostCnt))
        this.series.push(data.map((e) => e.netCnt))
      })
    },
  },
}
</script>

<template>
  <div>
    <div class="fxbw">
      <div style="width: 40%">
        <div class="g-card g-pad20">
          <div class="title">短链内容</div>
        </div>
      </div>
      <div class="g-card g-pad20" style="width: 40%; margin-top: 0">
        <PhoneTemplate :title="dictDesc[form.touchType].previewMobileTitle"></PhoneTemplate>
      </div>
    </div>
    <div class="g-card g-pad20">
      <div class="title">数据趋势</div>
      <CardGroupIndex :data="cardData"></CardGroupIndex>
      <div>
        <el-date-picker
          v-model="dateRange"
          :picker-options="pickerOptions"
          class="ml20"
          value-format="yyyy-MM-dd"
          type="daterange"
          :clearable="false"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          @change="getLineAnalysis()"></el-date-picker>
      </div>
      <ChartLine
        :xData="xData"
        :legend="['访问总数(pv)', '访问总人数(uv)', '小程序打开数']"
        :series="series"></ChartLine>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
