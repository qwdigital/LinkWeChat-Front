<script>
import * as echarts from 'echarts'
import { echartColors } from '@/utils/index'
import merge from 'lodash.merge'

export default {
  // 折线图
  name: 'ChartLine',
  components: {},
  props: {
    Data: {
      type: Object,
      default: null,
    },
    series: {
      type: Array,
      default: () => [120, 132, 101, 134, 90, 230, 210],
    },
    // 自定义图表配置项，使用loadsh.merge(origin, option)和原有的配置进行覆盖合并
    // loadsh.merge: https://www.html.cn/doc/lodash/#_mergeobject-sources
    option: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {}
  },
  computed: {},
  watch: {
    series: {
      deep: true,
      handler() {
        this.$nextTick(() => {
          this.drawChart()
        })
      },
    },
  },
  created() {},
  mounted() {
    this.drawChart()
  },
  methods: {
    drawChart() {
      console.log('this.Data', this.Data)
      this.myChart = echarts.init(this.$refs.chart)
      let option
      let series = []
      let dateLe = []
      // for(let i=0;this.Data.data.length;i++){

      // }
      option = {
        legend: [
          {
            data: this.Data.optionss,
            x: 'center',
            y: 'bottom',
          },
        ],

        tooltip: {
          trigger: 'item',
        },
        series: [
          {
            type: 'pie',
            radius: '50%',
            data: this.Data.data,
            itemStyle: {
              emphasis: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)',
              },
              normal: {
                label: {
                  show: true,
                  formatter: '{d}%',
                },
                labelLine: { show: true },
              },
            },
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)',
              },
            },
          },
        ],
      }
      this.option && merge(option, this.option)
      option && this.myChart.setOption(option)

      new ResizeObserver((entries) => {
        this.myChart.resize()
      }).observe(this.$refs.chart)
    },
  },
}
</script>

<template>
  <div v-if="series && series.length" ref="chart" class="chart-line chart" key="1"></div>
  <div v-else class="chart-line chart" key="2"><div class="cc">暂无数据</div></div>
</template>

<style lang="scss" scoped>
.chart {
  position: relative;
  max-height: 100%;
  min-width: 400px;
  min-height: 400px;
}
</style>
