<template>
  <div class="g-card">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="员工统计" name="first" v-if="this.type !== 3"><Staff /></el-tab-pane>
      <el-tab-pane label="客户统计" name="second"><Custom /></el-tab-pane>
      <el-tab-pane label="互动统计" name="third"><Interaction /></el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
import Staff from './components/Staff.vue'
import Custom from './components/Custom.vue'
import Interaction from './components/Interaction.vue'
export default {
  components: { Staff, Custom, Interaction },
  mounted() {

    this.type = this.$route.query.type
    if (this.type === 3) {
      this.activeName = 'second'
    }
  },
  data() {
    return {
      activeName: 'first',
      // id: undefined,
      type: undefined, // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
    }
  },
  methods: {
    handleClick(tab, event) {
      console.log(tab, event)
    },
  },
}
</script>
