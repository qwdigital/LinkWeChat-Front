<template>
  <div>
    <!-- <div @click="goBack()">返回</div> -->
    <div :id="id" class="provinceCharts"></div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { areaStatistic } from '@/api/drainageCode/smartForms.js'
export default {
  name: 'province',
  props: ['params'],
  data() {
    return {
      baseListMap: '',
      id: 'echarts_' + new Date().getTime() + Math.floor(Math.random() * 1000),
      echartObj: null,
      option: {
        title: {
          text: '',
          top: '8%',
          left: '8%',
          textStyle: {
            fontSize: 14,
            fontWeight: 300,
            color: '#000',
          },
        },
        tooltip: {
          padding: 0,
          // 数据格式化
          formatter: function (params, callback) {
            return params.name + '：' + (params.value || 0)
          },
        },
        legend: {
          orient: 'vertical',
          top: '9%',
          left: '5%',
          icon: 'circle',
          data: [],
          selectedMode: 'single',
          selected: {},
          itemWidth: 12,
          itemHeight: 12,
          itemGap: 30,
          inactiveColor: '#b6d7ff',
          textStyle: {
            color: '#ec808d',
            fontSize: 14,
            fontWeight: 300,
            padding: [0, 0, 0, 15],
          },
        },
        visualMap: {
          min: 0,
          max: 500,
          left: 'left',
          top: 'bottom',
          text: ['高', '低'], // 取值范围的文字
          inRange: {
            color: ['#e0ffff', 'blue'], // 取值范围的颜色
          },
          show: true, // 图注
        },
        geo: {
          map: '',
          roam: false, // 不开启缩放和平移
          zoom: 0.6, // 视角缩放比例
          label: {
            normal: {
              show: true,
              fontSize: 10,
              color: '#000',
            },
            emphasis: {
              show: true,
              color: 'blue',
            },
          },
          itemStyle: {
            normal: {
              borderColor: 'rgba(0, 0, 0, 0.2)',
            },
            emphasis: {
              areaColor: 'skyblue', // 鼠标选择区域颜色
              shadowOffsetX: 0,
              shadowOffsetY: 0,
              shadowBlur: 20,
              borderWidth: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)',
            },
          },
          left: '5%',
          right: '5%',
          top: '5%',
          bottom: '5%',
        },
        series: [
          {
            name: '省份数据',
            type: 'map',
            geoIndex: 0, // 不可缺少，否则无tooltip 指示效果
            data: [],
          },
        ],
        provinceJSON: {},
        provinceName: '',
      },
    }
  },
  mounted() {
    this.init()
    // this.initDate();
    this.resizeListener()
  },
  methods: {
    init() {
      this.areaStatisticF()
    },
    // 地图
    areaStatisticF() {
      let that = this
      let data = {
        formId: this.params.formId,
        areaType: 2,
        parentCode: this.params.parentCode,
      }
      areaStatistic(data).then((res) => {
        console.log('地图统计图返回值', res)
        that.baseListMap = res.data
        that.option.series[0].data = that.baseListMap[0].data
        let max = 0
        for (let i = 0; i < that.baseListMap[0].data.length; i++) {
          if (that.baseListMap[0].data[i].value > max) {
            max = that.baseListMap[0].data[i].value
          }
        }
        max = max + 5
        that.option.visualMap.max = max
        console.log('that.option', that.option)
        that.$forceUpdate()
        that.initDate()
        // that.baseList= res.data;
      })
    },
    async initDate() {
      console.log('this.params', this.params)
      const provinceName = this.params.ename
      const province = this.params.name
      this.provinceName = provinceName
      this.provinceJSON = (await import(`./jsonData/${provinceName}.json`)).default
      this.option.title.text = province
      this.option.geo.map = province
      this.echartObj = echarts.init(document.getElementById(this.id))
      echarts.registerMap(province, this.provinceJSON)
      this.echartObj.setOption(this.option)
      // this.echartObj.on("click", (params) => {
      //   this.$router.push({
      //     path: "/city",
      //     query: { city: params.name },
      //   });
      // });
    },
    resizeListener() {
      window.addEventListener('resize', () => {
        if (this.echartObj && this.echartObj.resize) {
          this.echartObj.resize()
        }
      })
    },
    goBack() {
      this.$router.go(-1)
    },
  },
}
</script>
<style lang="scss">
.provinceCharts {
  height: 400px;
  width: 600px;
  margin: auto;
}
</style>
