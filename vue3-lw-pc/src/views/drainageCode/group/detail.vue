<script>
import BaseInfo from './baseInfo'

export default {
  components: {
    BaseInfo,
    analyse: defineAsyncComponent(() => import('./analyse')),
    statistics: defineAsyncComponent(() => import('./statistics')),
    CodeLink: defineAsyncComponent(() => import('../components/CodeLink')),
  },
  data() {
    return {}
  },
  created() {},
  methods: {},
}
</script>

<template>
  <CacheElTabs #="{ opened }">
    <el-tab-pane label="活码信息">
      <BaseInfo />
    </el-tab-pane>
    <el-tab-pane label="客群统计">
      <analyse v-if="opened.includes('1')" />
    </el-tab-pane>
    <el-tab-pane label="活码统计">
      <statistics v-if="opened.includes('2')" />
    </el-tab-pane>
  </CacheElTabs>
</template>
