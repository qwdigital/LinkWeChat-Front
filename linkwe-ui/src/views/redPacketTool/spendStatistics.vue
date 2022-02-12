<template>
  <div>
    <div class="divider-content"></div>
    <div class="g-card g-pad20" style="margin-top: 0">
      <CardGroupIndex :data="cardData"></CardGroupIndex>
    </div>
    <!-- <div class="divider-content"></div> -->
    <div class="g-card g-pad20">
      <div class="table-header">支出统计</div>
      <div class="chart-header">
        <el-button-group>
          <el-button size="small" type="primary" :plain="timeRange != 7" @click="setTime(7)"
            >近7日</el-button
          >
          <el-button size="small" type="primary" :plain="timeRange != 30" @click="setTime(30)"
            >近30日
          </el-button>
        </el-button-group>

        <el-date-picker
          v-model="dateRange"
          size="small"
          class="ml20"
          style="width: 260px"
          value-format="yyyy-MM-dd"
          type="daterange"
          :clearable="false"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          @change="getList"
        ></el-date-picker>
      </div>
      <div>
        <div id="chart" class="chart" ref="chart" style="width: 90%; height: 400px"></div>
      </div>
    </div>
    <div class="divider-content"></div>
    <div class="g-card g-pad20">
      <div class="table-header">支出记录</div>
      <el-table
        v-loading="loading"
        :data="list"
        @selection-change="handleSelectionChange"
        max-height="600"
      >
        <el-table-column label="员工名称" align="center" prop="mobile" show-overflow-tooltip />
        <el-table-column label="发送类型" align="center" prop="useUserName" show-overflow-tooltip />
        <el-table-column label="发送时间" align="center" prop="createBy"></el-table-column>
        <el-table-column label="发送金额(元)" align="center" prop="createTime" width="180">
        </el-table-column>
      </el-table>
      <pagination
        :total="total"
        :page.sync="query.pageNum"
        :limit.sync="query.pageSize"
        @pagination="getList()"
      />
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { parseTime } from '@/utils/common'
import CardGroupIndex from '@/components/CardGroupIndex'
import TabContent from './components/TabContent'
import { getAnalysis, countLineChart, exportGroup } from '@/api/redPacketTool/sendRecord'

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
      xAxis: xAxis.slice(0, 8)
    },
    30: {
      data: [payNums, amount],
      xAxis
    }
  }
}

export default {
  name: 'total-data',
  components: { CardGroupIndex, TabContent },
  data() {
    return {
      timeRange: 7,
      dateRange: [],
      loading: false,
      list: [],
      total: 0,
      query: {
        pageNum: 1,
        pageSize: 0
      },
      cardData: [],
      mockData: null
    }
  },
  mounted() {
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>统计分析企业支出金额及笔数情况</div>
      `
    )
    this.mockData = generateMockData()
    this.setTime(7)
  },
  methods: {
    getList() {
      this.loading = true
      getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '累计支出金额（元）',
              value: data.totalMoney,
              noArrow: true
            },
            {
              title: '累计支出笔数',
              value: data.totalNum,
              noArrow: true
            },
            {
              title: '今日支出金额（元）',
              value: data.currentMoney,
              noArrow: true
            },
            {
              title: '今日支出笔数',
              value: data.currentNum,
              noArrow: true
            }
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
      this.loading = true
      getChartList()
        .then(({ data }) => {})
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
      this.setEchart()
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
    setEchart() {
      setTimeout(() => {
        this.drawLine(
          'chart',
          ['累计支出金额(元)', '今日支出笔数'],
          this.mockData[this.timeRange],
          ['#5AD2D2', '#637BC0']
        )
      }, 1000)
    },
    drawLine(id, arrData, data, color) {
      const obj = document.getElementById(id)
      let width = obj.parentNode.offsetWidth || window.innerWidth - 100
      obj.style.width = width + 'px'
      obj.style.height = '400px'
      const charts = echarts.init(obj)

      const chartOption = {
        color: color,
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: arrData
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: data.xAxis,
          axisLine: {
            lineStyle: {
              color: '#ccc'
            }
          }
        },
        yAxis: {
          type: 'value',
          axisLine: {
            lineStyle: {
              color: '#ccc'
            }
          }
        },
        series: []
      }

      chartOption.series = data.data.map((i, index) => ({
        name: arrData[index],
        type: 'line',
        stack: arrData[index],
        smooth: true,
        data: i,
        itemStyle: {
          normal: {
            lineStyle: {
              color: color[index]
            }
          }
        },
        textStyle: {
          color: '#fff' // 主标题文字的颜色。
        }
      }))

      charts.setOption(chartOption)
      this.$nextTick(() => {
        charts.resize()
      })

      // if (process.client) {
      // window.addEventListener('resize', function() {
      // charts.resize()
      // })
      // }
    }
  }
}
</script>

<style lang="scss" scoped>
// .total-item {
//   // width: 200px;
//   padding: 20px;
//   background: linear-gradient(90deg, #3c89f0 0%, #1364f4 100%);
//   border-radius: 4px;

//   .name {
//     font-size: 14px;
//     font-family: PingFangSC-Regular, PingFang SC;
//     font-weight: 400;
//     color: #ffffff;
//   }

//   .value {
//     margin-top: 5px;
//     font-size: 18px;
//     font-family: JDZhengHT-EN-Regular, JDZhengHT-EN;
//     font-weight: 400;
//     color: #ffffff;
//   }
// }

.table-header {
  font-size: 16px;
  font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #333333;
  margin-bottom: 20px;
}
.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
