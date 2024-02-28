<template>
  <div>
    <el-form ref="queryForm" :inline="true" :model="query" label-width="70px" class="top-search">
      <el-form-item label="选择员工" prop="userId">
        <div class="tag-input" @click="selectUser(1)">
          <span class="tag-place" v-if="!queryUser.length">请选择员工</span>
          <template v-else>
            <el-tag v-for="(unit, unique) in queryUser" :key="unique">{{ unit.name }}</el-tag>
          </template>
        </div>
      </el-form-item>
      <el-form-item label-width="">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click=";(batchUpdate = false), edit()">新建员工限额</el-button>
        <!-- <el-button
        type="primary"
        plain
        :disabled="!selectedIds.length"
        @click="
          batchUpdate = true
          edit()
        "
        >批量编辑</el-button
      > -->
      </div>

      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="userName" label="员工姓名" align="center" />
        <el-table-column prop="singleCustomerReceiveNum" label="限额总笔数/总金额" align="center">
          <template #default="{ row }">
            {{ row.singleCustomerReceiveNum }}/{{ row.singleCustomerReceiveMoney }}
          </template>
        </el-table-column>
        <el-table-column label="今日已发放金额/剩余金额" align="center">
          <template #default="{ row }">{{ row.todayIssuedAmount }}/{{ row.todayNoIssuedAmount }}</template>
        </el-table-column>
        <el-table-column label="今日已发放次数/剩余次数" align="center">
          <template #default="{ row }">{{ row.todayIssuedNum }}/{{ row.todayNoIssuedNum }}</template>
        </el-table-column>
        <el-table-column label="累计已发放次数/金额" align="center" width="180">
          <template #default="{ row }">{{ row.totalIssuedNum }}/{{ row.totalIssuedAmount }}</template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template #default="{ row }">
            <el-button text @click=";(batchUpdate = false), edit(row)">编辑</el-button>
            <el-button text @click="remove(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="bottom">
        <div style="align-self: flex-end">
          <!-- <el-button type="primary" plain  @click="remove(null)">批量删除</el-button> -->
        </div>
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </div>
    </div>

    <el-dialog
      :title="(addMemberForm.id ? '编辑' : '新建') + '员工限额'"
      v-model="addVisible"
      width="40%"
      :close-on-click-modal="false">
      <el-form ref="addMemberForm" :model="addMemberForm" :rules="addRules" position="right" label-width="180px">
        <el-form-item v-if="!batchUpdate" label="选择员工" prop="weUserId">
          <el-tag v-for="(item, index) in addMemberForm.users" :key="index">
            {{ item.name || item }}
          </el-tag>
          <template v-if="!addMemberForm.id">
            <el-button type="primary" plain @click="selectUser(2)">选择员工</el-button>
            <div class="sub-des">支持多选</div>
          </template>
        </el-form-item>
        <el-form-item label="单日员工发红包次数" prop="singleCustomerReceiveNum">
          <el-input v-model="addMemberForm.singleCustomerReceiveNum" placeholder="请输入次数"></el-input>
          <div class="sub-des">输入 {{ addMemberForm.singleCustomerReceiveNumMin }}-999999 的正整数</div>
        </el-form-item>
        <el-form-item label="单日员工发红包总额(元)" prop="singleCustomerReceiveMoney">
          <el-input-number
            v-model="addMemberForm.singleCustomerReceiveMoney"
            placeholder="请输入"
            :precision="2"
            :step="0.1"
            :min="0.3"
            :max="5000"></el-input-number>
          <div class="sub-des">精确到小数点后两位，可输入1.00-5000.00</div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addVisible = false">取 消</el-button>
          <el-button type="primary" @click="addOrUpdate">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <!-- :defaultValues="selectUserData.type == 1 ? queryUser : addMemberForm.users" -->
    <!-- 选择使用员工弹窗 -->
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      :isSigleSelect="selectUserData.isSigleSelect"
      :defaultValues="
        selectUserData.type == 1
          ? queryUser
          : list
              .map((e) => e.weUserId)
              .join()
              .split(',')
      "
      @success="submitSelectUser"></SelectUser>
  </div>
</template>

