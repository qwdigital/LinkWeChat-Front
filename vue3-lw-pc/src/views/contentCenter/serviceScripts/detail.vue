<template>
  <div>
    <el-tabs v-model="activeName">
      <el-tab-pane label="话术素材" name="first">
        <div v-if="activeName === 'first'">
          <Material />
        </div>
      </el-tab-pane>
      <el-tab-pane label="话术统计" name="second">
        <Statistics v-if="activeName === 'second'" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import Material from './Material.vue'
import Statistics from './Statistics.vue'
export default {
  components: { Material, Statistics },
  data() {
    return {
      activeName: 'first',
    }
  },
}
</script>

<style></style>
