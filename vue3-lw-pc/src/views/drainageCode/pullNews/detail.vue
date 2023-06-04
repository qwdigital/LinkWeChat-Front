<template>
  <div>
    <!-- 详情页面 -->
    <el-tabs v-model="activeName">
      <el-tab-pane label="活码信息" name="first"
        ><LiveCodeInfo :form="form" v-if="activeName === 'first'"
      /></el-tab-pane>
      <el-tab-pane label="活码统计" name="second"
        ><LiveCodeStatic :form="form" v-if="activeName === 'second'"
      /></el-tab-pane>
      <el-tab-pane label="领取统计" name="third"
        ><CollectionStatistics :form="form" v-if="activeName === 'third'"
      /></el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import LiveCodeInfo from './liveCodeInfo'
import LiveCodeStatic from './liveCodeStatic'
import CollectionStatistics from './collectionStatistics'
import { getDetail } from '@/api/drainageCode/pullNews'
export default {
  components: {
    LiveCodeInfo,
    LiveCodeStatic,
    CollectionStatistics,
  },
  data() {
    return {
      activeName: 'first',
      groupId: null,
      form: {},
    }
  },
  mounted() {
    this.groupId = this.$route.query.groupId
    if (this.groupId) {
      this.getDetail(this.groupId)
    }
  },
  methods: {
    getDetail(id) {
      getDetail(id).then((res) => {
        this.form = res.data
      })
    },
  },
}
</script>

<style></style>
