<script>
import { getList, remove, getStat } from './api'

export default {
  components: {},
  props: {},
  data() {
    return {
      getList,
      // 可用的发送方式数据
      // sendTypeOptions: [
      //   { label: '企业群发', value: 0 },
      //   { label: '个人群发', value: 1 }
      // ],
      dateRange: [], // 创建日期[开始时间, 结束时间]
      ids: [], // 多选数据
      customerSearchId: '', // 客户统计所查询的任务ID
      // 客户统计查询参数
      customerQuery: {
        pageNum: 1,
        pageSize: 10,
        customerName: '', // 客户名称
        isInGroup: '', // 是否在群
        isSent: '', // 是否送达
      },
      customerTotal: 0, // 客户统计总数据量
      customerLoading: false, // 客户统计table加载状态
      customerList: [], // 客户统计数据
      customerShowList: [], // 展示用客户统计数据
      // 是否在群选择项
      inGroupOptions: [
        { label: '在群', value: 1 },
        { label: '不在群', value: 0 },
      ],
      // 是否送达选择项
      sendStatusOptions: [
        { label: '已送达', value: 1 },
        { label: '未送达', value: 0 },
      ],
      // dialogVisible: false, // 客户统计会话
    }
  },
  watch: {
    // 日期选择器数据同步至查询参数
    // dateRange: {
    //   deep: true,
    //   handler(val) {
    //     if (!val || val.length !== 2) {
    //       this.query.beginTime = ''
    //       this.query.endTime = ''
    //     } else {
    //       ;[this.query.beginTime, this.query.endTime] = val
    //     }
    //   },
    // },
    // dialogVisible(val) {
    //   if (!val) this.$refs['customerForm'].resetFields()
    //   this.customerList = []
    //   this.customerTotal = 0
    // },
  },
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

    // // 获取客户统计数据
    // getStat(page) {
    //   page && (this.customerQuery.pageNum = page)
    //   this.customerLoading = true

    //   getStat(this.customerSearchId, this.customerQuery)
    //     .then(({ rows, total }) => {
    //       this.customerList = rows
    //       this.customerTotal = +total
    //       this.customerLoading = false
    //     })
    //     .catch(() => {
    //       this.customerLoading = false
    //     })
    // },
    // // 打开客户统计会话
    // openCustomerDialog(id) {
    //   this.customerSearchId = id
    //   this.dialogVisible = true

    //   this.getStat(1)
    // },
    // // 过滤客户统计数据
    // customerFilter() {
    //   const l = []
    //   for (let data of this.customerList) {
    //     if (this.customerQuery.customerName !== '' && !this.customerQuery.customerName.includes(data.customerName))
    //       continue
    //     if (this.customerQuery.isInGroup !== '' && this.customerQuery.isInGroup !== data.isInGroup) continue
    //     if (this.customerQuery.isSent !== '' && this.customerQuery.isSent !== data.isSent) continue

    //     l.push(data)
    //   }

    //   this.customerShowList = l.slice(
    //     this.customerQuery.pageNum * this.customerQuery.pageSize,
    //     this.customerQuery.pageSize,
    //   )
    // },
    // // 客户统计查询
    // customerSearch() {
    //   this.getStat()
    //   // this.customerFilter()
    // },
    // // 客户统计重置
    // resetCustomerQuery() {
    //   this.$refs['customerForm'].resetFields()

    //   this.getStat(1)
    //   // this.customerFilter()
    // },
  },
}
</script>

