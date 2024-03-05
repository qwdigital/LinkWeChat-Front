<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :showScene="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">
        话术触达 Top5
        <el-popover
          trigger="hover"
          content="仅统计话术中轨迹素材被查看情况统计，排行权重：查看总人数 > 查看总次数 > 发送总次数"
          placement="top-start">
          <template #reference>
            <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
          </template>
        </el-popover>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column type="index" width="50"></el-table-column>
        <el-table-column label="话术标题" align="center" min-width="100" prop="talkTitle" show-overflow-tooltip />
        <el-table-column label="话术素材数量" align="center" min-width="100" prop="materialNum" show-overflow-tooltip>
          <template #default="scope">
            <el-button text @click="numClick(scope.row)">{{ scope.row.materialNum }}</el-button>
          </template>
        </el-table-column>
        <el-table-column
          label="查看总人数"
          align="center"
          min-width="100"
          prop="viewByTotalNum"
          show-overflow-tooltip />
        <el-table-column label="查看总次数" align="center" min-width="100" prop="viewTotalNum" show-overflow-tooltip />
        <el-table-column label="发送总次数" align="center" min-width="100" prop="sendTotalNum" show-overflow-tooltip />
      </el-table>
      <!-- <div class="bottom"> -->
    </div>
    <!-- 话术素材弹框 -->
    <ScriptMaterial
      :query="obj"
      talkType="0"
      resourceType="2"
      :visible="dialogVisible"
      @visibleChange="visibleChange" />
  </div>
</template>
<script>
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import ScriptMaterial from '@/components/ContentCenter/ScriptMaterial'
import {
  getTableExport,
  getBarTop5Total,
  getLineChartTotal,
  getSceneTotal,
} from '@/api/drainageCode/customerService.js'
import { getCount, getTableTotal } from '@/api/contentCenter/common.js'
import { download } from '@/utils/common'
import { dateFormat } from '@/utils/index'

export default {
  name: 'scene-statistics-scene',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
    ScriptMaterial,
  },
  data() {
    return {
      exportLoading: false,
      dialogVisible: false,
      legend: ['发送次数', '查看次数', '查看人数'],
      xdata: [],
      series: [],
      activeName: 'first',
      cardData: [
        {
          title: '发送总次数 ',
          tips: '全部话术中的素材在侧边栏被员工发送次数',
          value: 0,
          noArrow: true,
        },
        {
          title: '查看总次数',
          tips: '全部话术中的轨迹素材被客户打开的总次数，不去重',
          value: 0,
        },
        {
          title: '查看总人数',
          tips: '全部话术中的轨迹素材被客户打开且授权的总人数，去重',
          value: 0,
        },
        {
          title: '今日发送次数',
          tips: '全部话术中的素材今日在侧边栏被员工发送的次数',
          value: 0,
        },
        {
          title: '今日查看次数',
          tips: '全部话术中的轨迹素材今日被客户打开的次数，不去重',
          value: 0,
        },
        {
          title: '今日查看人数',
          tips: '全部话术中的轨迹素材今日被客户打开且授权的人数，去重',
          value: 0,
        },
      ],
      query: {
        moduleType: 2,
        talkType: 0,
        resourceType: 2,
      },
      tableList: [],
      loading: false,
      searchData: {},
      bar1: [],
      bar2: [],
      value1: [],
      value2: [],
      tableSearch: {},
      obj: {},
    }
  },
  methods: {
    //
    numClick(row) {
      this.obj = row
      this.dialogVisible = true
    },
    visibleChange(val) {
      this.dialogVisible = val
    },
    getLineData(data) {
      this.searchData = data
      data.moduleType = 2
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
    // getTop5Fn(data) {
    //   getBarTop5Total(data).then((res) => {
    //     if (res.data.consult && res.data.consult.length) {
    //       this.bar1 = []
    //       this.value1 = []
    //       res.data.consult.forEach((dd) => {
    //         this.bar1.push(dd.sceneName)
    //         this.value1.push(dd.total)
    //       })
    //     } else {
    //       this.bar1 = []
    //       this.value1 = []
    //     }
    //     if (res.data.visit && res.data.visit.length) {
    //       this.bar2 = []
    //       this.value2 = []
    //       res.data.consult.forEach((dd) => {
    //         this.bar2.push(dd.sceneName)
    //         this.value2.push(dd.total)
    //       })
    //     } else {
    //       this.bar2 = []
    //       this.value2 = []
    //     }
    //   })
    // },
    getTableChangeSize() {
      this.loading = true
      getTableTotal(this.query).then((res) => {
        this.tableList = res.data
        this.loading = false
      })
    },
    // getTableFn(data) {
    //   this.loading = true
    //   this.tableSearch = data
    //   getTableTotal(Object.assign({}, this.query, data)).then((res) => {
    //     this.tableList = res.rows
    //     this.total = Number(res.total)
    //     this.loading = false
    //   })
    // },
  },
  created() {
    // this.getSceneTotalFn()
    // this.getTop5Fn()
    this.getTableChangeSize()
  },
}
</script>
<style lang="scss" scoped>
.total-list {
  .item {
    padding: 10px;
    background: var(--bg-white);
  }
}
</style>
