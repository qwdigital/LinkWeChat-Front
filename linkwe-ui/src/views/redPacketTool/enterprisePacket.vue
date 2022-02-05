<template>
  <div>
    <div class="top-search">
      <el-form inline label-position="right" :model="query" label-width="100px" ref="queryForm">
        <el-form-item label="红包状态" prop="customerType">
          <el-select v-model="query.customerType" placeholder="请选择">
            <el-option
              v-for="(item, key) in dictCustomerType"
              :key="key"
              :label="item"
              :value="key"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="发送场景" prop="sendType">
          <el-select v-model="query.sendType" placeholder="请选择" size="small">
            <el-option
              v-for="(item, key) in dictSendSence"
              :key="key"
              :label="item"
              :value="key"
            ></el-option>
          </el-select>
        </el-form-item>
        <!-- <el-form-item label="创建人" prop="createBy">
          <el-input v-model="query.createBy" placeholder="请输入"></el-input>
        </el-form-item> -->
        <!-- <el-form-item label="创建时间">
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
        </el-form-item> -->
        <el-form-item label=" ">
          <el-button type="primary" @click="getList(1)">查询</el-button>
          <el-button type="success" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div style="padding: 20px; background-color: #fff">
      <el-button type="primary" @click="addDialogVisible = true">新建红包</el-button>
      <el-button type="primary" plain @click="showLimitConfig">限额设置</el-button>
    </div>
    <div class="g-card g-pad20">
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="红包" align="center" prop="amount">
          <div class="red-packet-message">红包名称</div>
        </el-table-column>
        <el-table-column label="红包金额(元)" align="center" prop="amount" />
        <el-table-column label="发送次数" align="center" prop="sendNum" />
        <el-table-column label="发送场景" align="center" prop="sendSum" />
        <el-table-column label="红包状态" align="center" prop="createBy" />
        <el-table-column label="最近更新时间" align="center" width="180" prop="createTime">
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="{ row }">
            <el-button type="text" @click="remove(row.redId)">编辑</el-button>
            <el-button type="text" @click="remove(row.redId)">启用/停用</el-button>
            <el-button type="text" @click="remove(row.redId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="bottom">
        <div style="align-self: flex-end">
          <el-button
            type="primary"
            :disabled="selectedIds.length == 0"
            plain
            size="mini"
            @click="remove(null)"
            >批量删除</el-button
          >
        </div>
        <pagination
          :total="total"
          :page.sync="query.pageNum"
          :limit.sync="query.pageSize"
          @pagination="getList()"
        />
      </div>
    </div>

    <!-- 新建红包 -->
    <el-dialog title="新建红包" :visible.sync="addDialogVisible" :close-on-click-modal="false">
      <el-form
        ref="addForm"
        :model="addForm"
        :rules="addRules"
        label-position="right"
        label-width="120px"
      >
        <el-form-item label="红包金额(元)" required prop="amount">
          <el-input
            type="text"
            placeholder="请输入金额"
            v-model="addForm.amount"
            :max="200"
            :min="0.01"
          ></el-input>
          <div class="sub-des">精确到小数点后两位，可输入1~200</div>
        </el-form-item>
        <el-form-item label="发送场景" required prop="amount">
          <el-checkbox-group v-model="addForm.amount">
            <el-checkbox
              v-for="(item, key) in dictSendSence"
              :key="key"
              :label="item"
              :value="key"
            ></el-checkbox>
          </el-checkbox-group>
          <div class="sub-des">发送客户群时支持选择拼手气红包或普通金额相同红包</div>
        </el-form-item>
        <el-form-item label="红包名称" required prop="amount">
          <el-input
            type="text"
            placeholder="请输入金额"
            v-model="addForm.amount"
            maxlength="16"
          ></el-input>
        </el-form-item>
        <el-form-item label="预览">
          <div class="red-packet-message">红包名称</div>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="add">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 限额设置 -->
    <el-dialog title="限额设置" :visible.sync="limitDialogVisible" :close-on-click-modal="false">
      <el-form
        ref="limitForm"
        :model="limitForm"
        :rules="limitRules"
        label-position="right"
        label-width="180px"
      >
        <el-form-item label="单日付款总额(元)" prop="daySendAmount">
          <el-input-number
            v-model="limitForm.daySendAmount"
            :precision="2"
            :step="0.1"
            :min="0"
            :max="1000000"
          ></el-input-number>
          <!-- <el-input v-model="limitForm.daySendAmount" placeholder="请输入金额"></el-input> -->
          <div class="sub-des">精确到小数点后两位，不超过100万元</div>
        </el-form-item>
        <el-form-item label="单日每客户收红包次数" prop="clientReceiveNum">
          <el-input v-model="limitForm.clientReceiveNum" placeholder="请输入次数"></el-input>
          <div class="sub-des">输入 1-10 的正整数</div>
        </el-form-item>
        <el-form-item label="单日每客户收红包总额" prop="clientReceiveSum">
          <el-input-number
            v-model="limitForm.clientReceiveSum"
            :precision="2"
            :step="0.1"
            :min="0"
            :max="1000"
          ></el-input-number>
          <!-- <el-input v-model="limitForm.clientReceiveSum" placeholder="请输入金额"></el-input> -->
          <div class="sub-des">精确到小数点后两位，不超过1000元</div>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="limitDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="setLimitConfig">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  getList,
  remove,
  add,
  getInfo,
  getLimitList,
  addLimit,
  updateLimit
} from '@/api/redPacketTool'

