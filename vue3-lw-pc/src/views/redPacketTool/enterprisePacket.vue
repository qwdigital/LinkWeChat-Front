<template>
  <div>
    <el-form inline label-position="right" :model="query" label-width="" ref="queryForm" class="top-search">
      <el-form-item label="红包状态" prop="status">
        <el-select clearable v-model="query.status" placeholder="请选择">
          <el-option v-for="(item, key) in dictStatusType" :key="key" :label="item" :value="key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="发送场景" prop="sceneType">
        <el-select clearable v-model="query.sceneType" placeholder="请选择">
          <el-option v-for="(item, key) in dictSendSence" :key="key" :label="item" :value="key"></el-option>
        </el-select>
      </el-form-item>
      <!-- <el-form-item label="创建人" prop="createBy">
          <el-input v-model="query.createBy" placeholder="请输入"></el-input>
        </el-form-item> -->
      <!-- <el-form-item label="创建时间">
          <el-date-picker
            v-model="dateRange"
            value-format="YYYY-MM-DD"
            type="daterange"
            v-bind="pickerOptions"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            align="right"
          ></el-date-picker>
        </el-form-item> -->
      <el-form-item label="">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="edit()">新建红包</el-button>
        <el-button type="primary" plain @click="showLimitConfig">限额设置</el-button>
      </div>
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column fixed width="200" label="红包" align="center" prop="name">
          <template #default="{ row }">
            <div class="red-packet-message">
              <div class="red-packet-text">
                {{ row.name }}
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="红包金额(元)" align="center" prop="money" />
        <el-table-column label="发送次数" align="center" prop="sendTimes" />
        <el-table-column label="发送场景" align="center" prop="sceneType">
          <template #default="{ row }">
            <div>{{ dictSendSence[row.sceneType] }}</div>
          </template>
        </el-table-column>
        <el-table-column label="红包状态" align="center" prop="status">
          <template #default="{ row }">
            <div>{{ dictStatusType[row.status] }}</div>
          </template>
        </el-table-column>
        <el-table-column label="最近更新时间" align="center" width="180" prop="createTime"></el-table-column>
        <el-table-column fixed="right" label="操作" align="center" width="180">
          <template #default="{ row }">
            <el-button text @click="edit(row)">编辑</el-button>
            <el-button text @click="startOrStop(row)">
              {{ { 0: '停用', 1: '启用' }[row.status] }}
            </el-button>
            <el-button text @click="remove(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="bottom">
        <div style="align-self: flex-end">
          <el-button type="primary" :disabled="selectedIds.length == 0" plain @click="remove(null)">批量删除</el-button>
        </div>
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </div>
    </div>

    <!-- 新建红包 -->
    <el-dialog title="新建红包" v-model="addDialogVisible" :close-on-click-modal="false">
      <el-form ref="addForm" :model="addForm" :rules="addRules" label-position="right" label-width="120px">
        <el-form-item label="红包金额(元)" prop="money">
          <el-input-number
            placeholder="请输入"
            v-model="addForm.money"
            :precision="2"
            :step="0.1"
            :max="200"
            :min="1"></el-input-number>
          <div class="sub-des">精确到小数点后两位，可输入1~200</div>
        </el-form-item>
        <el-form-item label="发送场景" prop="sceneType">
          <el-radio-group v-model="addForm.sceneType">
            <el-radio v-for="(item, key) in dictSendSence" :key="key" :label="+key">
              {{ item }}
            </el-radio>
          </el-radio-group>
          <div class="sub-des">发送客户群时支持选择拼手气红包或普通金额相同红包</div>
        </el-form-item>
        <el-form-item label="红包名称" prop="name">
          <el-input type="text" placeholder="请输入红包名称" v-model="addForm.name" maxlength="16"></el-input>
        </el-form-item>
        <el-form-item label="预览">
          <div class="red-packet-message">
            <div class="red-packet-text">
              {{ addForm.name || '红包名称' }}
            </div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="addOrUpdate">确 定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 限额设置 -->
    <el-dialog title="限额设置" v-model="limitDialogVisible" :close-on-click-modal="false">
      <el-form ref="limitForm" :model="limitForm" :rules="limitRules" label-position="right" label-width="180px">
        <el-form-item label="单日付款总额(元)" prop="singleDayPay">
          <el-input-number
            v-model="limitForm.singleDayPay"
            placeholder="请输入"
            :precision="2"
            :step="0.1"
            :min="0"
            :max="1000000"></el-input-number>
          <!-- <el-input v-model="limitForm.singleDayPay" placeholder="请输入金额"></el-input> -->
          <div class="sub-des">精确到小数点后两位，不超过100万元</div>
        </el-form-item>
        <el-form-item label="单日每客户收红包次数" prop="singleCustomerReceiveNum">
          <el-input v-model="limitForm.singleCustomerReceiveNum" placeholder="请输入次数"></el-input>
          <div class="sub-des">输入 1-10 的正整数</div>
        </el-form-item>
        <el-form-item label="单日每客户收红包总额" prop="singleCustomerReceiveMoney">
          <el-input-number
            v-model="limitForm.singleCustomerReceiveMoney"
            :precision="2"
            :step="0.1"
            :min="0"
            :max="1000"></el-input-number>
          <!-- <el-input v-model="limitForm.singleCustomerReceiveMoney" placeholder="请输入金额"></el-input> -->
          <div class="sub-des">精确到小数点后两位，不超过1000元</div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="limitDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="setLimit">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { getList, startOrStop, addOrUpdate, remove, getLimit, setLimit } from '@/api/redPacketTool/enterprisePacket'
