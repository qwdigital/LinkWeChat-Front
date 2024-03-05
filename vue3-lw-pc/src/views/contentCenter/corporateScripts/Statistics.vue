<template>
  <div>
    <!-- 话术统计 -->
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <CardGroupIndex :data="cardData"></CardGroupIndex>
      <div class="data-content">
        <div class="chart-content">
          <search-title @search="getLineData"></search-title>
          <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
        </div>
      </div>
    </div>
    <div class="g-card">
      <div class="g-card-title">
        数据明细
        <!-- <el-popover
              trigger="hover"
              content="仅统计话术中轨迹素材被查看情况统计，排行权重：查看总人数 > 查看总次数 > 发送总次数"
              placement="top-start"
            >
              <el-icon-QuestionFilled  slot="reference" class="el-icon-QuestionFilled"/>
            </el-popover> -->
      </div>
      <div>
        <div>
          <search-title :showToday="true" @search="getTableData" style="margin-top: 20px"></search-title>
        </div>
        <div class="data-content" style="margin-top: 20px">
          <DataDetail :tableList="tableList" :timeObj="query" :resourceType="2" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getCount } from '@/api/contentCenter/common.js'
import { getTalkMaterial } from '@/api/contentCenter/scriptCenter.js'
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import DataDetail from '@/views/contentCenter/components/DataDetail.vue'
export default {
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
    DataDetail,
  },
  data() {
    return {
      detailForm: {}, //详情请求参数
      submitLoading: false,
      disabled: true,
      mobForm: {
        welcomeMsg: '',
        materialMsgList: [],
        userIds: '',
        userNames: '',
      },
      exportLoading: false,
      // barLegend1: ['访问客户总数'],
      // barLegend2: ['咨询客户总数'],
      form: {}, // 素材表单
      legend: ['发送次数', '查看次数', '查看人数'],
      xdata: [],
      series: [],
      activeName: 'first',
      cardData: [
        {
          title: '发送总次数 ',
          value: 0,
          noArrow: true,
        },
        {
          title: '查看总次数',
          value: 0,
        },
        {
          title: '查看总人数',
          value: 0,
        },
        {
          title: '今日发送次数',
          value: 0,
        },
        {
          title: '今日查看次数',
          value: 0,
        },
        {
          title: '今日查看人数',
          value: 0,
        },
      ],
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      tableList: [],
      loading: false,
      searchData: {},
      bar1: [],
      bar2: [],
      value1: [],
      value2: [],
      tableSearch: {},
      treeData: [{}], // 树
      talkId: '',
    }
  },
  methods: {
    contentChange(e) {
      this.mobForm.welcomeMsg = e
    },
    getTableData(data) {
      this.query.talkId = this.talkId
      this.query.beginTime = data.beginTime
      this.query.endTime = data.endTime
      this.getTableChangeSize()
    },
    getLineData(data) {
      // this.searchData = data
      data.talkId = this.talkId
      data.moduleType = 2
      data.talkType = 0
      data.resourceType = 2
      this.legend = ['发送次数', '查看次数', '查看人数']
      // this.$forceUpdate()
      getCount(data).then((res) => {
        this.cardData[0].value = res.data.sendTotalNum
        this.cardData[1].value = res.data.viewTotalNum
        this.cardData[2].value = res.data.viewByTotalNum
        this.cardData[3].value = res.data.sendTodayNum
        this.cardData[4].value = res.data.viewTotalTodayNum
        this.cardData[5].value = res.data.viewByTotalTodayNum
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        let arr3 = []
        if (res.data && res.data.contentAxisVoList.length) {
          res.data.contentAxisVoList.forEach((dd) => {
            this.xdata.push(dd.dateStr)
            arr1.push(dd.sendNum)
            arr2.push(dd.viewNum)
            arr3.push(dd.viewByNum)
          })
          this.series = [arr1, arr2, arr3]
        }
      })
    },
    getTableChangeSize() {
      this.loading = true
      this.query.talkType = 0
      this.query.resourceType = 2
      getTalkMaterial(this.query).then((res) => {
        this.tableList = res.data
        // this.total = Number(res.total)
        this.loading = false
      })
    },
  },
  created() {
    this.talkId = this.$route.query.talkId
  },
}
</script>

<style lang="scss" scoped>
.group {
  font-size: 12px;
  background: var(--color);
  color: var(--font-white, #fff);
  display: block;
  padding: 0 5px;
  height: 24px;
  line-height: 24px;
  border-radius: 5px;
  text-align: center;
  margin-left: 20px;
}
.data-content {
  margin-top: 10px;
  .chart-content {
    margin-top: 10px;
    .my_button {
      float: right;
    }
    .column {
      display: flex;
      .column-item {
        flex: 1;
      }
    }
  }
  .search-content {
    display: flex;
    justify-content: space-between;
  }
  .table-content {
    margin-top: 10px;
  }
}
</style>
