<script>
import * as echarts from 'echarts'
import chinaJson from './jsonData/china.json'
export default {
  render: function () {
    return h('div', {
      ref: 'chart',
      style: {
        'min-height': '500px',
        'min-width': '200px',
        margin: 'auto',
      },
    })
  },
  watch: {
    Datas: {
      deep: true,
      handler() {
        this.initEchart()
      },
    },
  },
  props: ['Datas'],
  data() {
    return {
      dataList: [
        { name: '南海诸岛' },
        { ename: 'beijing', name: '北京' },
        { ename: 'tianjin', name: '天津' },
        { ename: 'shanghai', name: '上海' },
        { ename: 'chongqing', name: '重庆' },
        { ename: 'hebei', name: '河北' },
        { ename: 'henan', name: '河南' },
        { ename: 'yunnan', name: '云南' },
        { ename: 'liaoning', name: '辽宁' },
        { ename: 'heilongjiang', name: '黑龙江' },
        { ename: 'hunan', name: '湖南' },
        { ename: 'anhui', name: '安徽' },
        { ename: 'shandong', name: '山东' },
        { ename: 'xinjiang', name: '新疆' },
        { ename: 'jiangsu', name: '江苏' },
        { ename: 'zhejiang', name: '浙江' },
        { ename: 'jiangxi', name: '江西' },
        { ename: 'hubei', name: '湖北' },
        { ename: 'guangxi', name: '广西' },
        { ename: 'gansu', name: '甘肃' },
        { ename: 'shanxi', name: '山西' },
        { ename: 'neimenggu', name: '内蒙古' },
        { ename: 'shanxi1', name: '陕西' },
        { ename: 'jilin', name: '吉林' },
        { ename: 'fujian', name: '福建' },
        { ename: 'guizhou', name: '贵州' },
        { ename: 'guangdong', name: '广东' },
        { ename: 'qinghai', name: '青海' },
        { ename: 'xizang', name: '西藏' },
        { ename: 'sichuan', name: '四川' },
        { ename: 'ningxia', name: '宁夏' },
        { ename: 'hainan', name: '海南' },
        { name: '台湾' },
        { ename: 'xianggang', name: '香港' },
        { ename: 'aomen', name: '澳门' },
      ],
    }
  },
  methods: {
    initEchart() {
      let that = this
      // console.log('this.Datas', this.Datas.data)
      // console.log('this.dataList', this.dataList)
      let dataList = this.dataList
      let max = 0
      for (let i = 0; i < dataList.length; i++) {
        for (let q = 0; q < this.Datas.data.length; q++) {
          if (this.Datas.data[q].name.substring(0, 2) == dataList[i].name.substring(0, 2)) {
            dataList[i].value = this.Datas.data[q].value
            // console.log(' dataList[i].value', dataList[i].value)
            if (dataList[i].value > max) {
              max = dataList[i].value
            }
            break
          }
        }
      }
      max = max + 5
      const _this = this
      var myChart = echarts.init(this.$refs.chart)
      echarts.registerMap('china', chinaJson)
      var option = {
        tooltip: {
          //数据格式化
          formatter: function (params, callback) {
            return params.seriesName + '<br />' + params.name + '：' + params.value
          },
        },
        visualMap: {
          min: 0,
          max: max,
          left: 'left',
          top: 'bottom',
          inRange: {
            color: ['#e0ffff', 'blue'], //取值范围的颜色
          },
          show: true, //图注
        },
        geo: {
          map: 'china', //引入地图数据
          roam: false, //不开启缩放和平移
          zoom: 1, //视角缩放比例
          label: {
            normal: {
              show: true,
              fontSize: '10',
              color: 'rgba(0,0,0,0.7)',
            },
          },
          itemStyle: {
            normal: {
              borderColor: 'rgba(0, 0, 0, 0.2)',
            },
            emphasis: {
              //高亮的显示设置
              areaColor: 'skyblue', //鼠标选择区域颜色
              shadowOffsetX: 0,
              shadowOffsetY: 0,
              shadowBlur: 20,
              borderWidth: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)',
            },
          },
        },
        // 鼠标悬浮提示框
        series: [
          {
            name: '省份',
            type: 'map',
            geoIndex: 0,
            data: this.dataList,
          },
        ],
      }
      myChart.setOption(option)

      new ResizeObserver((entries) => {
        myChart.resize()
      }).observe(this.$refs.chart)

      myChart.on('click', function (params) {
        if (!params.data.ename) {
          alert('暂无' + params.name + '地图数据')
          return
        }
        that.$emit('Fparams', params)
        // _this.$router.push({
        //   path: "/province",
        //   query: { provinceName: params.data.ename, province: params.name },
        // });
      })
    },
  },
  mounted() {
    this.initEchart()
  },
}
</script>
