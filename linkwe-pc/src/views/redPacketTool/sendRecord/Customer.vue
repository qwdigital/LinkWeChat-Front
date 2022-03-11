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

    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>管理员在创建群 SOP 规则后，员工通过推送的消息通知，在规定时间内给规定群聊发送规定内容。</div>
      `
    )
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
    <div class="top-search">
      <el-form inline label-position="right" :model="query" label-width="" ref="queryForm">
        <el-form-item label="发放员工" prop="userId">
          <div class="tag-input" @click="dialogVisibleSelectUser = true">
            <span class="tag-place" v-if="!queryUser.length">请选择</span>
            <template v-else>
              <el-tag v-for="(unit, unique) in queryUser" :key="unique">{{ unit.name }}</el-tag>
            </template>
          </div>
        </el-form-item>
        <el-form-item label="领取客户" prop="customerName">
          <el-input v-model="query.customerName" placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item label="发放时间">
          <el-date-picker
            v-model="dateRange"
            value-format="yyyy-MM-dd"
            type="daterange"
            :picker-options="pickerOptions"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            align="right"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="全部类型" prop="sendState">
          <el-select v-model="query.sendState" placeholder="请选择">
            <el-option
              v-for="(item, key) in dictStatusType"
              :key="key"
              :label="item"
              :value="key"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label=" ">
          <el-button
            v-hasPermi="['customerManage:customer:query']"
            type="primary"
            @click="getList(1)"
            >查询</el-button
          >
          <el-button
            v-hasPermi="['customerManage:customer:query']"
            type="success"
            @click="resetQuery()"
            >重置</el-button
          >
        </el-form-item>
      </el-form>
    </div>
    <div>
      <el-button v-hasPermi="['customerManage:customer:query']" type="primary" @click="exportData()"
        >导出Excel</el-button
      >
    </div>
    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="50" align="center"></el-table-column> -->
      <el-table-column
        label="发放员工"
        align="center"
        prop="userName"
        :show-overflow-tooltip="true"
      ></el-table-column>
      <el-table-column label="领取客户" align="center" width="150">
        <template slot-scope="{ row }">
          <div class="cp flex aic" @click="goRoute(row)">
            <el-image
              style="width: 50px; height: 50px; flex: none"
              :src="row.avatar"
              fit="fit"
            ></el-image>
            <div class="ml10">
              <p>{{ row.customerName }}</p>
              <i :class="['el-icon-s-custom', { 1: 'man', 2: 'woman' }[row.gender]]"></i>
              <span :style="{ color: row.customerType == 1 ? '#4bde03' : '#f9a90b' }">
                {{ { 1: '@微信', 2: '@企业微信' }[row.customerType] }}
              </span>
            </div>
          </div>
        </template>
      </el-table-column>

      <el-table-column label="红包金额（元）" align="center" prop="redEnvelopeMoney">
      </el-table-column>
      <el-table-column label="发放时间" align="center" prop="createTime"></el-table-column>
      <el-table-column label="发放状态" align="center" prop="sendState">
        <template slot-scope="{ row }">
          {{ dictStatusType[row.sendState] }}
        </template>
      </el-table-column>
      <el-table-column label="交易订单号" align="center" prop="orderNo"></el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()"
    />

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      :visible.sync="dialogVisibleSelectUser"
      title="选择添加人"
      :defaultValues="queryUser"
      @success="
        (list) => {
          queryUser = list
          query.userId = list.map((i) => i.userId).join()
        }
      "
    ></SelectUser>
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
