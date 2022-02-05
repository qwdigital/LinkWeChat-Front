<template>
  <div>
    <el-steps class="g-card g-pad20" style="margin-top:10px;" :active="currentActive" align-center>
      <el-step title="账号信息"></el-step>
      <el-step title="欢迎语"></el-step>
      <el-step title="接待规则"></el-step>
    </el-steps>
    <div v-show="currentActive === 1">
      <part1 @next="getBase"></part1>
    </div>
    <div v-show="currentActive === 2">
      <part2 @update="getWecome"></part2>
    </div>
    <div v-show="currentActive === 3">
      <part3></part3>
    </div>
  </div>
</template>
<script>
  import Part1 from './part1.vue'
  import Part2 from './part2.vue'
  import Part3 from './part3.vue'
  import { addService } from '@/api/drainageCode/customerService.js'
  export default {
    name: 'customer-service-manage-add',
    data () {
      return {
        currentActive: 1
      }
    },
    components: {
      Part1,
      Part2,
      Part3
    },
    methods: {
      getBase (data) {
        console.log(data)
        this.currentActive = 2
      },
      getWecome (type, data) {
        console.log(data)
        this.currentActive = type
      }
    },
    mounted () {

    },
    created () {

    }
  }
</script>
<style lang="scss" scoped>
  .tab {
    height: 78px;
    background: #fff;
    border-top: 1px solid #f1f1f1;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
  }
</style>
