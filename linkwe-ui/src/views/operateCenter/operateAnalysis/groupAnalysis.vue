<script>
import TabContent from './components/TabContent'
import TabContentRealGroupData from './components/TabContentRealGroupData'
export default {
  name: '',
  components: { TabContent, TabContentRealGroupData },
  data() {
    return {
      cardData: [
        {
          title: '客群总数',
          tips: '企业员工全部客户群数量',
          value: 1222453
        },
        {
          title: '今日新增客群',
          tips: '今日新创建的客群数',
          value: 1222453,
          title1: '较昨日',
          value1: 344
        },
        {
          title: '今日解散客群',
          tips: '今日解散的客户群数',
          value: 1222453,
          title1: '较昨日',
          value1: 344
        },
        {
          title: '客群成员总数',
          tips: '全部客群成员的总数，包括企业员工',
          value: 1222453,
          title1: '含员工',
          value1: 344
        },
        {
          title: '今日新增客群成员',
          tips: '今日进入群聊的成员数量，包括企业员工',
          value: 1222453,
          title1: '较昨日',
          value1: 344
        },
        {
          title: '今日新增客群成员',
          tips: '今日退出群聊的成员数量，包括企业员工',
          value: 1222453,
          title1: '较前日',
          value1: 344
        }
      ],
      activeTrend: 0,
      activeSheet: 0
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>企业客户群相关数据统计与分析</div>
      `
    )
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = Number(total)
          this.loading = false
          this.ids = []
        })
        .catch(() => {
          this.loading = false
        })
    }
  }
}
</script>

<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div>
      <div>数据趋势</div>
      <el-tabs v-model="activeTrend">
        <el-tab-pane label="客群总数">
          <TabContent type="customerGroupTotalChart"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="客群成员总数">
          <TabContent type="customerGroupMemberTotalChart"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="实时数据">
          <TabContentRealGroupData></TabContentRealGroupData>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div>
      <div>数据报表</div>
      <el-tabs v-model="activeSheet">
        <el-tab-pane label="客群总数">
          <TabContent type="customerGroupTotalTable"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="客群成员总数">
          <TabContent type="customerGroupMemberTotalTable"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
