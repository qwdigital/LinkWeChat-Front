<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>
    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <search-title @search="getLineData"></search-title>
      <chart-line style="height: 300px" :legend="legend" :xData="xdata" :series="series"></chart-line>
    </div>
    <div class="g-card">
      <div class="g-card-title">活码客群</div>
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="客群名称" align="center" min-width="100" prop="groupName" show-overflow-tooltip />
        <el-table-column label="群主" align="center" min-width="100" prop="groupOwner" show-overflow-tooltip />
        <el-table-column
          label="群总人数"
          align="center"
          prop="chatGroupMemberTotalNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="进群人数"
          align="center"
          prop="joinChatGroupTotalMemberNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column
          label="退群人数"
          align="center"
          prop="exitChatGroupTotalMemberNum"
          min-width="100"
          show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" align="center" width="180">
          <template #default="{ row }">
            <el-button
              text
              @click="
                $router.push({
                  name: lwConfig.GROUP_DETAIL_ROUTE_NAME,
                  query: {
                    chatId: row.chatId,
                  },
                })
              ">
              查看详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>
<script>
import ChartLine from '@/components/ChartLine.vue'
import SearchTitle from '@/components/SearchTitle.vue'

import { getLineChartTotal, getTableTotal, getGroupDetail } from '@/api/drainageCode/group.js'
export default {
  name: 'group-analyse',
  components: {
    SearchTitle,
    ChartLine,
  },
  data() {
    return {
      id: '',
      state: '',
      exportLoading: false,
      legend: ['进群人数', '退群人数'],
      xdata: [],
      series: [],
      cardData: [
        {
          title: '活码客群数',
          tips: '当前群活码所有群聊数量，包括自动建立的群',
          value: 0,
          noArrow: true,
        },
        {
          title: '群总人数',
          tips: '当前群活码全部群的总人数(含员工及重复)',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '进群人数',
          tips: '通过当前群活码进群的人数(去重)',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
        {
          title: '退群人数',
          tips: '通过当前群活码进群后退群的人数(去重)',
          value: 0,
          title1: '较昨日',
          value1: 0,
        },
      ],
      tableList: [],
      loading: false,
      searchData: {},
      bar1: [],
      bar2: [],
    }
  },
  methods: {
    getCardData() {
      getGroupDetail(this.id).then((res) => {
        if (res.code === 200) {
          let data = res.data
          this.cardData[0].value = data.chatGroupNum
          this.cardData[1].value = data.chatGroupMemberTotalNum //群总人数
          this.cardData[2].value = data.joinChatGroupTotalMemberNum // 进群
          this.cardData[3].value = data.exitChatGroupTotalMemberNum // 退群
          this.cardData[1].value1 =
            Number(data.newJoinChatGroupTotalMemberNum) - Number(data.oldJoinChatGroupTotalMemberNum)
          this.cardData[2].value1 =
            Number(data.joinChatGroupTotalMemberNum) - Number(data.oldJoinChatGroupTotalMemberNum)
          this.cardData[3].value1 =
            Number(data.exitChatGroupTotalMemberNum) - Number(data.oldExitChatGroupTotalMemberNum)
        }
      })
    },
    getLineData(data) {
      // this.$forceUpdate()
      getLineChartTotal({ ...data, state: this.state }).then((res) => {
        this.xdata = []
        this.series = []
        let arr1 = []
        let arr2 = []
        if (res.data && res.data.length) {
          res.data.forEach((dd) => {
            this.xdata.push(dd.dateTime)
            arr1.push(dd.joinChatGroupTotalMemberNum)
            arr2.push(dd.exitChatGroupTotalMemberNum)
          })
          this.series = [arr1, arr2]
        }
      })
    },
    getTableFn() {
      this.loading = true
      getTableTotal(this.id).then((res) => {
        this.tableList = res.data
        this.loading = false
      })
    },
  },
  created() {
    this.id = this.$route.query.id
    this.state = this.$route.query.state
    this.getCardData()
    this.getTableFn()
  },
}
</script>
<style lang="scss" scoped></style>
