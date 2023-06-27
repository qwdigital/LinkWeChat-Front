<template>
  <div>
    <div class="card-tab">
      <div class="item" :class="activeIndex === 0 ? 'active' : ''" @click="activeIndex = 0">活码信息</div>
      <div class="item" :class="activeIndex === 1 ? 'active' : ''" @click="activeIndex = 1">数据统计</div>
    </div>
    <div style="margin-top: 10px">
      <template v-if="activeIndex === 0">
        <base-detail :codeType="2"></base-detail>
      </template>
      <template v-if="activeIndex === 1">
        <store-code-analyse></store-code-analyse>
      </template>
    </div>
  </div>
</template>
<script>
import BaseDetail from './base_detail'
import StoreCodeAnalyse from './store_code_analyse'
export default {
  name: 'store-detail',
  data() {
    return {
      activeIndex: 0,
    }
  },
  components: {
    BaseDetail,
    StoreCodeAnalyse,
  },
}
</script>
<style lang="scss" scoped>
.active {
  font-weight: 600;
  color: var(--color) !important;
  background: var(--bg-white) !important;
  box-shadow: 0px 6px 30px 5px rgba(59, 59, 59, 0.05);
}
.card-tab {
  // margin-top: 10px;
  display: flex;
  div {
    width: 88px;
    height: 30px;
    background: var(--bg-black-11);
    border-radius: 32px 32px 32px 32px;
    font-size: 14px;
    color: var(--font-black-7);
    line-height: 30px;
    text-align: center;
    margin-top: 15px;
    margin-right: 12px;
    margin-bottom: 6px;
  }
  .item:hover {
    cursor: pointer;
    opacity: 0.8;
  }
}
</style>
