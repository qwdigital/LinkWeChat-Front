<script>
import CustomerContact from './CustomerContact'
import CustomerGroupContact from './CustomerGroupContact'
import Archive from './Archive'
export default {
  name: '',
  components: { CustomerContact, CustomerGroupContact, Archive },
  data() {
    return {
      active: '0',
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
    this.$store.setBusininessDesc(
      `
        <div>企业客户/客户群联系相关数据统计与分析</div>
      `,
    )
  },
  mounted() {},
  methods: {},
}
</script>

<template>
  <el-tabs v-model="active">
    <el-tab-pane label="客户联系">
      <CustomerContact></CustomerContact>
    </el-tab-pane>
    <el-tab-pane label="客群联系">
      <CustomerGroupContact></CustomerGroupContact>
    </el-tab-pane>
    <el-tab-pane label="会话存档">
      <Archive></Archive>
    </el-tab-pane>
  </el-tabs>
</template>

<style lang="scss" scoped></style>
