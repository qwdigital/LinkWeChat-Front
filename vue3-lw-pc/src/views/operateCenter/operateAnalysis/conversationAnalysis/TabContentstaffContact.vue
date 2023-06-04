<script>
import ChartBar from '@/components/ChartBar'
import { getUserChatRank, getUserAvgReplyTimeRank } from '@/api/operateCenter/conversationAnalysis'
export default {
  name: '',
  components: { ChartBar },
  props: {
    type: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      loading: false,
      timeRange: 7,
      legend: {
        num: ['员工单聊数'],
        time: ['平均首次回复时长'],
      },
      // 日期范围
      dateRange: [],
      // 查询参数
      query: {
        beginTime: undefined,
        endTime: undefined,
      },
      num: {
        xData: [],
        series: [],
      },
      time: {
        xData: [],
        series: [],
      },
    }
  },
  computed: {},
  watch: {},
  created() {
    this.setTime(7)
  },
  mounted() {},
  methods: {
    getList() {
      this.query.beginTime = this.dateRange && this.dateRange[0]
      this.query.endTime = this.dateRange && this.dateRange[1]
      this.loading = true

      getUserChatRank(this.query)
        .then(({ data }) => {
          this.num.series = data.map((e) => e.chatCnt)
          this.num.xData = data.map((e) => e.userName)
        })
        .catch((e) => {
          console.error(e)
        })
      getUserAvgReplyTimeRank(this.query)
        .then(({ data }) => {
          this.time.series = data.map((e) => e.avgReplyTime)
          this.time.xData = data.map((e) => e.userName)
          this.loading = false
        })
        .catch((e) => {
          console.error(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    getTime(datePar) {
      const d = datePar ? new Date(datePar) : new Date()
      d.setMinutes(d.getMinutes() - d.getTimezoneOffset())
      return d.toJSON().substr(0, 10)
    },
    setTime(days) {
      this.timeRange = days
      if (days) {
        let date = new Date()
        date.setDate(date.getDate() - days)
        this.dateRange = [this.getTime(date), this.getTime()]
        this.getList()
      } else {
        this.dateRange = null
      }
    },
  },
}
</script>

<template>
  <div>
    <div class="operation">
      <el-button-group>
        <el-button type="primary" :plain="timeRange != 7" @click="setTime(7)">近一周</el-button>
        <el-button type="primary" :plain="timeRange != 30" @click="setTime(30)">近一月</el-button>
        <el-button type="primary" :plain="!!timeRange" @click="setTime()">自定义</el-button>
      </el-button-group>
      <el-date-picker
        v-if="!timeRange"
        v-model="dateRange"
        class="ml20"
        style="width: 260px"
        value-format="YYYY-MM-DD"
        type="daterange"
        :clearable="false"
        range-separator="-"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        @change="getList"></el-date-picker>
    </div>
    <el-row :gutter="10">
      <el-col :span="12">
        <ChartBar :xData="num.xData" :legend="legend.num" :series="num.series"></ChartBar>
      </el-col>
      <el-col :span="12">
        <ChartBar
          :legend="legend.time"
          :series="time.series"
          :option="{
            xAxis: [{ type: 'value' }],
            yAxis: [{ type: 'category', data: time.xData }],
          }"></ChartBar>
      </el-col>
    </el-row>
  </div>
</template>

<style lang="scss" scoped></style>
