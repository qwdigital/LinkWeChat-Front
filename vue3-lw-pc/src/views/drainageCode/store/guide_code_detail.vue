<template>
  <CacheElTabs #="{ opened }">
    <el-tab-pane label="活码信息">
      <base-detail :isDetail="true"></base-detail>
    </el-tab-pane>
    <el-tab-pane label="数据统计">
      <guide-code-analyse></guide-code-analyse>
    </el-tab-pane>
  </CacheElTabs>
</template>
<script>
import BaseDetail from './base_detail'
import GuideCodeAnalyse from './guide_code_analyse'
export default {
  name: 'store-detail',
  data() {
    return {}
  },
  components: {
    BaseDetail,
    GuideCodeAnalyse,
  },
}
</script>
<style lang="scss" scoped></style>
