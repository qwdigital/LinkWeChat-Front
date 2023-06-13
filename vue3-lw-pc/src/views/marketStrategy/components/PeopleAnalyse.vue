<template>
  <div>
    <div class="header_content">
      <div class="unit">
        <div class="title">
          今日净增人数
          <el-popover placement="top" trigger="hover">
            <div slot="reference" style="margin-left: 8px; cursor: pointer">
              <img src="../../../assets/marketstrategy/help.svg" alt="" />
            </div>
            <div>本策略人群当天净增的总人数</div>
          </el-popover>
        </div>
        <div class="value">
          {{ data.netAddNum }}
        </div>
      </div>
      <div class="unit">
        <div class="title">
          今日新增人数
          <el-popover placement="top" trigger="hover">
            <div slot="reference" style="margin-left: 8px; cursor: pointer">
              <img src="../../../assets/marketstrategy/help.svg" alt="" />
            </div>
            <div>本策略人群当天增加的总人数</div>
          </el-popover>
        </div>
        <div class="value">
          {{ data.addNum }}
        </div>
      </div>
      <div class="unit">
        <div class="title">
          今日减少人数
          <el-popover placement="top" trigger="hover">
            <div slot="reference" style="margin-left: 8px; cursor: pointer">
              <img src="../../../assets/marketstrategy/help.svg" alt="" />
            </div>
            <div>本策略人群当天减少的总人数</div>
          </el-popover>
        </div>
        <div class="value">
          {{ data.reduceNum }}
        </div>
      </div>
    </div>
    <div class="bar_content pad20">
      <search-title @search="getTime"></search-title>
      <chart-bar :xData="xData" :legend="legend" :series="series"></chart-bar>
    </div>
  </div>
</template>
<script>
import SearchTitle from '@/views/customerService/components/SearchTitle'
import { crowdAnalyse } from '@/api/marketStrategy/people'

export default {
  name: 'people-analyse',
  data() {
    return {
      xData: [],
      series: [],
      legend: ['人群总人数'],
      query: {
        beginTime: '',
        endTime: '',
        id: '',
      },
      data: {
        addNum: 0,
        netAddNum: 0,
        reduceNum: 0,
      },
    }
  },
  components: {
    ChartBar: () => import('@/components/ChartBar'),
    SearchTitle,
  },
  methods: {
    getTime(data) {
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      if (this.query.id) {
        this.getData()
      }
    },
    getData() {
      crowdAnalyse(this.query).then((res) => {
        if (res.code === 200) {
          this.data.netAddNum = res.data.netAddNum
          this.data.addNum = res.data.addNum
          this.data.reduceNum = res.data.reduceNum
          this.xData = res.data.crowdAnalyzels.map((dd) => {
            return dd.dateTime
          })
          this.series = res.data.crowdAnalyzels.map((dd) => {
            return dd.total
          })
        }
      })
    },
  },
  created() {
    this.query.id = this.$route.query.id
  },
}
</script>
<style lang="scss" scoped>
.header_content {
  display: flex;
  .unit {
    background: #ffffff;
    // box-shadow: 0px 6px 30px 5px rgba(59, 59, 59, 0.05);
    border-radius: 8px;
    margin-right: 16px;
    width: 210px;
    height: 100px;
    padding: 18px 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    .title {
      font-size: 14px;
      font-weight: 500;
      color: rgba(0, 0, 0, 0.6);
      display: flex;
      justify-content: space-between;
    }
    .value {
      font-size: 28px;
      font-weight: bold;
      color: #0079de;
    }
  }
}
.bar_content {
  margin-top: 16px;
  background: #ffffff;
  border-radius: 8px;
}
</style>
