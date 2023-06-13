<template>
  <div class="show_title">
    <div v-if="titleType === 1">
      <span class="my_title">标签筛选 > </span> 渠道标签
    </div>
    <div v-else-if="titleType === 2">
      <span class="my_title">标签筛选 > </span> 企业标签
    </div>
    <div v-else-if="titleType === 3">
      <span class="my_title">画像筛选 > </span> 客户属性
    </div>
    <div v-else-if="titleType === 4">
      <span class="my_title">画像筛选 > </span> 客户行为
    </div>
    <div v-else-if="titleType === 5">
      <span class="my_title">其他筛选 > </span> 已有人群
    </div>
  </div>
</template>
<script>
  export default {
    name: 'show-people-title',
    data () {
      return {
      }
    },
    props: {
      titleType: {
        type: Number,
        default: null
      }
    },
    methods: {

    },
    created () {

    },
  }
</script>
<style lang="scss" scoped>
  .show_title {
    font-size: 16px;
  }
  .my_title {
    font-size: 16px;
    font-weight: 600;
    color: rgba(0, 0, 0, 0.9);
  }
</style>
