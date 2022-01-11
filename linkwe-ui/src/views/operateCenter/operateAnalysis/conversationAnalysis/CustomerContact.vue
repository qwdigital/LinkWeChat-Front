<script>
import TabContent from '../components/TabContent'
import TabContentstaffContact from './TabContentstaffContact'
export default {
  name: '',
  components: { TabContent, TabContentstaffContact },
  data() {
    return {
      cardData: [
        {
          title: '昨日单聊总数',
          tips: '企业员工发送过消息的单聊数量',
          value: 1222453,
          title1: '较前日',
          value1: 344,
          noArrow: true
        },
        {
          title: '昨日发送消息数',
          tips: '企业员工在单聊中发送的消息的数量',
          value: 1222453,
          title1: '较前日',
          value1: 344
        },
        {
          title: '昨日回复单聊占比',
          tips: '一个自然日内，客户首先发消息的会话中，成员回复了的会话的占比。若数据展示为“-”代表没有给成员发送消息的客户，该项无法计算',
          value: 1222453,
          title1: '较前日',
          value1: 344
        },
        {
          title: '平均首次回复时长(分)',
          tips: '一个自然日内，客户首先发消息至成员回复之间的时长，为首次回复时长。所有的首次回复总时长/已回复单聊总数，即为平均首次回复时长。若数据展示为“-”代表没有给成员发送消息的客户，该项无法计算',
          value: 1222453,
          title1: '较前日',
          value1: 344
        }
      ],
      tabs: [
        {
          label: '单聊总数',
          type: 'singleChatTotalChart'
        },
        {
          label: '发送消息数',
          type: 'sendMessageNumChart'
        },
        {
          label: '回复单聊占比',
          type: 'replySingleChatChart'
        },
        {
          label: '平均首次回复时长',
          type: 'averageReplyDurationChart'
        }
      ],
      active: 0
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
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
      <el-tabs v-model="active">
        <el-tab-pane v-for="(item, index) of tabs" :key="index" :label="item.label">
          <TabContent :type="item.type" :legend="[item.label]"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div>
      <div>员工客户Top5</div>
      <TabContentstaffContact type="staffCustomerBar"></TabContentstaffContact>
    </div>

    <div>
      <div>数据报表</div>
      <TabContent type="customerContactTable"></TabContent>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
