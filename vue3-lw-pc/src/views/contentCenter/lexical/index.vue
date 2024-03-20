<template>
  <div>
    <!-- 内容洞察 -->
    <CacheElTabs #="{ opened }">
      <el-tab-pane label="企业话术"><Enterprise /></el-tab-pane>
      <el-tab-pane label="客服话术">
        <Service />
      </el-tab-pane>
    </CacheElTabs>
  </div>
</template>
<script>
export default {
  name: 'customer-service-statistics',
  components: {
    Enterprise: defineAsyncComponent(() => import('./enterprise')),
    Service: defineAsyncComponent(() => import('./service')),
  },
  data() {
    return {}
  },
  methods: {},
  created() {
    this.$store.setBusininessDesc(
      `
      <div>全部话术发送与查看情况数据统计与分析</div>
    `,
    )
  },
}
</script>
<style lang="scss" scoped></style>
