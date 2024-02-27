<template>
  <CacheElTabs #="{ opened }">
    <el-tab-pane label="员工检索">
      <employee></employee>
    </el-tab-pane>
    <el-tab-pane label="客户检索">
      <customer v-if="opened.includes('1')"></customer>
    </el-tab-pane>
    <el-tab-pane label="全局检索">
      <global v-if="opened.includes('2')"></global>
    </el-tab-pane>
  </CacheElTabs>
</template>
<script>
export default {
  components: {
    employee: defineAsyncComponent(() => import('./employee')),
    customer: defineAsyncComponent(() => import('./customer')),
    global: defineAsyncComponent(() => import('./global')),
  },
  data() {
    return {
      activeName: '1',
    }
  },
  methods: {},
}
</script>
<style lang="scss" scoped>
::v-deep.pd15 {
  padding: 15px;
}
</style>
