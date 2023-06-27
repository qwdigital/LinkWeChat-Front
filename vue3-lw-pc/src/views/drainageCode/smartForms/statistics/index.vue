<template>
  <div>
    <div class="overview_header">
      <div class="overView_header_left">
        <div style="display: flex; align-items: center">
          <div>ID： {{ baseList.id }}</div>
          <div class="surveyState">
            <div v-if="baseList.surveyState == 0">未发布</div>
            <div v-if="baseList.surveyState == 1">收集中</div>
            <div v-if="baseList.surveyState == 2">已暂停</div>
            <div v-if="baseList.surveyState == 3">已结束</div>
            <div v-if="baseList.surveyState == 4">未收集</div>
          </div>
        </div>
        <div style="font-size: 16px; font-weight: 700; margin-top: 10px">
          {{ baseList.surveyName }}
        </div>
      </div>
      <div class="overView_header_right">
        <div>
          开始时间：
          <span v-if="baseList.timingStart">{{ baseList.timingStart }}</span>
          <span v-if="!baseList.timingStart">不限</span>
        </div>
        <div style="margin-top: 10px">
          结束时间：
          <span v-if="baseList.timingEnd">{{ baseList.timingEnd }}</span>
          <span v-if="!baseList.timingEnd">不限</span>
        </div>
      </div>
    </div>
    <el-tabs v-model="activeName">
      <el-tab-pane label="统计概览" name="first">
        <Overview v-if="activeName === 'first'" />
      </el-tab-pane>
      <el-tab-pane label="数据统计" name="second">
        <DataStatistics :formId="baseList.id" v-if="activeName === 'second'" />
      </el-tab-pane>
      <el-tab-pane label="用户统计" name="three" show-overflow-tooltip>
        <template #label>
          <span>
            用户统计
            <el-popover width="250" trigger="hover" placement="top-start">
              <p>暂时仅支持微信用户</p>
              <template #reference>
                <el-icon-QuestionFilled class="el-icon-QuestionFilled" style="color: black"></el-icon-QuestionFilled>
              </template>
            </el-popover>
          </span>
        </template>
        <UserStatistics :formId="baseList.id" v-if="activeName === 'three'" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
import { selectInfoToSurvey } from '@/api/drainageCode/smartForms.js'
import Overview from './Overview.vue'
import DataStatistics from './DataStatistics.vue'
import UserStatistics from './UserStatistics.vue'
// import Search from "./search.vue"
export default {
  // name: 'customer-service-statistics',
  components: {
    Overview,
    DataStatistics,
    UserStatistics,
  },
  data() {
    return {
      baseList: {},
      activeName: 'first',
    }
  },
  methods: {
    selectInfoToSurvey() {
      selectInfoToSurvey(this.$route.query.id).then((res) => {
        this.baseList = res.data || {}
      })
    },
  },
  created() {
    this.selectInfoToSurvey()
    //   this.$store.setBusininessDesc(
    //
    //     `
    //   <div>渠道场景与客服维度相关数据统计与分析</div>
    // `
    //   )
  },
}
</script>
<style lang="scss" scoped>
.overview_header {
  margin-bottom: 10px;
  display: flex;
  justify-content: space-between;
  width: 100%;
  border-radius: 5px;
  background: var(--bg-white);
  padding: 20px;
  box-sizing: border-box;
}
.surveyState {
  margin-left: 30px;
  padding: 5px 10px;
  border-radius: 5px;
  background-color: var(--bg-black-10);
}
</style>
