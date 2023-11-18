<script>
import * as echarts from 'echarts'
import { echartColors } from '@/utils/index'
import merge from 'lodash.merge'

export default {
  // 饼图
  name: 'ChartPie',
  components: {},
  props: {
    // 图例
    legend: {
      type: Array,
      default: () => ['新增客户'],
    },
    // 展示数据集
    series: {
      type: Array,
      default: () => [
        { value: 1048, name: 'Search Engine' },
        { value: 735, name: 'Direct' },
        { value: 580, name: 'Email' },
        { value: 484, name: 'Union Ads' },
        { value: 300, name: 'Video Ads' },
      ],
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
        this.drawChart()
      },
    },
  },
  created() {},
  mounted() {
    this.drawChart()
  },
  methods: {
    drawChart() {
      // eslint-disable-next-line
      if (!this.series?.length) {
        return
      }
      this.myChart = echarts.init(this.$refs.chart)
      let option = {
        color: echartColors,
        // title: {
        //   text: 'Stacked Area Chart',
        //   left: 'center',
        //   top: 'bottom'
        // },
        tooltip: {
          trigger: 'item',
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
          x: 'center',
          y: '88%',
          // selectedMode: false,
          type: 'scroll', // 分页类型
          icon: 'circle',
          itemWidth: 8,
          itemHeight: 8,
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
          bottom: '20px',
          top: '30px',
          containLabel: true,
        },
        series: {
          type: 'pie',
          radius: '50%',
          data: this.series,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)',
            },
          },
        },
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
  <div v-if="series?.length" ref="chart" class="chart-pie chart" key="1"></div>
  <div v-else class="chart-pie chart" key="2">
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