function validateAmount(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }

  value = Number(value)
  if (
    Number.isNaN(value) ||
    value < 0.01 ||
    value > 1e6 ||
    ((value = value.toString().split('.')[1]) && value && value.length > 2)
  ) {
    callback('请输入0.01-1000000的数字，精确到小数点后两位')
  } else {
    callback()
  }
}
function validateClientReceiveNum(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }

  value = Number(value)
  if (Number.isNaN(value) || value < 1 || value > 10 || value.toString().indexOf('.') > -1) {
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
        pageSize: 10
      },
      limitForm: {
        daySendAmount: '',
        clientReceiveNum: '',
        clientReceiveSum: ''
      },
      limitRules: {
        daySendAmount: [
          // { required: true, message: '请输入金额', trigger: 'blur' },
          { validator: validateAmount, trigger: 'blur' }
        ],
        clientReceiveNum: [
          // { required: true, message: '请输入次数', trigger: 'blur' },
          { validator: validateClientReceiveNum, trigger: 'blur' }
        ],
        clientReceiveSum: [
          { required: true, message: '请输入金额', trigger: 'blur' },
          { validator: validateAmount, trigger: 'blur' }
        ]
      },
      addForm: {},
      addRules: {
        amount: [
          { required: true, message: '请输入金额' },
          { validator: validateAmount, trigger: 'blur' }
        ]
      },
      selectedIds: [],
      dictCustomerType: Object.freeze({ 1: '微信客户', 2: '企业客户' }),
      dictSendSence: Object.freeze({ 1: '客户', 2: '客户群' })
    }
  },
  created() {
    // this.getList()
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>用于快捷创建企业红包模板，便于员工通过侧边栏快捷发送红包</div>
      `
    )
  },
  methods: {
    getList() {
      getList(this, this.query).then((res) => {
        if (res.code == 200) {
          this.list = res.rows
          this.total = +res.total
        }
      })
    },

    add() {
      this.$refs.addForm.validate((validate) => {
        if (!validate) return
        this.addForm.amount = Number(this.addForm.amount)
        add(this, this.addForm).then((res) => {
          if (res.code == 200) {
            this.msgSuccess('操作成功')
            this.getList()
            this.addDialogVisible = false
          } else {
            this.msgSuccess(res.msg || '操作失败')
          }
        })
      })
    },
    remove(id) {
      this.$confirm('是否确认删除吗?', '警告', {
        type: 'warning'
      }).then(() => {
        id = id || this.selectedIds.join(',')
        remove(this, id).then((res) => {
          if (res.code == 200) {
            this.msgSuccess('删除成功')
            this.getList()
          } else {
            this.msgError('操作失败')
          }
        })
      })
    },
    handleSelectionChange(val) {
      this.selectedIds = val.map((i) => i.redId)
    },
    getLimitConfigFromList() {
      return getLimitList(this, { pageSize: 10, pageNum: 1 }).then((res) => {
        if (res.code == 200 && Array.isArray(res.rows)) {
          return res.rows[0]
        }
      })
    },
    async initLimitData() {
      const limitConfig = await this.getLimitConfigFromList()
      if (limitConfig) {
        this.$set(this.limitForm, 'id', limitConfig.id)
      }
    },
    async showLimitConfig() {
      await this.initLimitData()
      this.limitDialogVisible = true
    },
    setLimitConfig() {
      this.$refs.limitForm.validate((validate) => {
        if (!validate) return
        ;(!this.limitForm.id ? addLimit : updateLimit)(this, this.limitForm).then((res) => {
          console.log(res)
          if (res.code == 200) {
            this.limitDialogVisible = false
            this.msgSuccess('操作成功')
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
.red-packet-message {
  display: inline-block;
  width: 175px;
  height: 75px;
  padding: 12px 0 0 50px;
  color: #fff;
  line-height: 1.15;
  font-size: 18px;
  font-weight: 500;
  background: url('../../assets/image/red-packet-1.png') 0 0/100% 100% no-repeat;
}
</style>
