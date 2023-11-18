<script>
import * as echarts from 'echarts'
import { echartColors } from '@/utils/index'
import merge from 'lodash.merge'

export default {
  // 折线图
  name: 'ChartLine',
  components: {},
  props: {
    // 折线背景渐变色
    bgLinearGradient: {
      type: Boolean,
      default: false,
    },
    // X轴坐标数据
    xData: {
      type: Array,
      default: () => ['2021-12-01', '2021-12-02', '2021-12-03', '2021-12-03', '2021-12-04', '2021-12-05', '2021-12-06'],
    },
    // 图例; 单个图例可传字符串，实际转换成单元素数组[string]
    legend: {
      type: [Array, String],
      default: () => ['新增客户'],
    },
    // 展示数据集
    // 注：二位数组， 其一维数组顺序需要和图例顺序一致，其二维数组顺序需要和X轴数组顺序一致
    // 单条数据集：[120, 132, 101, 134, 90, 230, 210]，其实会被转换成[[120, 132, 101, 134, 90, 230, 210]]
    // 多条数据集：
    // [
    //     [120, 132, 101, 134, 90, 230, 210],
    //     [220, 182, 191, 234, 290, 330, 310],
    //     [150, 232, 201, 154, 190, 330, 410],
    //     [320, 332, 301, 334, 390, 330, 320]
    //   ]
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
      if (!(this.xData?.length && this.series?.length)) {
        return
      }
      // eslint-disable-next-line
      this.myChart = echarts.init(this.$refs.chart)
      let option
      let series = []
      let legend = Array.isArray(this.legend) ? this.legend : [this.legend]
      let seriesData = this.series
      Array.isArray(this.series[0]) || (seriesData = [seriesData])

      seriesData.forEach((data, index) => {
        let obj = {
          name: legend[index],
          type: 'line',
          smooth: true,
          symbol: 'circle', // 数值点类型
          symbolSize: 6, // 数值点大小
          emphasis: {
            focus: 'series',
          },
          data,
        }
        this.bgLinearGradient &&
          Object.assign(obj, {
            areaStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  {
                    offset: 0,
                    color: echartColors[index], // 0% 处的颜色
                  },
                  {
                    offset: 0.8,
                    color: 'white', // 100% 处的颜色
                  },
                ],
                global: false, // 缺省为 false
              },
            },
          })
        series.push(obj)
      })

      option = {
        color: echartColors,
        // title: {
        //   text: 'Stacked Area Chart'
        // },
        tooltip: {
          trigger: 'axis',
          // textStyle: {
          //   color: '#FFF', // 设置文字颜色
          //   fontSize: 12,
          // },
          // backgroundColor: '#505050',
          // borderWidth: 0,
          // axisPointer: {
          //   type: 'cross',
          //   label: {
          //     backgroundColor: '#6a7985',
          //   },
          // },
        },
        legend: {
          data: legend,
          // lineStyle: {
          //   width: 0
          // },
          // itemStyle: {
          //   borderWidth: 10,
          //   decal: {
          //     symbol: 'rect'
          //   }
          // }
          x: 'center',
          y: 'bottom',
          // selectedMode: false,
          type: 'scroll', // 分页类型
          icon: 'roundRect',
          itemWidth: 24,
          itemHeight: 4,
          itemGap: 14,
          tooltip: {
            show: true,
          },
          textStyle: {
            color: '#36363A',
            fontSize: 12,
            lineHeight: 14,
          },
        },
        grid: {
          left: '3%',
          right: '3%',
          bottom: '40px',
          top: '30px',
          containLabel: true,
        },
        xAxis: [
          {
            type: 'category',
            data: this.xData,
            // boundaryGap: false,
            offset: 5,
            axisLine: {
              lineStyle: {
                color: '#ccc',
              },
            },
            axisLabel: {
              // 坐标轴刻度标签的相关设置。
              // interval: 0,
              color: 'rgba(153, 153, 153, 1)', // 坐标字体颜色
            },
            axisTick: {
              // 横坐标刻度
              alignWithLabel: true,
              show: true,
            },
          },
        ],
        yAxis: [
          {
            type: 'value',
            axisLine: {
              lineStyle: {
                color: '#ccc',
              },
              show: false,
            },
            axisLabel: {
              // 坐标轴刻度标签的相关设置。
              // interval: 0,
              color: 'rgba(153, 153, 153, 1)', // 坐标字体颜色
            },
          },
        ],
        series,
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
  <div v-if="xData?.length && series?.length" ref="chart" class="chart-line chart" key="1"></div>
  <div v-else class="chart-line chart" key="2">
    <div class="cc"><Empty /></div>
  </div>
</template>

<style lang="scss" scoped>
.chart {
  position: relative;
  max-height: 100%;
  min-width: 400px;
  min-height: 400px;
}
</style>
