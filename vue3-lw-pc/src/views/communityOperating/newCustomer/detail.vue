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
  <el-tabs class="sticky-t" v-model="active">
    <el-tab-pane label="活码信息"></el-tab-pane>
    <el-tab-pane label="拉群统计"></el-tab-pane>
  </el-tabs>
  <aev v-show="active == 0" />
  <statistics v-show="active == 1" />
</template>

<style lang="scss" scoped></style>
