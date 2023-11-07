<script>
import { getList, remove } from './api'

export default {
  components: {},
  props: {},
  data() {
    return {
      getList,
      dateRange: [], // 创建日期[开始时间, 结束时间]
      ids: [], // 多选数据
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
    goRoute(path = 'aev', id) {
      this.$router.push({ path, query: { id } })
    },
    // 批量删除
    remove(id) {
      this.$confirm('是否确认删除?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          remove(id || this.ids).then((res) => {
            this.$refs.table.getList()
            this.msgSuccess('删除成功')
          })
        })
        .catch(() => {})
    },
    // 处理多选
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
  },
}
</script>

<template>
  <RequestChartTable ref="table" :request="(params) => (Object.assign(params, query), getList(params))">
    <template #query="{ query }">
      <el-form-item label="任务名称" prop="taskName">
        <el-input clearable v-model="query.taskName" placeholder="请输入"></el-input>
      </el-form-item>
    </template>

    <template #operation>
      <div class="fxbw">
        <el-button type="primary" @click="goRoute()">新建任务</el-button>
        <el-button :disabled="!ids.length" @click="remove()" type="danger">批量删除</el-button>
      </div>
    </template>

    <template #="{ data }">
      <el-table :data="data" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="50" align="center"></el-table-column>
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
            <div class="g-color cp" @click="goRoute('detail', row.id)">
              {{ row.touchWeCustomerNumber }}/{{ row.joinGroupCustomerNumber }}
            </div>
          </template>
        </el-table-column>

        <!-- <el-table-column prop="createBy" label="创建人" align="center"></el-table-column> -->
        <el-table-column label="最近更新" align="center" prop="updateTime" width="160"></el-table-column>

        <el-table-column label="操作" align="center" width="180">
          <template #default="{ row }">
            <el-button text @click="goRoute('detail', row.id)">详情</el-button>
            <el-button text @click="remove(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </template>
  </RequestChartTable>
</template>

<style scoped lang="scss"></style>
