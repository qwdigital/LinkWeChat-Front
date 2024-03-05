<template>
  <div>
    <!-- 素材分析 -->
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title :showScene="true" @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">
        素材触达 Top5
        <el-popover
          trigger="hover"
          content="仅统计轨迹素材被查看情况统计，排行权重：查看总人数 > 查看总次数 > 发送总次数"
          placement="top-start">
          <template #reference>
            <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
          </template>
        </el-popover>
      </div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column type="index" width="50"></el-table-column>
        <el-table-column label="素材" align="center" min-width="100" prop="materialName" show-overflow-tooltip>
          <template #default="{ row }">
            <!-- <el-button text @click="numClick(scope.row.id)">{{
                  scope.row.materialName
                }}</el-button> -->
            <PicTitContent :row="row" />
          </template>
        </el-table-column>
        <el-table-column label="素材类型" align="center" min-width="100" show-overflow-tooltip>
          <template #default="{ row }">
            <div>
              {{ $dictMaterialType[row.mediaType]?.name }}
            </div>
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
    </div>
  </div>
</template>
<script>
import ChartBar from '@/components/ChartBar.vue'
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import { getCount, getTableTotal } from '@/api/contentCenter/common.js'
import PicTitContent from '@/views/contentCenter/components/PicTitContent'
export default {
  name: 'scene-statistics-scene',
  components: {
    SearchTitle,
    ChartLine,
    ChartBar,
    PicTitContent,
  },
  data() {
    return {
      exportLoading: false,
      // barLegend1: ['访问客户总数'],
      // barLegend2: ['咨询客户总数'],
      legend: ['发送次数', '查看次数', '查看人数'],
      xdata: [],
      series: [],
      activeName: 'first',
      cardData: [
        {
          title: '发送总次数 ',
          tips: '全部素材在侧边栏被员工发送次数',
          value: 0,
          noArrow: true,
        },
        {
          title: '查看总次数',
          tips: '全部轨迹素材被客户打开的总次数，不去重',
          value: 0,
        },
        {
          title: '查看总人数',
          tips: '全部轨迹素材被客户打开且授权的总人数，去重',
          value: 0,
        },
        {
          title: '今日发送次数',
          tips: '全部素材今日在侧边栏被员工发送的次数',
          value: 0,
        },
        {
          title: '今日查看次数',
          tips: '全部轨迹素材今日被客户打开的次数，不去重',
          value: 0,
        },
        {
          title: '今日查看人数',
          tips: '全部轨迹素材今日被客户打开且授权的人数，去重     ',
          value: 0,
        },
      ],
      query: {
        moduleType: 1,
      },
      tableList: [],
      loading: false,
      searchData: {},
      bar1: [],
      bar2: [],
      value1: [],
      value2: [],
      tableSearch: {},
    }
  },
  methods: {
    // numClick(id) {
    //   this.$router.push({
    //     url: '',
    //     id,
    //   })
    // },
    getLineData(data) {
      // this.searchData = data
      data.moduleType = 1
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
      getTableTotal(this.query).then((res) => {
        this.tableList = res.data
        this.loading = false
      })
    },
  },
  created() {
    this.getTableChangeSize()
    this.$store.setBusininessDesc(
      `
      <div>全部素材发送与查看情况数据统计与分析</div>
    `,
    )
  },
}
</script>
<style lang="scss" scoped></style>
