<script>
  import * as api from '@/api/customer/dimission'

  export default {
    name: 'Dimission',
    components: {},
    props: {},
    data() {
      return {
        // 查询参数
        query: {
          isAllocate: 0,
          pageNum: 1,
          pageSize: 10,
          userName: undefined,
          beginTime: undefined,
          endTime: undefined
        },
        loading: false,
        isMoreFilter: false,
        total: 0,
        form: {
          user: '',
          region: ''
        },
        list: [],
        currentRow: {},
        dialogVisibleSelectUser: false,
        dateRange: [], // 离职日期
        lastSyncTime: ''
      }
    },
    watch: {},
    computed: {},
    created() {
      this.getList()
      this.$store.setBusininessDesc(
        `
          <div>将离职成员的客户和客户群分配给其他成员跟进并继续提供服务。</div>
        `
      )
    },
    mounted() {},
    methods: {
      /** 查询 */
      getList(page) {
        if (this.dateRange) {
          this.query.beginTime = this.dateRange[0]
          this.query.endTime = this.dateRange[1]
        } else {
          this.query.beginTime = ''
          this.query.endTime = ''
        }
        page && (this.query.pageNum = page)
        this.loading = true
        api
          .getListTable(this.query)
          .then(({ rows, total, lastSyncTime }) => {
            this.list = rows
            this.total = +total
            this.loading = false
            this.lastSyncTime = lastSyncTime
          })
          .catch(() => {
            this.loading = false
          })
      },
      resetForm(formName) {
        this.dateRange = []
        this.$refs['queryForm'].resetFields()
      },
      showSelectDialog() {
        if (this.currentRow.weUserId) {
          this.dialogVisibleSelectUser = true
        } else {
          this.$message.warning('请先选择一位员工')
        }
      },
      allocate(userlist) {
        console.log(userlist)
        if (userlist.length > 1) {
          this.dialogVisibleSelectUser = true
          return
        }
        let loading = this.$loading()
        api
          .allocate({
            handoverUserid: this.currentRow.weUserId,
            takeoverUserid: userlist[0].userId
          })
          .then(() => {
            this.msgSuccess('操作成功')
            this.getList()
            loading.close()
          })
          .catch(() => {
            loading.close()
          })
      },
      // // 选中数据
      handleCurrentChange(val) {
        this.currentRow = val
      },
      // 多选框选中数据
      handleSelectionChange(selection) {
        this.currentRow = selection[0]
      },
      // 用于多选变单选
      handleSelection(selection, row) {
        this.$nextTick(() => {
          this.$refs.table.clearSelection()
          this.$refs.table.toggleRowSelection(row)
        })
      },
      sync() {
        api
          .sync()
          .then(() => {
            // loading.close()
            this.getList(1)
            this.msgSuccess('后台开始同步数据，请稍后关注进度')
          })
          .catch((fail) => {
            // loading.close()
            console.log(fail)
          })
      }
    }
  }
</script>

<template>
  <div class="page">
    <el-form ref="queryForm" :inline="true" :model="query" label-width="" class="top-search">
      <el-form-item label="已离职员工" prop="userName">
        <el-input clearable v-model="query.userName" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="离职日期">
        <el-date-picker
          clearable
          v-model="dateRange"
          type="daterange"
          value-format="YYYY-MM-DD"
          v-bind="pickerOptions"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"
        ></el-date-picker>
      </el-form-item>

      <el-form-item label>
        <!-- v-hasPermi="['customerManage:dimission:query']" -->
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetForm('queryForm')">重置</el-button>
        <!-- v-hasPermi="['customerManage:dimission:query']" -->
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <!-- v-hasPermi="['customerManage:dimission:filter']" -->
        <el-button type="primary" @click="$router.push({ path: 'allocatedStaffList' })">已分配的离职员工</el-button>
        <div>
          <span class="desc">最近同步：{{ lastSyncTime }}</span>
          <ButtonSync :lastSyncTime="lastSyncTime" @click="sync">同步</ButtonSync>
          <el-button style="margin-left: 10px;" type="primary" @click="showSelectDialog">分配给其他员工</el-button>
        </div>
        <!-- v-hasPermi="['customerManage:dimission:allocate']" -->
      </div>

      <el-table
        v-loading="loading"
        ref="multipleTable"
        :data="list"
        tooltip-effect="dark"
        style="width: 100%;"
        highlight-current-row
        @select="handleSelection"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" align="center" width="55"></el-table-column>
        <el-table-column type="index" label="序号" width="55"></el-table-column>
        <el-table-column prop="userName" label="已离职员工"></el-table-column>
        <el-table-column prop="deptNames" label="所属部门"></el-table-column>
        <el-table-column prop="allocateCustomerNum" label="待分配客户数" show-overflow-tooltip></el-table-column>
        <el-table-column prop="allocateGroupNum" label="待分配群聊数" show-overflow-tooltip></el-table-column>
        <el-table-column prop="dimissionTime" label="离职时间" show-overflow-tooltip>
          <template #default="scope">{{ scope.row.dimissionTime }}</template>
        </el-table-column>
        <!-- <el-table-column label="操作" width="100">
        <template #default="scope">
          <el-button v-hasPermi="['customerManage:dimission:edit']" text >编辑</el-button>
        </template>
      </el-table-column>-->
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()"
      />
    </div>

    <!-- 选择添加人弹窗 -->
    <SelectUser v-model:visible="dialogVisibleSelectUser" title="选择分配人" @success="allocate"></SelectUser>
  </div>
</template>

<style lang="scss" scoped></style>
