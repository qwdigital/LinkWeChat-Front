<template>
  <div>
    <el-form :inline="true" label-width="110px" class="top-search">
      <el-form-item label="商品名称或描述" prop="productName">
        <el-input clearable v-model="query.productName" placeholder="请输入商品名称或描述"></el-input>
      </el-form-item>
      <el-form-item label="客户名称" prop="externalName">
        <el-input clearable v-model="query.externalName" placeholder="请输入客户名称"></el-input>
      </el-form-item>
      <el-form-item label="收款员工" prop="name">
        <el-input
          clearable
          :model-value="qrUserName"
          readonly
          @click="dialogVisibleSelect = true"
          placeholder="请选择员工" />
      </el-form-item>
      <el-form-item label="交易状态" prop="name">
        <el-select v-model="query.orderState" :popper-append-to-body="false">
          <el-option label="全部交易状态" value=""></el-option>
          <el-option label="已完成" :value="1"></el-option>
          <el-option label="已完成有退款" :value="2"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="退款状态" prop="name">
        <el-select v-model="query.refundState" :popper-append-to-body="false">
          <el-option label="全部退款状态" value=""></el-option>
          <el-option label="已申请退款" value="0"></el-option>
          <el-option label="退款处理中" value="1"></el-option>
          <el-option label="退款成功" value="2"></el-option>
          <el-option label="退款关闭" value="3"></el-option>
          <el-option label="退款异常" value="4"></el-option>
          <el-option label="审批中" value="5"></el-option>
          <el-option label="审批失败" value="6"></el-option>
          <el-option label="审批取消" value="7"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="交易时间" prop="name">
        <el-date-picker
          clearable
          v-model="dateRange"
          type="daterange"
          value-format="YYYY-MM-DD"
          @change="setChange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"></el-date-picker>
      </el-form-item>
      <el-form-item label="">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" class="mr10" @click="sync()">同步订单</el-button>
        <el-button type="danger" @click="exportFn()">导出Excel</el-button>
      </div>
      <el-table v-loading="loading" :data="list">
        <el-table-column label="商品" align="center" prop="" width="200">
          <template #default="{ row }">
            <div style="display: flex">
              <el-image
                style="width: 50px; height: 50px; margin-right: 3px; flex-shrink: 0"
                :src="row.picture"></el-image>
              <span class="limit_span">{{ row.describe }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="客户" align="center" prop="price">
          <template #default="{ row }">
            <div class="cp flex aic">
              <el-image style="width: 50px; height: 50px; flex: none" :src="row.externalAvatar" fit="fill"></el-image>
              <div class="ml10">
                <p>{{ row.externalName }}</p>
                <!-- <el-icon-Avatar :class="['el-icon-Avatar', { 1: 'man', 2: 'woman' }[row.gender]]"/> -->
                <span :style="{ color: row.externalType === 1 ? '#4bde03' : '#f9a90b' }">
                  {{ { 1: '@微信', 2: '@企业微信' }[row.externalType] }}
                </span>
              </div>
              <div v-if="row.address && row.phone" class="ml10" style="align-self: baseline">
                <el-popover trigger="hover" width="400">
                  <el-form ref="form">
                    <el-form-item label="联系人：">
                      {{ row.contact }}
                    </el-form-item>
                    <el-form-item label="联系地址：">
                      {{ row.address }}
                    </el-form-item>
                    <el-form-item label="联系电话：">
                      {{ row.phone }}
                    </el-form-item>
                  </el-form>
                  <template #reference>
                    <div style="display: inline">
                      <el-icon-WarningFilled class="el-icon-WarningFilled"></el-icon-WarningFilled>
                    </div>
                  </template>
                </el-popover>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="购买数量" align="center" prop="productNum" />
        <el-table-column label="付款金额(元)" align="center" prop="totalFee" />
        <el-table-column label="收款员工" align="center" prop="weUserName" />
        <el-table-column label="收款商户" align="center" prop="mchName"></el-table-column>
        <el-table-column label="交易状态" align="center" prop="orderStateStr">
          <template #default="{ row }">
            <a
              v-if="row.orderStateStr"
              style="color: var(--color); border-bottom: 1px solid var(--color)"
              @click="tradingStateFn(row.orderNo)">
              {{ row.orderStateStr }}
            </a>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="退款状态" align="center" prop="refundStateStr">
          <template #default="{ row }">
            <a
              v-if="row.refundStateStr"
              style="color: var(--color); border-bottom: 1px solid var(--color)"
              @click="refundStateFn(row.orderNo)">
              {{ row.refundStateStr }}
            </a>
            <span v-else>-</span>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()" />
    </div>

    <!-- 弹窗 -->
    <el-dialog title="交易状态" v-model="dialogVisible" width="800px" :close-on-click-modal="false">
      <el-form ref="form" label-width="100px">
        <el-form-item label="交易时间：">
          {{ orderState.payTime }}
        </el-form-item>
        <el-form-item label="交易单号：">
          {{ orderState.orderNo }}
          <el-button type="primary" style="margin-left: 20px" plain @click="handleCopy(orderState.orderNo)">
            复制
          </el-button>
        </el-form-item>
        <el-form-item label="商户单号：">
          {{ orderState.mchNo }}
          <el-button style="margin-left: 20px" type="primary" plain @click="handleCopy(orderState.mchNo)">
            复制
          </el-button>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer ar">
          <el-button @click="dialogVisible = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>
    <el-dialog title="退款状态" v-model="dialogStateVisible" width="800px" :close-on-click-modal="false">
      <div style="background-color: var(--bg-black-11); padding: 20px">
        <div class="g-card" v-for="(unit, key) in refundStateList" :key="key">
          <el-form ref="form">
            <el-form-item label="退款发起时间：">
              {{ unit.refundTime }}
            </el-form-item>
            <el-form-item label="退款发起人：">
              {{ unit.refundUserName }}
            </el-form-item>
            <el-form-item label="退款备注：">
              {{ unit.remark }}
            </el-form-item>
            <el-form-item label="退款金额（元）：">
              {{ unit.refundFee }}
            </el-form-item>
            <el-form-item label="退款单号：">
              {{ unit.refundNo }}
              <el-button style="margin-left: 20px" type="primary" plain @click="handleCopy(unit.refundNo)">
                复制
              </el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer ar">
          <el-button @click="dialogStateVisible = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>
    <SelectUser
      v-model:visible="dialogVisibleSelect"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
  </div>
</template>

<script>
import * as api from '@/api/commodityCenter/commodityManage'
import { dateFormat } from '@/utils/index'

export default {
  components: {},
  props: {},
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        productName: '',
        externalName: '',
        weUserId: '',
        orderState: '',
        refundState: '',
        beginTime: '',
        endTime: '',
      },
      loading: false,
      dialogVisible: false,
      total: 0,
      list: [],
      lastSyncTime: 0,
      qrUserName: undefined,
      userArray: [], // 选择人员
      userArrayStr: '',
      dialogVisibleSelect: false,
      dateRange: [],
      dialogStateVisible: false,
      dialogVisible: false,
      orderState: {
        payTime: '',
        orderNo: '',
        mchNo: '',
      },
      refundStateList: [],
    }
  },
  computed: {},
  created() {
    this.$store.setBusininessDesc(
      `
			     <div>查看商品所有订单及明细记录。</div>
			   `,
    )
    this.getList()
  },
  methods: {
    handleCopy(text) {
      const input = document.createElement('input')
      input.style.cssText = 'opacity: 0;'
      input.type = 'text'
      input.value = text // 修改文本框的内容
      document.body.appendChild(input)
      input.select() // 选中文本
      document.execCommand('copy') // 执行浏览器复制命令
      this.$message({ message: '复制成功', type: 'success' })
    },
    tradingStateFn(id) {
      api.getOrderState(id).then((res) => {
        this.orderState = res.data
        this.dialogVisible = true
      })
    },
    refundStateFn(id) {
      api.getRefundOrderState(id).then((res) => {
        this.refundStateList = res.data
        this.dialogStateVisible = true
      })
    },
    resetForm() {
      this.query = {
        pageNum: 1,
        pageSize: 10,
        productName: '',
        externalName: '',
        weUserId: '',
        orderState: '',
        refundState: '',
        beginTime: '',
        endTime: '',
      }
      this.getList()
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      api
        .getOrderTalbe(this.query)
        .then(({ rows, total, lastSyncTime }) => {
          this.list = rows
          this.total = +total
          this.lastSyncTime = lastSyncTime
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    exportFn() {
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)',
      })
      api
        .exportOrder({
          productName: this.query.productName,
          externalName: this.query.externalName,
          weUserId: this.query.weUserId,
          orderState: this.query.orderState,
          refundState: this.query.refundState,
          beginTime: this.query.beginTime,
          endTime: this.query.endTime,
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '订单')
          } else {
            const href = URL.createObjectURL(blob)
            const a = document.createElement('a')
            a.style.display = 'none'
            a.href = href
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_订单.xlsx'
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
          loading.close()
        })
        .catch(() => {
          loading.close()
        })
    },
    sync() {
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)',
      })
      api
        .setOrderSync()
        .then(() => {
          loading.close()
          this.msgSuccess('后台开始同步数据，请稍后关注进度')
          this.getList()
        })
        .catch(() => {
          loading.close()
        })
    },
    getSelectUser(data) {
      this.userArray = data
      this.qrUserName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.weUserId = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
    },
    setChange(data) {
      if (data) {
        this.query.beginTime = data[0]
        this.query.endTime = data[1]
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.el-icon-s-custom {
  font-size: 16px;
  color: var(--font-black-6);
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
.tip {
  color: var(--font-black-7);
  font-size: 12px;
  line-height: 20px;
}
.phone-content {
  padding: 10px;
}
.price {
  font-weight: 500;
  font-size: 20px;
  margin: 10px 0;
}
.content {
  margin: 10px 0;
}
.commodity-img {
  width: 100%;
}
.limit_span {
  // width: 250px;
  // overflow: hidden;
  // text-overflow: ellipsis;
  // // white-space: nowrap;
  // display: inline-block;

  white-space: pre-wrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}
</style>