import col from '@/utils/calculation'
function validateAmount(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }

  value = Number(value)
  if (Number.isNaN(value) || value < 0.01 || value > 1e6 || !Number.isInteger(col.accMul(value, 100))) {
    callback('请输入0.01-1000000的数字，精确到小数点后两位')
  } else {
    callback()
  }
}
function validateAmount1(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }

  value = Number(value)
  console.log(col.accMul(value, 100))
  if (Number.isNaN(value) || value < 0.01 || value > 200 || !Number.isInteger(col.accMul(value, 100))) {
    callback('请输入0.01-200.00的数字，精确到小数点后两位')
  } else {
    callback()
  }
}
function validateClientReceiveNum(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }

  // value = Number(value)
  if (Number.isNaN(Number(value)) || Number(value) < 1 || Number(value) > 10 || value.toString().indexOf('.') > -1) {
    callback('请输入 1-10 的正整数')
  } else {
    callback()
  }
}
export default {
  name: 'list',
  data() {
    return {
      addDialogVisible: false,
      limitDialogVisible: false,
      loading: false,
      list: [],
      total: 0,
      query: {
        pageNum: 1,
        pageSize: 10,
      },
      limitForm: {
        singleDayPay: '',
        singleCustomerReceiveNum: 1,
        singleCustomerReceiveMoney: '',
      },
      limitRules: {
        singleDayPay: [
          { required: true, message: '请输入金额', trigger: 'change' },
          { validator: validateAmount, trigger: 'change' },
        ],
        singleCustomerReceiveNum: [
          { required: true, message: '请输入次数', trigger: 'blur' },
          { validator: validateClientReceiveNum, trigger: 'blur' },
        ],
        singleCustomerReceiveMoney: [
          { required: true, message: '请输入金额', trigger: 'change' },
          { validator: validateAmount, trigger: 'change' },
        ],
      },
      addForm: {
        sceneType: [],
        name: '',
        money: 1,
      },
      addRules: {
        name: [{ required: true, message: '必填项' }],
        money: [
          { required: true, message: '必填项', trigger: 'change' },
          { validator: validateAmount1, trigger: 'blur' },
        ],
        sceneType: [{ required: true, message: '必填项', trigger: 'change' }],
      },
      selectedIds: [],
      dictStatusType: Object.freeze({ 0: '启用', 1: '停用' }),
      dictSendSence: { 1: '客户', 2: '客群', 3: '客户与客群' },
    }
  },
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>用于快捷创建企业红包模板，便于员工通过侧边栏快捷发送红包</div>
      `,
    )
  },
  methods: {
    getList() {
      getList(this.query).then(({ rows, total }) => {
        rows.forEach((e) => {
          // 单位换算 分转元
          e.money = (e.money / 100).toFixed(2)
        })
        this.list = rows
        this.total = +total
      })
    },
    resetQuery() {
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    edit(row) {
      this.addForm = Object.assign({}, row || {})
      this.addDialogVisible = true
      setTimeout(() => this.$refs.addForm.clearValidate(), 0)
    },
    addOrUpdate() {
      this.$refs.addForm.validate((validate) => {
        if (!validate) return
        let form = Object.assign({}, this.addForm)
        // 单位换算 元转分
        form.money *= 100
        addOrUpdate(form).then((res) => {
          this.msgSuccess('操作成功')
          this.getList()
          this.addDialogVisible = false
        })
      })
    },

    handleSelectionChange(val) {
      this.selectedIds = val.map((i) => i.id)
    },
    async showLimitConfig() {
      const { data } = await getLimit()
      let { id, singleDayPay, singleCustomerReceiveNum, singleCustomerReceiveMoney } = data
      // 单位换算 分转元
      singleDayPay /= 100
      singleCustomerReceiveMoney /= 100
      this.limitForm = { id, singleDayPay, singleCustomerReceiveNum, singleCustomerReceiveMoney }
      this.limitForm.singleCustomerReceiveNum = this.limitForm.singleCustomerReceiveNum || 1
      this.limitDialogVisible = true
      this.$nextTick(() => this.$refs.limitForm.clearValidate())
    },
    setLimit() {
      this.$refs.limitForm.validate((validate) => {
        if (!validate) return
        let form = Object.assign({}, this.limitForm)
        // 单位换算 元转分
        form.singleDayPay *= 100
        form.singleCustomerReceiveMoney *= 100
        setLimit(form).then((res) => {
          this.limitDialogVisible = false
          this.msgSuccess('操作成功')
        })
      })
    },
    startOrStop({ id, status }) {
      this.$confirm(`确认${{ 0: '停用', 1: '启用' }[status]}吗?`, '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        startOrStop({
          id, //主键
          status: { 0: '1', 1: '0' }[status], //0:启用;1:停用
        }).then((res) => {
          this.msgSuccess('操作成功')
          this.getList()
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
          this.msgSuccess('删除成功')
          this.getList()
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
.red-packet-message {
  display: inline-block;
  text-align: left;
  width: 175px;
  height: 75px;
  padding: 20px 10px 0 54px;
  color: var(--font-white, #fff);
  line-height: 1.15;
  font-size: 14px;
  font-weight: 500;
  background: url('../../assets/image/newred1.png') 0 0/100% 100% no-repeat;
  .red-packet-text {
    width: 100%;
    height: 30px;
    overflow: hidden;
    white-space: nowrap; // 强制一行
    text-overflow: ellipsis; // 文字溢出显示省略号
  }
}
</style>
