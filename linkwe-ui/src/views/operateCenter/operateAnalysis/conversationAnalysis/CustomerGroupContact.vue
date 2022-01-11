<script>
import TabContent from '../components/TabContent'
export default {
  name: '',
  components: { TabContent },
  data() {
    return {
      cardData: [
        {
          title: '昨日群聊总数',
          tips: '企业员工全部客户数量（包含重复）',
          value: 1222453,
          title1: '较前日',
          value1: 344,
          noArrow: true
        },
        {
          title: '昨日群聊消息数',
          tips: '企业员工今日添加的客户数（包含重复及已流失）',
          value: 1222453,
          title1: '较前日',
          value1: 344
        },
        {
          title: '昨日发送消息群成员数',
          tips: '今日删除企业员工的客户数',
          value: 1222453,
          title1: '较前日',
          value1: 344
        }
      ],
      tabs: [
        {
          label: '群聊总数',
          type: 'groupChatTotalChart'
        },
        {
          label: '群聊消息数',
          type: 'groupChatMessageNumChart'
        },
        {
          label: '发送消息群成员数',
          type: 'sendMessageGroupMemberChart'
        }
      ],
      active: 0
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
    console.log(3)
  },
  mounted() {
    console.log(4)
  },
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
      <el-tabs v-model="active">
        <el-tab-pane v-for="(item, index) of tabs" :key="index" :label="item.label">
          <TabContent :type="item.type" :legend="[item.label]"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div>
      <div>数据报表</div>
      <TabContent type="customerGroupContactTable"></TabContent>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
