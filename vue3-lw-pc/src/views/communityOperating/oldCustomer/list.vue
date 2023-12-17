<script>
import { getList, remove } from './api'

export default {
  components: {},
  props: {},
  data() {
    return {
      getList,
      remove,
      dateRange: [], // 创建日期[开始时间, 结束时间]
    }
  },
  watch: {},
  created() {
    this.$store.setBusininessDesc(
      `  <div>企业通过下发任务通知员工给选中的标签客户主动发送加群引导语以及群活码，客户扫码后入群。</div>`,
    )
  },
  methods: {
    // 新增/编辑老客数据
    goRoute(path = 'aev', query) {
      this.$router.push({ path, query })
    },
  },
}
</script>

<template>
  <RequestChartTable ref="rct" :request="(params) => (Object.assign(params, query), getList(params))">
    <template #query="{ query }">
      <el-form-item label="任务名称" prop="taskName">
        <el-input clearable v-model="query.taskName" placeholder="请输入"></el-input>
      </el-form-item>
    </template>

    <template #operation="{ selectedIds }">
      <div class="fxbw">
        <el-button type="primary" @click="goRoute()">新建任务</el-button>
        <el-button :disabled="!selectedIds.length" @click="$refs.rct.remove(remove)" type="danger">批量删除</el-button>
      </div>
    </template>

    <template #table>
      <el-table-column label="任务名称" align="center" prop="taskName" show-overflow-tooltip></el-table-column>
      <el-table-column label="实际群聊" align="center">
        <template #default="{ row }">
          <TagEllipsis :list="row.groupNames" emptyText></TagEllipsis>
        </template>
      </el-table-column>
      <el-table-column label="送达客户数/进群客户数" align="center" prop="cusNumber" width="">
        <template #header>
          <el-popover placement="top" trigger="hover">
            <template #reference>
              <div>
                添加客户数/进群客户数
                <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
              </div>
            </template>
            <div>送达客户数：建群任务送达的客户总数（去重）；</div>
            <div>进群客户数：送达客户中成功进群的总数（去重）；</div>
          </el-popover>
        </template>
        <template #default="{ row }">
          <div class="g-color cp" @click="goRoute('detail', { id: row.id, index: 1 })">
            {{ row.touchWeCustomerNumber }}/{{ row.joinGroupCustomerNumber }}
          </div>
        </template>
      </el-table-column>

      <!-- <el-table-column prop="createBy" label="创建人" align="center"></el-table-column> -->
      <el-table-column label="最近更新" align="center" prop="updateTime" width="160"></el-table-column>

      <el-table-column label="操作" align="center" width="180">
        <template #default="{ row }">
          <el-button text @click="goRoute('detail', { id: row.id })">详情</el-button>
          <el-button text @click="$refs.rct.remove(remove, row.id)">删除</el-button>
        </template>
      </el-table-column>
    </template>
  </RequestChartTable>
</template>

<style scoped lang="scss"></style>
