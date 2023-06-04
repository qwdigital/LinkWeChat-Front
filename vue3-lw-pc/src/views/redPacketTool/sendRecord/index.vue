<script>
import Customer from './Customer'
import Group from './Group'
export default {
  components: {
    Customer,
    Group,
  },
  data() {
    return {
      activeName: '0',
    }
  },
  watch: {},
  created() {
    this.$store.setBusininessDesc(
      `
        <div>用于统计员工发放红包给客户或客户群的详细记录</div>
      `,
    )
  },
}
</script>

<template>
  <el-tabs v-model="activeName">
    <el-tab-pane label="发放客户">
      <Customer></Customer>
    </el-tab-pane>
    <el-tab-pane label="发放客户群">
      <Group></Group>
    </el-tab-pane>
  </el-tabs>
</template>

<style scoped lang="scss"></style>
