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
    <template v-if="currentActive == 1">
      <FassionSettingVue :baseData="form"></FassionSettingVue>
    </template>
  </div>
</template>

<script>
  import FassionBase from '../common/FassionBase.vue'
  import FassionSettingVue from '../common/FassionSetting.vue'
  export default {
    name: 'task-group-add',
    components: {
      FassionBase,
      FassionSettingVue
    },
    data() {
      return {
        currentActive: 1,
        form: {
          fassionType: 1,
          fassionName: '',
          fassionStartTime: '',
          fassionEndTime: '',
          executeUserOrGroup: null,
          posterId: '',
          posterUrl: '',
          addWeUserOrGroupCode: {
            addWeUser: {
              executeUserCondit: {
                change: false,
                weUserIds: []
              },
              executeDeptCondit: {
                change: false,
                deptIds: [],
                posts: []
              }
            },
            addGroupCode: {
              autoCreateRoom: 0,
              roomBaseName: '',
              roomBaseId: null,
              chatIdList: ''
            }
          },
          content: ''
        }
      }
    },
    methods: {}
  }
</script>

<style lang="scss" scoped></style>
