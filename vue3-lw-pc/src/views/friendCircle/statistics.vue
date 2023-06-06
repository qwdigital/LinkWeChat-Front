<template>
  <div class="g-card">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="员工统计" name="first"><Staff /></el-tab-pane>
      <el-tab-pane label="客户统计" name="second"><Custom /></el-tab-pane>
      <el-tab-pane label="互动统计" name="third"><Interaction /></el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
import Staff from './compoments/Staff.vue'
import Custom from './compoments/Custom.vue'
import Interaction from './compoments/Interaction.vue'
export default {
  compoments: { Staff, Custom, Interaction },
  data() {
    return {
      activeName: 'second',
    }
  },
  methods: {
    handleClick(tab, event) {
      console.log(tab, event)
    },
  },
}
</script>