<script>
import { getList, addOrUpdate, batchUpdate, remove } from '@/api/redPacketTool/staffManage'
let defaultForm = {
  weUserId: '',
  users: [],
  singleCustomerReceiveNum: 1,
  singleCustomerReceiveMoney: 1,
}
export default {
  name: 'member',
  data() {
    let that = this
    function validateDaySendNum(rule, value, callback) {
      let min = that.addMemberForm.singleCustomerReceiveNumMin
      value = Number(value)
      if (Number.isNaN(value) || value < min || value > 999999 || !Number.isInteger(value)) {
        callback(`请输入 ${min}-999999 的正整数，修改次数不得小于已发送次数`)
      } else {
        callback()
      }
    }
    function validateDaySendSum(rule, value, callback) {
      value = Number(value)
      // || !Number.isInteger(value * 100)
      if (Number.isNaN(value) || value < 1 || value > 5000) {
        callback('请输入1.00-5000.00的数字')
      } else {
        callback()
      }
    }

    return {
      addVisible: false,
      loading: false,
      list: [],
      total: 0,
      query: {
        pageNum: 1,
        pageSize: 10,
        userId: '',
      },
      queryUser: [],
      addMemberForm: defaultForm,
      addRules: {
        weUserId: [{ required: true, message: '必填项', trigger: 'change' }],
        singleCustomerReceiveNum: [
          { required: true, message: '必填项', trigger: 'blur' },
          { validator: validateDaySendNum, trigger: 'blur' },
        ],
        singleCustomerReceiveMoney: [
          { required: true, message: '必填项', trigger: 'change' },
          { validator: validateDaySendSum, trigger: 'change' },
        ],
      },
      dialogVisibleSelectUser: false,
      selectedIds: [],
      selectUserData: {
        isSigleSelect: false,
        type: '',
      },
      batchUpdate: false,
    }
  },
  watch: {},
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          rows.forEach((e) => {
            // 单位换算 分转元
            e.singleCustomerReceiveMoney = (e.singleCustomerReceiveMoney / 100).toFixed(2)
            e.todayIssuedAmount = (e.todayIssuedAmount / 100).toFixed(2)
            e.todayNoIssuedAmount = (e.todayNoIssuedAmount / 100).toFixed(2)
            e.totalIssuedAmount = (e.totalIssuedAmount / 100).toFixed(2)
          })
          this.list = rows
          this.total = +total
        })
        .finally(() => (this.loading = false))
    },
    resetQuery() {
      this.queryUser = []
      this.query.userId = ''
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    edit(row = defaultForm) {
      this.addMemberForm = Object.assign({}, row)
      row.userName && (this.addMemberForm.users = row.userName.split(','))
      this.addMemberForm.singleCustomerReceiveNumMin = +this.addMemberForm.todayIssuedNum || 1
      this.addVisible = true
      console.log(this.addMemberForm)
      nextTick(() => this.$refs.addMemberForm.clearValidate())
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
        // this.query.userId = data[0].userId
        this.query.userId = data.map((i) => i.userId).join()
        this.getList(1)
      } else {
        this.addMemberForm.users = data.map((i) => ({
          weUserId: i.userId,
          name: i.name,
        }))
        this.addMemberForm.weUserId = data.map((e) => e.userId) + ''
        this.$refs.addMemberForm.validateField('weUserId')
      }
    },

    addOrUpdate() {
      if (this.batchUpdate) {
        this.addMemberForm.ids = this.selectedIds + ''
      }
      this.$refs.addMemberForm.validate((validate) => {
        if (!validate) return
        let form = Object.assign({}, this.addMemberForm)
        form.singleCustomerReceiveMoney *= 100
        delete form.todayIssuedAmount
        delete form.todayNoIssuedAmount
        delete form.totalIssuedAmount
        ;(this.batchUpdate ? batchUpdate : addOrUpdate)(form).then((res) => {
          this.getList()
          this.addVisible = false
          this.msgSuccess('操作成功')
        })
      })
    },
    remove(id) {
      this.$confirm('是否确认删除吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        id = id || this.selectedIds.join(',')
        remove(id).then((res) => {
          this.getList()
          this.msgSuccess('删除成功')
        })
      })
    },
  },
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

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
