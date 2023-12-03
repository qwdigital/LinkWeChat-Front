<template>
  <div>
    <div class="g-card g-margin-b">
      <el-steps :active="active" align-center finish-status="success">
        <el-step title="活码设置"></el-step>
        <el-step title="生成活码"></el-step>
      </el-steps>
    </div>
    <div v-if="active === 0">
      <BaseInfo ref="baseInfo" :groupCodeId="groupCodeId" @next="next"></BaseInfo>
    </div>
    <div class="g-card" v-if="active === 1">
      <GroupCode :groupCodeId="groupCodeId" :data="baseInfo"></GroupCode>
    </div>
    <div class="g-footer-sticky">
      <template v-if="active === 0">
        <el-button @click="$router.back()">取消</el-button>
        <el-button type="primary" v-loading="loading" :disabled="loading" @click="handleGroupCode">下一步</el-button>
      </template>
      <template v-else>
        <!-- <el-button @click="prev"> 上一步 </el-button> -->
        <el-button type="primary" @click="finished">完成</el-button>
      </template>
    </div>
  </div>
</template>

<script>
import BaseInfo from './baseInfo'
import GroupCode from './groupCode'

export default {
  components: {
    BaseInfo,
    GroupCode,
  },
  data() {
    return {
      loading: false,
      // 当前群活码ID
      groupCodeId: null,
      // 当前激活的步骤
      active: 0,
      baseInfo: {},
    }
  },
  created() {
    if (this.$route.query.groupCodeId) this.groupCodeId = this.$route.query.groupCodeId
  },
  methods: {
    // 下一步
    next(groupCodeId, info) {
      this.loading = false
      if (groupCodeId || info) {
        if (groupCodeId) this.groupCodeId = groupCodeId
        this.baseInfo = info
        this.active += 1
        if (this.active > 3) this.active = 1
      }
    },
    // 上一步
    prev() {
      this.active -= 1
      if (this.active < 0) this.active = 0
    },
    // 完成
    finished() {
      this.next()
      this.$router.back()
    },
    // 新增或更新群活码
    handleGroupCode() {
      this.$refs.baseInfo.handleValidateFn().then(() => {
        this.loading = true
        this.$refs.baseInfo.submit()
      })
    },
    // 管理实际群活码
    handleRealCode() {
      this.next()
    },
  },
}
</script>

<style scoped lang="scss">
.page-content {
  padding-top: 50px;
  padding-bottom: 20px;
}
</style>
