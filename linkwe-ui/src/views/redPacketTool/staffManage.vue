<template>
  <div>
    <div class="g-card" style="padding: 20px">
      <el-form :inline="true" :form="query" label-width="70px">
        <el-form-item label="选择员工">
          <div class="tag-input" @click="selectUser(1)">
            <span class="tag-place" v-if="!queryUser.length">请选择员工</span>
            <template v-else>
              <el-tag type="info" v-for="(unit, unique) in queryUser" :key="unique">{{
                unit.name
              }}</el-tag>
            </template>
          </div>
        </el-form-item>
        <el-form-item label-width="0">
          <el-button type="primary" @click="getList(1)">查询</el-button>
          <el-button type="info" plain @click="resetQuery">清空</el-button>
        </el-form-item>
      </el-form>
      <el-button type="primary" @click="edit()">新建员工限额 </el-button>
      <el-button
        type="primary"
        plain
        size="mini"
        @click="
          batchUpdate = true
          edit()
        "
        >批量编辑</el-button
      >
    </div>

    <div class="g-card g-pad20">
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="userName" label="员工姓名" align="center" />
        <el-table-column prop="singleCustomerReceiveNum" label="限额总笔数/总金额" align="center">
          <template slot-scope="{ row }">
            {{ row.singleCustomerReceiveNum }}/{{ row.singleCustomerReceiveMoney || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="今日已发放金额/剩余金额" align="center">
          <template slot-scope="{ row }">
            {{ row.todayIssuedAmount }}/{{ row.todayIssuedAmount - row.singleCustomerReceiveMoney }}
          </template>
        </el-table-column>
        <el-table-column label="今日已发放次数/剩余次数" align="center">
          <template slot-scope="{ row }">
            {{ row.todayIssuedNum }}/{{ row.todayIssuedNum - row.singleCustomerReceiveNum }}
          </template>
        </el-table-column>
        <el-table-column label="累计已发放次数/金额" align="center" width="180">
          <template slot-scope="{ row }">
            {{ row.totalIssuedNum }}/{{ row.totalIssuedAmount }}
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="{ row }">
            <el-button type="text" @click="edit(row)">编辑</el-button>
            <el-button type="text" @click="remove(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="bottom">
        <div style="align-self: flex-end">
          <el-button type="primary" plain size="mini" @click="remove(null)">批量删除</el-button>
        </div>
        <pagination
          :total="total"
          :page.sync="query.pageNum"
          :limit.sync="query.pageSize"
          @pagination="getList()"
        />
      </div>
    </div>

    <el-dialog
      :title="(addMemberForm.id ? '编辑' : '新建') + '员工限额'"
      :visible.sync="addVisible"
      width="40%"
      destroy-on-close
    >
      <el-form
        ref="addMemberForm"
        :model="addMemberForm"
        :rules="addRules"
        position="right"
        label-width="180px"
      >
        <el-form-item v-if="batchUpdate" label="选择员工" prop="staff">
          <el-tag v-for="item in addMemberForm.users" :key="item.userId">{{
            item.userName
          }}</el-tag>
          <el-button type="primary" size="mini" plain @click="selectUser(2)">选择员工</el-button>
          <div class="sub-des">支持多选</div>
        </el-form-item>
        <el-form-item label="单日员工发红包次数" prop="singleCustomerReceiveNum">
          <el-input
            v-model="addMemberForm.singleCustomerReceiveNum"
            placeholder="请输入次数"
          ></el-input>
          <div class="sub-des">输入 1-999999 的正整数</div>
        </el-form-item>
        <el-form-item label="单日员工发红包总数(元)" prop="singleCustomerReceiveMoney">
          <el-input
            v-model="addMemberForm.singleCustomerReceiveMoney"
            placeholder="请输入金额"
          ></el-input>
          <div class="sub-des">精确到小数点后两位，可输入0.30-5000.00</div>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addVisible = false">取 消</el-button>
        <el-button type="primary" @click="addOrUpdate">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      :visible.sync="dialogVisibleSelectUser"
      title="选择使用员工"
      :isOnlyLeaf="true"
      :isSigleSelect="selectUserData.isSigleSelect"
      :defaultValues="selectUserData.type == 1 ? queryUser : addMemberForm.users"
      destroyOnClose
      @success="submitSelectUser"
    ></SelectUser>
  </div>
</template>

<script>
import { getList, addOrUpdate, remove } from '@/api/redPacketTool/staffManage'
export default {
  name: 'member',
  data() {
    return {
      addVisible: false,
      loading: false,
      list: [],
      total: 0,
      query: {
        pageNum: 1,
        pageSize: 10,
        userId: ''
      },
      queryUser: [],
      addMemberForm: {
        users: [],
        singleCustomerReceiveNum: '',
        singleCustomerReceiveMoney: ''
      },
      addRules: {
        staff: [{ validator: this.validateStaff, trigger: 'blur' }],
        singleCustomerReceiveNum: [
          { required: true, message: '必填项', trigger: 'blur' },
          { validator: this.validateDaySendNum, trigger: 'blur' }
        ],
        singleCustomerReceiveMoney: [
          { required: true, message: '必填项', trigger: 'blur' },
          { validator: this.validateDaySendSum, trigger: 'blur' }
        ]
      },
      dialogVisibleSelectUser: false,
      selectedIds: [],
      selectUserData: {
        isSigleSelect: false,
        type: ''
      },
      batchUpdate: false
    }
  },
  watch: {
    addVisible(val) {
      if (!val) {
        // 清空
        this.addMemberForm.users = []
        this.addMemberForm.singleCustomerReceiveNum = ''
        this.addMemberForm.singleCustomerReceiveMoney = ''
        this.$refs.addMemberForm.clearValidate()
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getList(this.query)
        .then((res) => {
          if (res.code == 200) {
            this.list = res.rows
            this.total = +res.total
          }
        })
        .finally(() => (this.loading = false))
    },
    resetQuery() {
      this.queryUser = []
      this.query.pageNum = 1
      this.query.userId = ''
    },
    edit(row) {
      this.addMemberForm = Object.assign({}, row || {})
      this.addVisible = true
    },
    handleSelectionChange(val) {
      this.selectedIds = val.map((i) => i.id)
    },
    selectUser(type) {
      this.selectUserData.type = type
      this.selectUserData.isSigleSelect = type == 1
      this.dialogVisibleSelectUser = true
    },
    submitSelectUser(data) {
      if (this.selectUserData.type == 1) {
        this.queryUser = data
        this.query.userId = data[0].userId
      } else {
        this.addMemberForm.users = data.map((i) => ({
          userId: i.userId,
          userName: i.name
        }))
        this.$refs.addMemberForm.clearValidate('staff')
      }
    },
    validateDaySendNum(rule, value, callback) {
      value = Number(value)
      if (Number.isNaN(value) || value < 1 || value > 999999) {
        callback('请输入 1-999999 的正整数')
      } else {
        callback()
      }
    },
    validateDaySendSum(rule, value, callback) {
      value = Number(value)
      if (Number.isNaN(value) || value < 0.3 || value > 5000) {
        callback('请输入0.30-5000.00的数字')
      } else {
        callback()
      }
    },

    validateStaff(rule, value, callback) {
      if (this.addMemberForm.users.length == 0) {
        callback('请选择员工')
      } else {
        callback()
      }
    },
    addOrUpdate() {
      this.$refs.addMemberForm.validate((validate) => {
        if (!validate) return
        if (this.batchUpdate) {
          this.addMemberForm.ids = this.selectedIds + ''
        } else {
          this.addMemberForm.userId = this.addMemberForm.users.map((e) => e.userId) + ''
        }
        ;(this.batchUpdate ? batchUpdate : addOrUpdate)(this.addMemberForm).then((res) => {
          this.getList()
          this.addVisible = false
          this.msgSuccess('操作成功')
        })
      })
    },
    remove(id) {
      this.$confirm('是否确认删除吗?', '警告', {
        type: 'warning'
      }).then(() => {
        id = id || this.selectedIds.join(',')
        remove(id).then((res) => {
          this.getList()
          this.msgSuccess('删除成功')
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.sub-des {
  font-size: 12px;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #999999;
}
</style>
