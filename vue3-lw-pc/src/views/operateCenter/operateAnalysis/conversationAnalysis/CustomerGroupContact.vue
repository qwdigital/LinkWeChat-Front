<script>
import TabContent from '../components/TabContent'

import * as api from '@/api/operateCenter/conversationAnalysis'
export default {
  name: '',
  components: { TabContent },
  data() {
    return {
      cardData: [],
      tabs: [
        {
          label: '群聊总数',
          type: 'groupChatTotalChart',
        },
        {
          label: '群聊消息数',
          type: 'groupChatMessageNumChart',
        },
        {
          label: '发送消息群成员数',
          type: 'sendMessageGroupMemberChart',
        },
      ],
      active: '0',
      api,
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
              tips: '企业员工的客户群中有过聊天的数量',
              value: data.ydChatTotal,
              title1: '较前日',
              value1: data.bydChatTotal,
            },
            {
              title: '昨日群聊消息数',
              tips: '企业员工的客户群中的消息数量',
              value: data.ydMsgTotal,
              title1: '较前日',
              value1: data.bydMsgTotal,
            },
            {
              title: '昨日发送消息群成员数',
              tips: '在客户群中发过消息的群成员的数量，包含企业员工',
              value: data.ydMemberHasMsg,
              title1: '较前日',
              value1: data.bydMemberHasMsg,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <div class="g-card">
      <div class="g-card-title">数据趋势</div>
      <el-tabs v-model="active">
        <el-tab-pane v-for="(item, index) of tabs" :key="index" :label="item.label">
          <TabContent :type="item.type" :legend="[item.label]" :request="api.getTotalCntGroup"></TabContent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <div class="g-card">
      <div class="g-card-title">数据报表</div>
      <TabContent
        type="customerGroupContactTable"
        :request="api.getTotalCntGroup"
        :requestExport="api.realDataExportGroup"></TabContent>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
