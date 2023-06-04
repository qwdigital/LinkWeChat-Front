<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">支出趋势</div>
      <div>
        <el-button-group>
          <el-button type="primary" :plain="timeRange != 7" @click="setTime(7)">近7日</el-button>
          <el-button type="primary" :plain="timeRange != 30" @click="setTime(30)">近30日</el-button>
        </el-button-group>

        <el-date-picker
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
      <div v-loading="loadingChart">
        <div id="chart" ref="chart" style="width: 90%; height: 400px"></div>
      </div>
    </div>
    <div class="g-card">
      <div class="g-card-title">支出记录</div>
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange" max-height="600">
        <el-table-column label="员工名称" align="center" prop="userName" show-overflow-tooltip />
        <el-table-column label="发送类型" align="center" prop="receiveType">
          <template #default="{ row }">
            {{ { 1: '好友客户', 2: '群成员' }[row.receiveType] }}
          </template>
        </el-table-column>
        <el-table-column label="发送时间" align="center" prop="createTime"></el-table-column>
        <el-table-column label="发送金额(元)" align="center" prop="totalMoney" width="180"></el-table-column>
      </el-table>
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getRecordList()" />
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { parseTime } from '@/utils/common'

// import TabContent from './components/TabContent'
import { getAnalysis, getChartList, getRecordList } from '@/api/redPacketTool/spendStatistics'

function generateMockData() {
  // 7天和30天的假数据
  let now = new Date().valueOf()

  const oneDay = 1000 * 60 * 60 * 24
  let xAxis = []
  let payNums = []
  let amount = []
  new Array(30).fill(1).forEach((i, idx) => {
    payNums.push(parseInt(Math.random() * 100 + 60))
    amount.push(parseInt(Math.random() * 120 + 10))
    xAxis.push(parseTime(now - idx * oneDay, '{y}-{m}-{d}'))
  })

  return {
    7: {
      data: [payNums.slice(0, 8), amount.slice(0, 8)],
      xAxis: xAxis.slice(0, 8),
    },
    30: {
      data: [payNums, amount],
      xAxis,
    },
  }
}

export default {
  name: 'total-data',
  components: {},
  data() {
    return {
      timeRange: 7,
      dateRange: [],
      loading: false,
      loadingChart: false,
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      list: [],
      total: 0,
      cardData: [],
      // mockData: null
    }
  },
  mounted() {
    this.$store.setBusininessDesc(
      `
        <div>统计分析企业支出金额及笔数情况</div>
      `,
    )

    // this.mockData = generateMockData()
    this.getList()
    this.setTime(7)
    this.getRecordList()
  },
  methods: {
    getList() {
      this.loading = true
      getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '累计支出金额（元）',
              value: data.totalMoney / 100,
              noArrow: true,
            },
            {
              title: '累计支出笔数',
              value: data.totalNum,
              noArrow: true,
            },
            {
              title: '今日支出金额（元）',
              value: data.currentMoney / 100,
              noArrow: true,
            },
            {
              title: '今日支出笔数',
              value: data.currentNum,
              noArrow: true,
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
    getChartList() {
      this.loadingChart = true
      if (this.dateRange) {
        this.query.beginTime = this.dateRange[0]
        this.query.endTime = this.dateRange[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
      getChartList(this.query)
        .then(({ data }) => {
          let seriesData = [] // this.mockData[this.timeRange]
          seriesData[0] = data.map((e) => e.totalMoney / 100)
          seriesData[1] = data.map((e) => e.totalNum)
          let xAxisData = data.map((e) => e.createTime.slice(0, 10))
          this.setEchart(xAxisData, seriesData)
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loadingChart = false
        })
    },
    getRecordList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getRecordList(this.query)
        .then(({ rows, total }) => {
          rows.forEach((element) => {
            element.totalMoney /= 100
          })
          this.list = rows
          this.total = +total
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    handleSelectionChange() {},
    setTime(days) {
      this.timeRange = days
      let date = new Date()
      date.setDate(date.getDate() - days)
      this.dateRange = [this.getTime(date), this.getTime()]
      this.getChartList()
    },
    getTime(datePar) {
      const d = datePar ? new Date(datePar) : new Date()
      const year = d.getFullYear()
      const month = this.getHandledValue(d.getMonth() + 1)
      const date = this.getHandledValue(d.getDate())
      return year + '-' + month + '-' + date
    },
    getHandledValue(num) {
      return num < 10 ? '0' + num : num
    },
    setEchart(xAxisData, seriesData) {
      setTimeout(() => {
        this.drawLine('chart', ['支出金额', '支出笔数'], xAxisData, seriesData, ['#5AD2D2', '#637BC0'])
      }, 0)
    },
    drawLine(id, legend, xAxisData, seriesData, color) {
      const dom = document.getElementById(id)
      let width = dom.parentNode.offsetWidth || window.innerWidth - 100
      dom.style.width = width + 'px'
      dom.style.height = '400px'
      const charts = echarts.init(dom)

      let series = []
      let yAxis = []
      seriesData.forEach((iData, index) => {
        let max = iData.slice().sort((a, b) => b - a)[0]
        // 最大值上取整最近的10的正数倍
        max = Math.ceil(max / 10) * 10
        yAxis.push({
          name: legend[index],
          type: 'value',
          min: 0,
          max,
          interval: max / 5,
          axisLine: {
            // show: false,
            lineStyle: {
              color: '#ccc',
            },
          },
        })
        series.push({
          name: legend[index],
          type: index === 0 ? 'line' : 'bar',
          yAxisIndex: index,
          smooth: true,
          data: iData,
          itemStyle: {
            normal: {
              lineStyle: {
                color: color[index],
              },
            },
          },
          textStyle: {
            color: '#fff', // 主标题文字的颜色。
          },
        })
      })

      let chartOption = {
        color: color,
        tooltip: {
          trigger: 'axis',
        },
        legend: {
          data: legend,
          bottom: '0%',
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '40px',
          containLabel: true,
        },
        xAxis: {
          type: 'category',
          // boundaryGap: false,
          data: xAxisData,
          axisLine: {
            lineStyle: {
              color: '#ccc',
            },
          },
        },
        yAxis,
        series,
      }

      charts.setOption(chartOption)
      new ResizeObserver((entries) => {
        charts.resize()
      }).observe(dom)
    },
  },
}
</script>

<style lang="scss" scoped></style>