<template>
  <div>
    <RequestChartTable ref="table" :request="(params) => (Object.assign(params, query), getList(params))">
      <template #query="{ query }">
        <el-form-item label="任务名称" prop="taskName">
          <el-input clearable v-model="query.taskName" placeholder="请输入"></el-input>
        </el-form-item>
        <!-- <el-form-item label="发送方式" prop="sendType">
          <el-select v-model="query.sendType" placeholder="请选择" >
            <el-option
              v-for="(sendType, index) in sendTypeOptions"
              :label="sendType.label"
              :value="sendType.value"
              :key="index"
            ></el-option>
          </el-select>
        </el-form-item> -->
        <!-- <el-form-item label="创建人" prop="createBy">
        <el-input clearable v-model="query.createBy" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          clearable
          v-model="dateRange"
          value-format="YYYY-MM-DD"
          type="daterange"
          v-bind="pickerOptions"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"></el-date-picker>
      </el-form-item> -->
      </template>

      <template #operation>
        <div class="fxbw">
          <el-button type="primary" @click="goRoute()">新建任务</el-button>
          <el-button :disabled="!ids.length" @click="remove" type="danger">批量删除</el-button>
        </div>
      </template>

      <template #="{ data }">
        <el-table :data="data" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="50" align="center"></el-table-column>
          <el-table-column label="任务名称" align="center" prop="taskName" show-overflow-tooltip></el-table-column>
          <!-- <el-table-column prop="sendType" label="发送方式" align="center">
        <template #default="{ row }">
          {{ parseInt(row.sendType) === 0 ? '企业群发' : '个人群发' }}
        </template>
      </el-table-column> -->
          <!-- <el-table-column label="当前群人数" align="center" width="100">
            <template #default="{ row }">
              <el-button text @click="openCustomerDialog(row.id)">
                {{ row.totalMember }}
              </el-button>
            </template>
          </el-table-column> -->
          <el-table-column label="实际群聊" align="center">
            <template #default="{ row }">
              <TagEllipsis :list="row.groupNames"></TagEllipsis>
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
              <el-button text @click="handleRemove(row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>
    </RequestChartTable>

    <!-- <el-dialog title="客户统计" v-model="dialogVisible" :close-on-click-modal="false">
      <div>
        <el-form
          inline
          label-position="right"
          :model="customerQuery"
          label-width="80px"
          ref="customerForm"
          class="top-search">
          <el-form-item prop="customerName">
            <el-input v-model="customerQuery.customerName" placeholder="请输入客户名称"></el-input>
          </el-form-item>
          <el-form-item prop="isInGroup">
            <el-select v-model="customerQuery.isInGroup" placeholder="全部">
              <el-option
                v-for="(inGroup, index) in inGroupOptions"
                :label="inGroup.label"
                :value="inGroup.value"
                :key="index"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item prop="isSent">
            <el-select v-model="customerQuery.isSent" placeholder="全部状态">
              <el-option
                v-for="(status, index) in sendStatusOptions"
                :label="status.label"
                :value="status.value"
                :key="index"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label>
            <el-button type="primary" @click="customerSearch">查询</el-button>
            <el-button @click="resetCustomerQuery">重置</el-button>
          </el-form-item>
        </el-form>
        <el-table v-loading="customerLoading" :data="customerList">
          <el-table-column label="客户名" align="center" prop="customerName"></el-table-column>
          <el-table-column prop="sent" label="送达状态" align="center">
            <template #default="{ row }">
              <template v-if="row.sent">已送达</template>
              <template v-else>未送达</template>
            </template>
          </el-table-column>
          <el-table-column prop="inGroup" label="是否在群" align="center">
            <template #default="{ row }">
              <template v-if="row.inGroup">在群</template>
              <template v-else>不在群</template>
            </template>
          </el-table-column>
        </el-table>

        <pagination
          v-show="customerTotal > 0"
          :total="customerTotal"
          v-model:page="customerQuery.pageNum"
          v-model:limit="customerQuery.pageSize"
          @pagination="customerSearch" />
      </div>
    </el-dialog> -->
  </div>
</template>

<style scoped lang="scss">
// .overflow-ellipsis {
//   white-space: nowrap;
//   overflow: hidden;
//   text-overflow: ellipsis;
// }

// .table-desc {
//   max-width: 120px;
// }
</style>
