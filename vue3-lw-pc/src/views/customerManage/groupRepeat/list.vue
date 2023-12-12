<script>
import { getList, setBlackList, remindDuplicateMembers } from './api'

export default {
  components: {},
  props: {},
  data() {
    return {
      getList,
      // lastSyncTime: '',
    }
  },
  watch: {},
  created() {
    this.$store.setBusininessDesc(`  <div>筛选出重复的群客户，支持一键拉黑，或提醒成员进行移除，保证群运营质量</div>`)
  },
  methods: {
    // 群去重提醒
    remind(selectedIds, type) {
      this.$confirm(
        type ? '是否确定提醒员工对当前客户进行客群去重？' : '是否确定提醒员工对当前选中全部客户进行客群去重',
      )
        .then(() => {
          this.$refs.rct.loading = true
          return remindDuplicateMembers(selectedIds + '')
        })
        .then((res) => {
          this.msgSuccess('操作成功')
          this.$refs.rct.getList()
        })
        .finally(() => {
          this.$refs.rct.loading = false
        })
    },
    // 设置客户黑名单
    setBlackList(row) {
      this.$confirm(
        row.isJoinBlacklist == 1
          ? '是否确定拉黑？拉黑后客户无法收到群发信息'
          : '是否确定取消拉黑？取消后客户可以收到后续群发信息',
      )
        .then(() => {
          this.$refs.rct.loading = true
          return setBlackList({
            isJoinBlacklist: row.isJoinBlacklist == 1 ? 0 : 1,
            externalUserids: row.externalUserid,
          })
        })
        .then((res) => {
          this.msgSuccess('操作成功')
          this.$refs.rct.getList()
        })
        .finally(() => {
          this.$refs.rct.loading = false
        })
    },
    // dealDataFun(res, result) {
    //   this.lastSyncTime = result.lastSyncTime
    // },
  },
}
</script>

<template>
  <RequestChartTable ref="rct" :request="getList" dataKey="externalUserid">
    <template #query="{ query }">
      <el-form-item label="客户名称" prop="memberName">
        <el-input clearable v-model="query.memberName" placeholder="请输入"></el-input>
      </el-form-item>
    </template>

    <template #operation="{ selectedIds }">
      <div class="fxbw">
        <!-- <div>
          <ButtonSync :lastSyncTime="lastSyncTime" @click="sync">同步</ButtonSync>
          <span class="ml10 desc">最近同步：{{ lastSyncTime }}</span>
        </div> -->
        <el-button :disabled="!selectedIds.length" @click="remind(selectedIds)" type="primary">批量提醒</el-button>
      </div>
    </template>

    <template #table>
      <el-table-column label="客户名称" align="center" prop="customerName" show-overflow-tooltip></el-table-column>
      <el-table-column label="添加员工" align="center">
        <template #default="{ row }">
          <TagEllipsis :list="row.addWeUserNames" emptyText limit="3"></TagEllipsis>
        </template>
      </el-table-column>
      <el-table-column label="重复客群" align="center">
        <template #default="{ row }">
          <TagEllipsis :list="row.joinGroupNames" emptyText limit="3"></TagEllipsis>
        </template>
      </el-table-column>
      <!-- <el-table-column prop="createBy" label="创建人" align="center"></el-table-column> -->
      <el-table-column label="最近更新" align="center" prop="updateTime" width="160"></el-table-column>

      <el-table-column label="操作" align="center" fixed="right">
        <template #default="{ row }">
          <el-button
            text
            @click="
              $router.push({
                name: lwConfig.CUSTOMER_DETAIL_ROUTE_NAME,
                query: { externalUserid: row.externalUserid, userId: row.addUserId },
              })
            ">
            客户详情
          </el-button>
          <el-button text @click="remind(row.externalUserid, 1)">提醒员工</el-button>
          <el-button text @click="setBlackList(row)">
            {{ row.isJoinBlacklist == 1 ? '拉黑' : '取消拉黑' }}
          </el-button>
        </template>
      </el-table-column>
    </template>
  </RequestChartTable>
</template>

<style scoped lang="scss"></style>
