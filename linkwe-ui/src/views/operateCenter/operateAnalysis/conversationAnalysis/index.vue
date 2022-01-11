<script>
import CustomerContact from './CustomerContact'
import CustomerGroupContact from './CustomerGroupContact'
import Conversation from './Conversation'
export default {
  name: '',
  components: { CustomerContact, CustomerGroupContact, Conversation },
  data() {
    return {
      active: 0
    }
  },
  computed: {},
  watch: {},
  created() {
    // this.getList()
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>企业客户/客户群联系相关数据统计与分析</div>
      `
    )
  },
  mounted() {},
  methods: {}
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
      <Conversation></Conversation>
    </el-tab-pane>
  </el-tabs>
</template>

<style lang="scss" scoped></style>
