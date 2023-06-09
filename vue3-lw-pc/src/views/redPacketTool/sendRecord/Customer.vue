<script>
import { getList, exportCustomer } from '@/api/redPacketTool/sendRecord'

export default {
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        userId: '', // 员工id
        customerName: '', // 客户姓名
        sendState: '', // 发送状态:1:待领取;2:已领取;3:发放失败;4:退款中;5:已退款
        beginTime: '', // 创建开始时间
        endTime: '', // 创建结束时间
      },
      dateRange: [], // 添加日期
      total: 0, //
      list: [], //
      multiSelect: [], // 多选数据
      loading: false,
      queryUser: [], // 搜索框选择的添加人
      dialogVisibleSelectUser: false, // 选择添加人弹窗显隐
      dictStatusType: Object.freeze({
        0: '全部类型',
        1: '待领取',
        2: '已领取',
        3: '发放失败',
        5: '已退款',
      }),
    }
  },
  watch: {},
  created() {
    this.getList()
  },
  methods: {
    getList(page) {
      if (this.dateRange) {
        ;[this.query.beginTime, this.query.endTime] = this.dateRange
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
      page && (this.query.pageNum = page)
      this.loading = true

      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 重置查询参数
    resetQuery() {
      this.dateRange = []
      this.queryUser = []
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    exportData() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.loading = true
          return exportCustomer(this.query)
        })
        .then((res) => {
          this.download(res.msg)
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.loading = false
        })
    },
    // 处理多选
    handleSelectionChange(val) {
      this.multiSelect = val
    },
    // 获取显示用实际群聊
    getDisplayGroups(row) {
      if (row.groupList) {
        const groups = row.groupList.map((g) => g.groupName)
        return groups.join('，')
      }
    },
  },
}
</script>

<template>
  <div>
    <el-form inline label-position="right" :model="query" label-width="" ref="queryForm" class="top-search">
      <el-form-item label="发放员工" prop="userId">
        <div class="tag-input" @click="dialogVisibleSelectUser = true">
          <span class="tag-place" v-if="!queryUser.length">请选择</span>
          <template v-else>
            <el-tag v-for="(unit, unique) in queryUser" :key="unique">{{ unit.name }}</el-tag>
          </template>
        </div>
      </el-form-item>
      <el-form-item label="领取客户" prop="customerName">
        <el-input clearable v-model="query.customerName" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="发放时间">
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
      </el-form-item>
      <el-form-item label="全部类型" prop="sendState">
        <el-select clearable v-model="query.sendState" placeholder="请选择">
          <el-option v-for="(item, key) in dictStatusType" :key="key" :label="item" :value="key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <!-- v-hasPermi="['customerManage:customer:query']" -->

        <el-button type="primary" @click="getList(1)">查询</el-button>
        <!-- v-hasPermi="['customerManage:customer:query']" -->

        <el-button @click="resetQuery()">重置</el-button>
      </el-form-item>
      <el-form-item style="float: right">
        <!-- v-hasPermi="['customerManage:customer:query']" -->
        <el-button type="primary" @click="exportData()">导出Excel</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <!-- <el-table-column type="selection" width="50" align="center"></el-table-column> -->
        <el-table-column
          label="发放员工"
          align="center"
          prop="userName"
          :show-overflow-tooltip="true"></el-table-column>
        <el-table-column label="领取客户" align="center" width="150">
          <template #default="{ row }">
            <div class="cp flex aic" @click="goRoute(row)">
              <el-image style="width: 50px; height: 50px; flex: none" :src="row.avatar" fit="fill"></el-image>
              <div class="ml10">
                <p>{{ row.customerName }}</p>
                <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[row.gender]]" />
                <span :style="{ color: row.customerType == 1 ? '#4bde03' : '#f9a90b' }">
                  {{ { 1: '@微信', 2: '@企业微信' }[row.customerType] }}
                </span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="红包金额（元）" align="center" prop="redEnvelopeMoney"></el-table-column>
        <el-table-column label="发放时间" align="center" prop="createTime"></el-table-column>
        <el-table-column label="发放状态" align="center" prop="sendState">
          <template #default="{ row }">
            {{ dictStatusType[row.sendState] }}
          </template>
        </el-table-column>
        <el-table-column label="交易订单号" align="center" prop="orderNo"></el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()" />
    </div>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择添加人"
      :defaultValues="queryUser"
      @success="
        (list) => {
          queryUser = list
          query.userId = list.map((i) => i.userId).join()
        }
      "></SelectUser>
  </div>
</template>

<style scoped lang="scss">
.overflow-ellipsis {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.table-desc {
  max-width: 120px;
}
</style>
