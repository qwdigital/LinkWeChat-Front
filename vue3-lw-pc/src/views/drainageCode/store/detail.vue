<template>
  <CacheElTabs #="{ opened }">
    <el-tab-pane label="门店信息">
      <edit-store :isDetail="true"></edit-store>
    </el-tab-pane>
    <el-tab-pane label="数据统计">
      <store-analyse></store-analyse>
    </el-tab-pane>
  </CacheElTabs>
</template>
<script>
import EditStore from './add'
import StoreAnalyse from './store_analyse'
export default {
  name: 'store-detail',
  data() {
    return {}
  },
  components: {
    EditStore,
    StoreAnalyse,
  },
}
</script>
<style lang="scss" scoped></style>
