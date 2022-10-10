<script>
  import * as api from '@/api/task'
  import * as echarts from 'echarts'
  import { echartColors, dateFormat } from '@/utils'
  export default {
    name: 'taskDetail',
    data () {
      return {
        query: {
          pageNum: 1,
          pageSize: 10,
          name: '', // "客户名称",
          beginTime: '', // "开始时间",
          endTime: '', // "结束时间"
        },
        dateRange: [],
        tableData: [],
        dateSelect: '近7日',
        dateRange: [],
        taskDetail: {},
        statData: [],
      }
    },
    created () {
      this.getList(this.$route.query.id)
      this.getChartsData({ seven: true })
    },
    mounted () { },
    watch: {
      statData: {
        handler (newVal, oldVal) {
          let xData = [],
            attends = [],
            completes = [],
            increases = []
          for (let i = 0; i < newVal.length; i++) {
            xData.push(newVal[i].day)
            attends.push(newVal[i].attend)
            completes.push(newVal[i].complete)
            increases.push(newVal[i].increase)
          }
          // 指定图表的配置项和数据
          let option = {
            tooltip: {
              //设置tip提示
              trigger: 'axis',
            },

            legend: {
              //设置区分（哪条线属于什么）
              data: ['日新增客户数', '活动参与客户数', '完成任务的客户数'],
            },
            color: echartColors, //设置区分（每条线是什么颜色，和 legend 一一对应）
            xAxis: {
              //设置x轴
              type: 'category',
              boundaryGap: false, //坐标轴两边不留白
              data: xData,
              // name: '日期',           //X轴 name
              nameTextStyle: {
                //坐标轴名称的文字样式
                fontSize: 16,
                // padding: [0, 0, 0, 20]
              },
              // axisLine: {             //坐标轴轴线相关设置。
              //     lineStyle: {
              //         color: '#FA6F53',
              //     }
              // }
            },
            yAxis: {
              nameTextStyle: {
                color: '#FA6F53',
                fontSize: 16,
                padding: [0, 0, 10, 0],
              },
              // axisLine: {
              //     lineStyle: {
              //         color: '#FA6F53',
              //     }
              // },
              type: 'value',
            },
            series: [
              {
                name: '日新增客户数',
                data: increases,
                type: 'line', // 类型为折线图
                // lineStyle: {
                //   // 线条样式 => 必须使用normal属性
                //   normal: {
                //     color: '#8AE09F',
                //   },
                // },
              },
              {
                name: '活动参与客户数',
                data: attends,
                type: 'line',
                // lineStyle: {
                //   normal: {
                //     color: '#FA6F53',
                //   },
                // },
              },
              {
                name: '完成任务的客户数',
                data: completes,
                type: 'line',
                // lineStyle: {
                //   normal: {
                //     color: '#FA6F53',
                //   },
                // },
              },
            ],
          }
          this.initChart(option)
        },
      },
    },
    methods: {
      getList (id) {
        api.getTaskDetail(id).then((res) => {
          this.taskDetail = res.data
        })
      },
      getChartsData (params) {
        params = Object.assign({}, params, { taskFissionId: this.$route.query.id })
        api.getStat(params).then((res) => {
          this.statData = res.data ? res.data.data : []
        })
      },
      resetForm () { },
      exportCustomer () { },
      dateChange (event) {
        let obj = {}
        if (event === '近7日') {
          obj = { seven: true }
        } else {
          obj = { seven: false, thirty: true }
        }
        this.getChartsData(obj)
        this.dateRange = []
      },
      setChange (data) {
        if (data) {
          this.dateSelect = ''
          let beginTime = ''
          let endTime = ''
          if (data[0]) {
            beginTime = dateFormat(data[0], 'yyyy-MM-dd')
          }
          if (data[1]) {
            endTime = dateFormat(data[1], 'yyyy-MM-dd')
          }
          this.getChartsData({ beginTime, endTime, seven: false, thirty: false })
        } else {
          this.dateSelect = '近7日'
          this.getChartsData({ seven: true })
        }
      },
      initChart (option) {
        if (!this.chartLine) {
          this.chartLine = echarts.init(document.getElementById('chartLineBox'))
        }
        this.chartLine.setOption(option)
      },
    },
  }
</script>

<template>
  <div class="task-detail-container">
    <div class="task-detail-model task-detail-left">
      <el-descriptions title="任务活动信息" :column="1" size="medium" border>
        <el-descriptions-item label="创建人">{{ taskDetail.createBy }}</el-descriptions-item>
        <el-descriptions-item label="活动名称">{{ taskDetail.taskName }}</el-descriptions-item>
        <el-descriptions-item label="裂变引导语">{{ taskDetail.fissInfo }}</el-descriptions-item>
        <el-descriptions-item label="裂变客户数量">{{ taskDetail.fissNum }}</el-descriptions-item>
        <el-descriptions-item label="活动时间">{{ taskDetail.startTime }} 至 {{ taskDetail.overTime }}</el-descriptions-item>
        <el-descriptions-item label="活动发起成员">
          <el-tag v-if="taskDetail.fissionType == 0">全部成员</el-tag>
          <TagEllipsis v-else :list="taskDetail.taskFissionStaffs" limit="5" defaultProps="staffName"></TagEllipsis>
        </el-descriptions-item>
        <el-descriptions-item label="客户标签">
          <TagEllipsis :list="taskDetail.customerTag.split(',')" limit="5"></TagEllipsis>
        </el-descriptions-item>
        <el-descriptions-item label="裂变海报"><img style="width: 120px" :src="taskDetail.postersUrl" /></el-descriptions-item>
        <el-descriptions-item label="员工">{{ taskDetail.fissionTarget }}</el-descriptions-item>
        <el-descriptions-item label="兑奖链接">{{ taskDetail.rewardUrl }}</el-descriptions-item>
        <el-descriptions-item label="兑奖图片"><img style="width: 120px" :src="taskDetail.rewardImageUrl" /></el-descriptions-item>
        <el-descriptions-item label="新客欢迎语">{{ taskDetail.welcomeMsg }}</el-descriptions-item>
      </el-descriptions>
    </div>

    <div class="task-detail-model task-detail-right">
      <h4 class="title">关键数据</h4>
      <div class="dateRang">
        <el-radio-group @change="dateChange" v-model="dateSelect" style="margin-bottom: 10px">
          <el-radio-button label="近7日"></el-radio-button>
          <el-radio-button label="近30日"></el-radio-button>
        </el-radio-group>
        <el-date-picker v-model="dateRange" type="daterange" @change="setChange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" align="right"></el-date-picker>
      </div>
      <div id="chartLineBox" style="width: 100%; height: 354px"></div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .task-detail-container {
    display: flex;
    justify-content: space-between;
    background: #efeff4;
    height: calc(100vh - 84px);
    box-sizing: border-box;
    padding: 20px 10px;
    .task-detail-model {
      width: 48%;
      height: 100%;
      box-sizing: border-box;
      background: #fff;
      padding: 10px 20px;
      overflow: auto;
      ::v-deep .el-descriptions-item__label.is-bordered-label {
        width: 120px;
      }
      .title {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 20px;
      }
      .dateRang {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
      }
      #chartLineBox {
        margin-top: 10px;
      }
    }
  }
</style>
