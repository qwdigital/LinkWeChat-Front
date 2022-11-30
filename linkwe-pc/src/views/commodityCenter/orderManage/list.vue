<template>
  <div class="">
    <el-form :inline="true" label-width="110px" class="top-search">
      <el-form-item label="商品名称或描述" prop="productName">
        <el-input v-model="query.productName" placeholder="请输入商品名称或描述"></el-input>
      </el-form-item>
      <el-form-item label="客户名称" prop="externalName">
        <el-input v-model="query.externalName" placeholder="请输入客户名称"></el-input>
      </el-form-item>
      <el-form-item label="收款员工" prop="name">
        <el-input :value="qrUserName" readonly @focus="dialogVisibleSelect = true" placeholder="请选择员工" />
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
          v-model="dateRange"
          type="daterange"
          value-format="yyyy-MM-dd"
          @change="setChange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label=" ">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button type="success" @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="mid-action">
      <el-button type="primary" class="mr10" @click="sync()">同步订单</el-button>
      <el-button type="danger" @click="exportFn()">导出Excel</el-button>
    </div>
    <el-table v-loading="loading" :data="list">
      <el-table-column label="商品" align="center" prop="" width="200">
        <div slot-scope="{ row }">
          <div style="display: flex;">
            <el-image
              style="width: 50px; height: 50px; margin-right: 3px; flex-shrink: 0;"
              :src="row.picture"
            ></el-image>
            <span class="limit_span">{{ row.describe }}</span>
          </div>
        </div>
      </el-table-column>
      <el-table-column label="客户" align="center" prop="price">
        <template slot-scope="{ row }">
          <div class="cp flex aic">
            <el-image style="width: 50px; height: 50px; flex: none;" :src="row.externalAvatar" fit="fit"></el-image>
            <div class="ml10">
              <p>{{ row.externalName }}</p>
              <!-- <i :class="['el-icon-s-custom', { 1: 'man', 2: 'woman' }[row.gender]]"></i> -->
              <span :style="{ color: row.externalType === 1 ? '#4bde03' : '#f9a90b' }">
                {{ { 1: '@微信', 2: '@企业微信' }[row.externalType] }}
              </span>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="购买数量" align="center" prop="productNum" />
      <el-table-column label="付款金额(元)" align="center" prop="totalFee" />
      <el-table-column label="收款员工" align="center" prop="weUserName" />
      <el-table-column label="收款商户" align="center" prop="mchName"> </el-table-column>
      <el-table-column label="交易状态" align="center" prop="orderStateStr" />
      <el-table-column label="退款状态" align="center" prop="refundStateStr" />
    </el-table>
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()"
    />
    <!-- 弹窗 -->
    <el-dialog title="交易状态" :visible.sync="dialogVisible" width="800px" :close-on-click-modal="false">
      <el-row>
        <el-col :span="12">
          <el-form ref="form" label-width="100px">
            <el-form-item label="交易时间：">
              <!-- {{}} -->
            </el-form-item>
            <el-form-item label="交易单号：">
              <!-- {{}} -->
            </el-form-item>
            <el-form-item label="商户单号：">
              <!-- {{}} -->
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer ar">
        <el-button @click="dialogVisible = false">关 闭</el-button>
      </div>
    </el-dialog>
    <el-dialog title="退款状态" :visible.sync="dialogStateVisible" width="800px" :close-on-click-modal="false">
      <el-row>
        <el-col :span="12">
          <el-form ref="form" label-width="100px">
            <el-form-item label="退款发起时间：">
              <!-- {{}} -->
            </el-form-item>
            <el-form-item label="退款发起人：">
              <!-- {{}} -->
            </el-form-item>
            <el-form-item label="退款备注：">
              <!-- {{}} -->
            </el-form-item>
            <el-form-item label="退款金额（元）">
              <!-- {{}} -->
            </el-form-item>
            <el-form-item label="退款单号：">
              <!-- {{}} -->
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer ar">
        <el-button @click="dialogStateVisible = false">关 闭</el-button>
      </div>
    </el-dialog>
    <SelectWeUser
      :visible.sync="dialogVisibleSelect"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectWeUser>
  </div>
</template>

<script>
  import * as api from '@/api/commodityCenter/commodityManage'
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
          endTime: ''
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
        dialogVisible: false
      }
    },
    computed: {},
    created() {
      this.getList()
    },
    methods: {
      tradingStateFn(id) {
        api.getOrderState(id)
      },
      refundStateFn(orderNo) {
        api.getRefundOrderState(orderNo)
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
          endTime: ''
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
          background: 'rgba(0, 0, 0, 0.7)'
        })
        api
          .exportOrder()
          .then((res) => {
            loading.close()
            console.log(res)
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
          background: 'rgba(0, 0, 0, 0.7)'
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
      }
    }
  }
</script>

<style lang="scss" scoped>
  .el-icon-s-custom {
    font-size: 16px;
    color: #999;
    &.man {
      color: #13a2e8;
    }
    &.woman {
      color: #f753b2;
    }
  }
  .tip {
    color: #aaa;
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
