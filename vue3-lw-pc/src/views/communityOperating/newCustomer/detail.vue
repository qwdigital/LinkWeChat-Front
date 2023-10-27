<script>
export default {
  name: '',
  components: {
    aev: defineAsyncComponent(() => import('./aev')),
    statistics: defineAsyncComponent(() => import('./statistics')),
  },
  data() {
    return {
      active: this.$route.query.index || '0',
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>

<template>
  <el-tabs v-model="active">
    <el-tab-pane label="活码信息">
      <aev />
    </el-tab-pane>
    <el-tab-pane label="拉群统计">
      <statistics />
    </el-tab-pane>
  </el-tabs>
</template>

<style lang="scss" scoped></style>
