<script>
import TabContent from '../components/TabContent'
import CardGroupIndex from '@/components/CardGroupIndex'
import * as api from '@/api/operateCenter/conversationAnalysis'
export default {
  name: '',
  components: { TabContent, CardGroupIndex },
  data() {
    return {
      cardData: [],
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
      active: 0,
      api
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    getList() {
      this.loading = true
      api
        .getAnalysisGroup()
        .then(({ data }) => {
          data || (data = {})
          this.cardData = [
            {
              title: '昨日群聊总数',
              tips: '企业员工全部客户数量（包含重复）',
              value: data.ydChatTotal,
              title1: '较前日',
              value1: data.bydChatTotal,
              noArrow: true
            },
            {
              title: '昨日群聊消息数',
              tips: '企业员工今日添加的客户数（包含重复及已流失）',
              value: data.ydMsgTotal,
              title1: '较前日',
              value1: data.bydMsgTotal
            },
            {
              title: '昨日发送消息群成员数',
              tips: '今日删除企业员工的客户数',
              value: data.ydMemberHasMsg,
              title1: '较前日',
              value1: data.bydMemberHasMsg
            }
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
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
          <TabContent
            :type="item.type"
            :legend="[item.label]"
            :request="api.getTotalCntGroup"
          ></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div>
      <div>数据报表</div>
      <TabContent type="customerGroupContactTable" :request="api.getTotalCntGroup"></TabContent>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
