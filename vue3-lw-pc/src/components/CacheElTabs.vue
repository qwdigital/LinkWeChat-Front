<!-- 扩展<el-tabs></el-tabs> 缓存当前激活索引和组件 -->
<script>
export default {
  components: {},
  data() {
    return {
      active: 0,
      opened: [],
    }
  },
  computed: {},
  watch: {},
  created() {
    if (this.$route.path != sessionStorage.activeTabPagePath) {
      sessionStorage.activeTabIndex = ''
    }
    this.active = sessionStorage.activeTabIndex = this.$route.query.index || sessionStorage.activeTabIndex || '0'
    sessionStorage.activeTabPagePath = this.$route.path
    this.opened.push(this.active)
  },
  mounted() {},
  methods: {
    tabClick(v) {
      this.active = sessionStorage.activeTabIndex = v.paneName
      this.opened.includes(v.paneName) || this.opened.push(v.paneName)
    },
  },
}
</script>

<template>
  <el-tabs v-model="active" @tab-click="tabClick">
    <slot v-bind="{ active, opened }"></slot>
  </el-tabs>
</template>

<style lang="scss" scoped>
.el-tabs--top {
  // z-index: 99;
  // position: sticky !important;
  // top: 0;
  ::v-deep .el-tabs__header {
    z-index: 99;
    position: sticky !important;
    top: 0;
    background: var(--bg-white);
    border-radius: var(--border-radius);
    box-shadow: 0px 4px 20px 0px var(--bg-black-10);
    overflow: hidden;
  }
  ::v-deep .el-tabs__item.is-top:nth-child(2) {
    padding-left: 20px;
  }
  ::v-deep .el-tabs__item.is-top:last-child {
    padding-right: 20px;
  }
}
</style>
