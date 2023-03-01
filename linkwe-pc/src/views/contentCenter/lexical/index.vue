<template>
  <div>
    <!-- 内容洞察 -->
    <el-tabs v-model="activeName">
      <el-tab-pane label="企业话术" name="first">
        <Enterprise v-if="activeName === 'first'" />
      </el-tab-pane>
      <el-tab-pane label="客服话术" name="second">
        <Service v-if="activeName === 'second'" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
  import Enterprise from './enterprise.vue'
  import Service from "./service.vue"
  export default {
    name: 'customer-service-statistics',
    components: {
      Enterprise,
      Service
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
      <div>全部话术发送与查看情况数据统计与分析</div>
    `
      )
    }
  }
</script>
<style lang="scss" scoped>
</style>