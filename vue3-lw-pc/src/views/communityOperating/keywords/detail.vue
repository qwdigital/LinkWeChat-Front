<script>
export default {
  name: '',
  components: {
    aev: defineAsyncComponent(() => import('./aev')),
    statistics: defineAsyncComponent(() => import('./statistics')),
  },
  data() {
    return {}
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>

<template>
  <CacheElTabs #="{ opened }">
    <el-tab-pane label="活码信息">
      <aev v-if="opened.includes('0')" />
    </el-tab-pane>
    <el-tab-pane label="拉群统计">
      <statistics v-if="opened.includes('1')" />
    </el-tab-pane>
  </CacheElTabs>
</template>

<style lang="scss" scoped></style>
