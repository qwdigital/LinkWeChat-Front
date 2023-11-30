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
      <FassionBase :baseData="form" @update="getData" @next="getNext"></FassionBase>
    </template>
    <template v-if="currentActive == 1">
      <FassionSettingVue :baseData="form" @update="getData" @next="getNext"></FassionSettingVue>
    </template>
    <template v-if="currentActive == 2">
      <FassionRules :baseData="form" @update="getData" @next="getNext"></FassionRules>
    </template>
  </div>
</template>

<script>
import FassionBase from '../common/FassionBase.vue'
import FassionSettingVue from '../common/FassionSetting.vue'
import FassionRules from '../common/FassionRules.vue'
import { getFassionDetail } from '../taskGroup/api'
export default {
  name: 'task-group-add',
  components: {
    FassionBase,
    FassionSettingVue,
    FassionRules,
  },
  data() {
    return {
      currentActive: 0,
      form: {
        scopeType: 0,
        fassionType: 2,
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
              weUserIds: [],
            },
            executeDeptCondit: {
              change: false,
              deptIds: [],
              posts: [],
            },
          },
          addGroupCode: {
            autoCreateRoom: 0,
            roomBaseName: '',
            roomBaseId: null,
            chatIdList: '',
            groupNames: '',
          },
        },
        content: '',
        exchangeTip: null,
        exchangeType: 3,
        exchangeContent: {
          redemptionLink: '',
          redemptionRule: '',
          weUserId: '',
          userName: '',
        },
        activeTitle: '',
        activeDescr: '',
        activeCoverType: 1,
        activeCoverUrl: '',
      },
    }
  },
  methods: {
    getData(data) {
      this.form = data
    },
    getNext(data) {
      this.currentActive = data
    },
  },
  created() {
    if (this.$route.query.id) {
      getFassionDetail(this.$route.query.id).then((res) => {
        this.form = res.data
      })
    }
  },
}
</script>

<style lang="scss" scoped></style>
