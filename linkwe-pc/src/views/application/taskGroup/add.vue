<template>
  <div>
    <div class="g-card">
      <el-steps :active="currentActive" align-center finish-status="success">
        <el-step title="基本信息"></el-step>
        <el-step title="任务设置"></el-step>
        <el-step title="兑奖规则"></el-step>
      </el-steps>
    </div>
    <template v-if="currentActive == 0">
      <FassionBase :baseData="form"></FassionBase>
    </template>
  </div>
</template>

<script>
  import FassionBase from '../common/FassionBase.vue'
  export default {
    name: 'task-group-add',
    components: {
      FassionBase
    },
    data() {
      return {
        currentActive: 0,
        form: {
          fassionType: 1,
          fassionName: '',
          fassionStartTime: '',
          fassionEndTime: '',
          executeUserOrGroup: null
        }
      }
    },
    methods: {}
  }
</script>

<style lang="scss" scoped></style>
