<template>
  <div>
    <el-tabs :model-value="active">
      <el-tab-pane label="活码欢迎语" name="1">
        <Tab ref="tab1" type="1" @total="totalChange"></Tab>
      </el-tab-pane>
      <el-tab-pane label="员工欢迎语" name="2">
        <Tab ref="tab2" type="2" @total="totalChange"></Tab>
      </el-tab-pane>
      <el-tab-pane label="入群欢迎语" name="3">
        <Tab ref="tab3" type="3" @total="totalChange"></Tab>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import Tab from './components/Tab.vue'
export default {
  name: 'Welcome',
  components: { Tab },
  props: {},
  data() {
    return {
      active: this.$route.query.index || '1',
      total1: 0,
      total2: 0,
      total3: 0,
    }
  },
  watch: {},
  computed: {},
  created() {
    if (this.$route.query.type) {
      this.active = this.$route.query.type
    }
  },
  mounted() {
    this.$store.setBusininessDesc(
      `
      <div>创建欢迎语模板，在客户通过员工活码、非活码添加员工或者客户入群时，系统自动回复欢迎语</div>
    `,
    )
  },
  methods: {
    totalChange([type, total]) {
      this['total' + type] = total
    },
  },
}
</script>

<style lang="scss" scoped></style>
