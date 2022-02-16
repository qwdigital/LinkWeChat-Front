<template>
  <div>
    <el-tabs v-model="activeName">
      <el-tab-pane label="场景分析" name="first">
        <Scene v-if="activeName === 'first'" />
      </el-tab-pane>
      <el-tab-pane label="咨询分析" name="second">
        <Search v-if="activeName === 'second'" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
  import Scene from './scene.vue'
  import Search from "./search.vue"
  export default {
    name: 'customer-service-statistics',
    components: {
      Scene,
      Search
    },
    data () {
      return {
        activeName: 'first'
      }
    },
    methods: {

    },
    created () {
      this.$store.dispatch(
        'app/setBusininessDesc',
        `
      <div>渠道场景与客服维度相关数据统计与分析</div>
    `
      )
    }
  }
</script>
<style lang="scss" scoped>
</style>