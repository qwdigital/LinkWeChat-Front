<template>
  <div>
    <div class="total-list">
      <CardGroupIndex :data="cardData"></CardGroupIndex>
    </div>
  </div>
</template>
<script>
  import CardGroupIndex from '@/components/CardGroupIndex.vue'
  export default {
    name: 'scene-statistics',
    components: {
      CardGroupIndex
    },
    data () {
      return {
        cardData: [
          {
            title: '访问客户总数',
            tips: '进入咨询页面的客户总数(包含重复);',
            value: 1234,
            noArrow: true
          },
          {
            title: '咨询客户总数',
            tips: '企业员工在单聊中发送的消息的数量',
            value: 12345,
          },
          {
            title: '接待客户总数',
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
      }
    },
    methods: {

    },
    created () {

    }
  }
</script>
<style lang="scss" scoped>
  .total-list {
    .item {
      padding: 10px;
      background-color: #fff;
    }
  }
</style>