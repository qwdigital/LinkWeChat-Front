<script>
import TabContent from './components/TabContent'
import CardGroupIndex from '@/components/CardGroupIndex'
import { getAnalysis } from '@/api/operateCenter/customerAnalysis'
export default {
  name: '',
  components: { TabContent, CardGroupIndex },
  data() {
    return {
      cardData: [
        {
          title: '客户总数',
          tips: '企业员工全部客户数量（包含重复）',
          value: 1222453,
          title1: '含重复',
          value1: 344,
          noArrow: true
        },
        {
          title: '今日新增客户',
          tips: '企业员工今日添加的客户数（包含重复及已流失）',
          value: 1222453,
          title1: '较昨日',
          value1: 344
        },
        {
          title: '今日流失客户',
          tips: '今日删除企业员工的客户数',
          value: 1222453,
          title1: '较昨日',
          value1: 344
        },
        {
          title: '今日净增客户',
          tips: '企业员工今日添加的客户数（不包含重复及已流失）',
          value: 1222453,
          title1: '较昨日',
          value1: 344
        },
        {
          title: '昨日发送申请',
          tips: '企业员工每天通过搜索手机号、扫一扫等渠道主动向客户发起的好友申请数',
          value: 1222453,
          title1: '较前日',
          value1: 344
        }
      ],
      active: 0
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>企业客户相关数据统计与分析</div>
      `
    )
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      getAnalysis(this.query)
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
      <el-tabs v-model="active">
        <el-tab-pane label="客户总数">
          <TabContent type="customerTotalChart"></TabContent>
        </el-tab-pane>
        <el-tab-pane label="实时数据">
          <TabContent type="realDataChart"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div>
      <div>员工客户 Top10</div>
      <TabContent type="staffCustomerBar"></TabContent>
    </div>

    <div>
      <div>数据报表</div>
      <TabContent type="customerTotalTable"></TabContent>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
