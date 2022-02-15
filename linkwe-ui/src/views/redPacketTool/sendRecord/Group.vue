<script>
import CardGroupIndex from '@/components/CardGroupIndex'
import { getListGroup, getListGroupUser, exportGroup } from '@/api/redPacketTool/sendRecord'

export default {
  components: { CardGroupIndex },
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        userId: '', // 员工id
        groupName: '', // 客户群名
        redEnvelopeType: '', // 1: 普通红包2:拼手气红包
        beginTime: '', // 创建开始时间
        endTime: '', // 创建结束时间
      },
      dateRange: [], // 添加日期
      total: 0, //
      list: [], //
      multiSelect: [], // 多选数据
      loading: false,
      dictStatusType: Object.freeze({
        0: '全部状态',
        1: '普通红包',
        2: '拼手气红包',
      }),

      dialogVisible: false,
      cardData: [],
      dialog: {
        query: {
          pageNum: 1,
          pageSize: 10,
          chatId: '', // 群id
        },
        loading: false,
        total: 0, //
        list: [], //
      },
    }
  },
  watch: {
    // 日期选择器数据同步至查询参数
    dateRange(dateRange) {
      if (!dateRange || dateRange.length !== 2) {
        this.query.beginTime = ''
        this.query.endTime = ''
      } else {
        ;[this.query.beginTime, this.query.endTime] = dateRange
      }
    },
  },
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
      page && (this.query.pageNum = page)
      this.loading = true
      getListGroup(this.query)
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
      this.$refs['queryForm'].resetFields()
      // this.getList(1)
    },
    exportData() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.loading = true
          return exportGroup(this.query)
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
    view(row) {
      let cardData = [
        {
          title: '群主',
          value: row.groupLeaderName,
          noArrow: true,
        },
        {
          title: '领取人数',
          value: row.receiveNum,
          noArrow: true,
        },
        {
          title: '剩余红包个数',
          value: row.surplusNum,
          noArrow: true,
        },
      ]
      this.cardData = cardData
      this.dialogVisible = true
      this.dialog.query.chatId = row.chatId
      this.getListGroupUser(1)
    },
    // 获取领取详情
    getListGroupUser(page) {
      page && (this.dialog.query.pageNum = page)
      this.dialog.loading = true
      getListGroupUser(this.dialog.query)
        .then(({ rows, total }) => {
          this.dialog.list = rows
          this.dialog.total = +total
          this.dialog.loading = false
        })
        .catch(() => {
          this.dialog.loading = false
        })
    },
  },
}
</script>

<template>
  <div>
    <div class="top-search">
      <el-form inline label-position="right" :model="query" label-width="100px" ref="queryForm">
        <el-form-item label="发放员工" prop="userId">
          <el-input v-model="query.userId" placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item label="领取客户群" prop="groupName">
          <el-input v-model="query.groupName" placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item label="全部状态" prop="redEnvelopeType">
          <el-select v-model="query.redEnvelopeType" placeholder="请选择">
            <el-option
              v-for="(item, key) in dictStatusType"
              :key="key"
              :label="item"
              :value="key"
            ></el-option>
          </el-select>
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
        <el-form-item label=" ">
          <el-button
            v-hasPermi="['customerManage:customer:query']"
            type="primary"
            @click="getList(1)"
            >查询</el-button
          >
        </el-form-item>
      </el-form>
    </div>

    <div class="mid-action">
      <div>
        <el-button type="primary" @click="exportData()">导出Excel</el-button>
      </div>
      <div>
        <!-- <el-button
          v-hasPermi="['customerManage:customer:export']"
          :disabled="multiSelect.length === 0"
          @click="handleBulkRemove"
          type="cyan"
          >批量删除</el-button
        > -->
      </div>
    </div>

    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="50" align="center"></el-table-column> -->
      <el-table-column
        label="发放员工"
        align="center"
        prop="userName"
        :show-overflow-tooltip="true"
      ></el-table-column>
      <el-table-column label="领取客户群" align="center" prop="groupName" width="120">
      </el-table-column>

      <el-table-column label="红包类型" align="center" prop="redEnvelopeType">
        <template slot-scope="{ row }">
          <div>{{ dictStatusType[row.redEnvelopeType] }}</div>
        </template>
      </el-table-column>

      <el-table-column label="红包个数" align="center" prop="redEnvelopeNum"></el-table-column>
      <el-table-column
        label="红包金额（元）"
        align="center"
        prop="redEnvelopeMoney"
      ></el-table-column>
      <el-table-column label="发放时间" align="center" prop="createTime"></el-table-column>

      <el-table-column label="领取详情" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            v-hasPermi="['enterpriseWechat:view']"
            size="mini"
            type="text"
            @click="view(scope.row)"
            >领取详情</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()"
    />

    <el-dialog title="领取详情" :visible.sync="dialogVisible" width="width">
      <div>
        <CardGroupIndex :data="cardData"></CardGroupIndex>

        <el-table v-loading="dialog.loading" :data="dialog.list">
          <el-table-column label="领取客户" align="center" width="120" prop="customerName">
          </el-table-column>
          <el-table-column
            label="领取金额（元）"
            align="center"
            prop="redEnvelopeMoney"
          ></el-table-column>
          <el-table-column label="领取时间" align="center" prop="createTime"></el-table-column>
          <el-table-column label="交易订单号" align="center" prop="orderNo"></el-table-column>
        </el-table>

        <pagination
          :total="dialog.total"
          :page.sync="dialog.query.pageNum"
          :limit.sync="dialog.query.pageSize"
          @pagination="getListGroupUser()"
        />
      </div>
      <div slot="footer">
        <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
      </div>
    </el-dialog>
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
