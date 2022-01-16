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
      <el-button type="primary" @click="addVisible = true">新建员工限额 </el-button>
      <el-button type="primary" plain size="mini" @click="remove(null)">批量编辑</el-button>
    </div>
    <div class="g-card g-pad20">
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="businessName" label="员工姓名" align="center" />
        <el-table-column prop="limitSendNum" label="限额总笔数/总金额" align="center">
          <template slot-scope="{ row }">
            {{ row.limitSendNum }}/{{ row.limitSendSum || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="今日已发放金额/剩余金额" align="center">
          <template slot-scope="{ row }">
            {{ row.daySendSum }}/{{ accSub(row.limitSendSum, row.daySendSum) }}
          </template>
        </el-table-column>
        <el-table-column label="今日已发放次数/剩余次数" align="center">
          <template slot-scope="{ row }">
            {{ row.daySendNum }}/{{ accSub(row.limitSendNum, row.daySendNum) }}
          </template>
        </el-table-column>
        <el-table-column label="累计已发放次数/金额" align="center" width="180">
          <template slot-scope="{ row }"> {{ row.totalSendNum }}/{{ row.totalSendSum }} </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="{ row }">
            <el-button type="text" @click="remove(row.redId)">编辑</el-button>
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
    <el-dialog title="新建员工限额" :visible.sync="addVisible" width="40%" destroy-on-close>
      <el-form
        ref="addMemberForm"
        :model="addMemberForm"
        :rules="addRules"
        position="right"
        label-width="180px"
      >
        <el-form-item label="选择员工" prop="staff">
          <el-tag v-for="item in addMemberForm.staffDetails" :key="item.businessId">{{
            item.businessName
          }}</el-tag>
          <el-button type="primary" size="mini" plain @click="selectUser(2)">选择员工</el-button>
          <div class="sub-des">支持多选</div>
        </el-form-item>
        <el-form-item label="单日员工发红包次数" prop="daySendNum">
          <el-input v-model="addMemberForm.daySendNum" placeholder="请输入次数"></el-input>
          <div class="sub-des">输入 1-999999 的正整数</div>
        </el-form-item>
        <el-form-item label="单日员工发红包总数(元)" prop="daySendSum">
          <el-input v-model="addMemberForm.daySendSum" placeholder="请输入金额"></el-input>
          <div class="sub-des">精确到小数点后两位，可输入0.30-5000.00</div>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addVisible = false">取 消</el-button>
        <el-button type="primary" @click="add">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      :visible.sync="dialogVisibleSelectUser"
      title="选择使用员工"
      :isOnlyLeaf="true"
      :isSigleSelect="selectUserData.isSigleSelect"
      :defaultValues="selectUserData.type == 1 ? queryUser : addMemberForm.staffDetails"
      destroyOnClose
      @success="submitSelectUser"
    ></SelectUser>
  </div>
</template>

<script>
import { getScopList, addScop, updatedScop, removeScop } from '@/api/moneyTool/moneyTool'
import { accSub } from '@/utils/common'
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
        businessId: ''
      },
      queryUser: [],
      addMemberForm: {
        staffDetails: [],
        daySendNum: '',
        daySendSum: ''
      },
      addRules: {
        staff: [{ validator: this.validateStaff, trigger: 'blur' }],
        daySendNum: [
          { required: true, message: '必填项', trigger: 'blur' },
          { validator: this.validateDaySendNum, trigger: 'blur' }
        ],
        daySendSum: [
          { required: true, message: '必填项', trigger: 'blur' },
          { validator: this.validateDaySendSum, trigger: 'blur' }
        ]
      },
      dialogVisibleSelectUser: false,
      selectedIds: [],
      selectUserData: {
        isSigleSelect: false,
        type: ''
      }
    }
  },
  watch: {
    addVisible(val) {
      if (!val) {
        // 清空
        this.addMemberForm.staffDetails = []
        this.addMemberForm.daySendNum = ''
        this.addMemberForm.daySendSum = ''
        this.$refs.addMemberForm.clearValidate()
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    accSub,
    getList() {
      this.loading = true
      getScopList(this, this.query)
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
      this.query.businessId = ''
    },
    handleSelectionChange(val) {
      this.selectedIds = val.map((i) => i.redId)
    },
    selectUser(type) {
      this.selectUserData.type = type
      this.selectUserData.isSigleSelect = type == 1
      this.dialogVisibleSelectUser = true
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
    submitSelectUser(data) {
      if (this.selectUserData.type == 1) {
        this.queryUser = data
        this.query.businessId = data[0].userId
      } else {
        this.addMemberForm.staffDetails = data.map((i) => ({
          businessId: i.userId,
          businessName: i.name
        }))
        this.$refs.addMemberForm.clearValidate('staff')
      }
    },
    validateStaff(rule, value, callback) {
      if (this.addMemberForm.staffDetails.length == 0) {
        callback('请选择员工')
      } else {
        callback()
      }
    },
    add() {
      this.$refs.addMemberForm.validate((validate) => {
        if (!validate) return
        addScop(this, this.addMemberForm).then((res) => {
          if (res.code == 200) {
            this.getList()
            this.addVisible = false
            this.msgSuccess('操作成功')
          }
        })
      })
    },
    remove(id) {
      this.$confirm('是否确认删除吗?', '警告', {
        type: 'warning'
      }).then(() => {
        id = id || this.selectedIds.join(',')
        removeScop(this, id).then((res) => {
          if (res.code == 200) {
            this.getList()
            this.msgSuccess('删除成功')
          } else {
            this.msgError(res.msg || '操作失败')
          }
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
