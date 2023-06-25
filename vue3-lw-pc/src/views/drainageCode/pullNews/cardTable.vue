<template>
  <div>
    <!-- 组件table -->
    <el-dialog
      :title="qrType === 1 ? '选择红包卡券' : '选择微信卡券'"
      v-model="Pvisible"
      width="80%"
      append-to-body
      destroy-on-close
      :before-close="handleClose">
      <!-- 红包 -->
      <div v-if="qrType === 1">
        <div v-if="loading || list.length !== 0">
          <el-table v-loading="loading" :data="list" @row-click="onRowClick">
            <el-table-column width="30">
              <template #default="{ row }">
                <el-radio v-model="row.checked" :label="true"></el-radio>
              </template>
            </el-table-column>
            <el-table-column width="200" label="红包" align="center" prop="name">
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
          </el-table>
          <pagination
            :total="total"
            v-model:page="query.pageNum"
            v-model:limit="query.pageSize"
            @pagination="getList()" />
        </div>

        <div class="empty" v-else-if="!loading && list.length === 0">
          <div class="tips">暂无红包，点击下方按钮立即创建</div>
          <el-button type="primary" @click="goRouter">去创建</el-button>
        </div>
      </div>
      <!-- 卡券 -->
      <div v-else>
        <div v-if="loading || list.length !== 0">
          <el-table v-loading="loading" :data="list" @row-click="onRowClick">
            <el-table-column width="30">
              <template #default="{ row }">
                <el-radio v-model="row.checked" :label="true"></el-radio>
              </template>
            </el-table-column>
            <el-table-column label="归属商户号" align="center" min-width="100" prop="stock_creator_mchid" />
            <el-table-column label="批次号" align="center" min-width="100" prop="stock_id" />
            <el-table-column label="批次名称" align="center" min-width="100" prop="stock_name" show-overflow-tooltip />
            <el-table-column label="面额" align="center" min-width="100" prop="qrGroupName" show-overflow-tooltip>
              <template #default="{ row }">{{ row.stock_use_rule.fixed_normal_coupon.coupon_amount }}元</template>
            </el-table-column>
            <el-table-column label="门槛" align="center" min-width="100" prop="qrGroupName" show-overflow-tooltip>
              <template #default="{ row }">
                满{{ row.stock_use_rule.fixed_normal_coupon.transaction_minimum }}元可用
              </template>
            </el-table-column>
            <el-table-column label="可用时间" align="center" prop="updateTime" width="180">
              <template #default="{ row }">
                <div>{{ row.available_begin_time }} 至 {{ row.available_end_time }}</div>
              </template>
            </el-table-column>
            <el-table-column label="卡券类型" align="center" min-width="100" prop="status" show-overflow-tooltip>
              <template #default="{ row }">
                <div>
                  <el-tag type="info" v-if="row.status === 'unactivated'">未激活</el-tag>
                  <el-tag type="warning" v-else-if="row.status === 'audit'">审核中</el-tag>
                  <el-tag type="success" v-else-if="row.status === 'running'">运行中</el-tag>
                  <el-tag type="danger" v-else-if="row.status === 'stoped'">已停止</el-tag>
                  <el-tag type="danger" v-else-if="row.status === 'paused'">暂停发放</el-tag>
                </div>
              </template>
            </el-table-column>
          </el-table>
          <pagination :total="total" v-model:page="form.offset" v-model:limit="form.limit" @pagination="getList()" />
        </div>

        <div class="empty" v-else-if="!loading && list.length === 0">
          <div class="tips">暂无卡券，点击下方按钮立即创建</div>
          <a href="https://pay.weixin.qq.com/" target="blank"><el-button type="primary">去创建</el-button></a>
        </div>
      </div>
      <template #footer>
        <div>
          <el-button @click="Pvisible = false">取 消</el-button>
          <el-button type="primary" @click="submit(list.length)">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
// import { getList, getTableTotal } from '@/api/drainageCode/group'
// import { getList } from '@/api/redPacketTool/enterprisePacket'
import { getCardList, getRedList } from '@/api/drainageCode/pullNews'
import moment from 'moment'
export default {
  props: {
    // 添加标签显隐
    twoVisible: {
      type: Boolean,
      default: false,
    },
    // 拉新方式 1红包 2卡券
    qrType: {
      type: Number,
      default: 1,
    },
    redId: {
      type: String,
      default: null,
    },
  },
  watch: {},
  data() {
    return {
      loading: false,
      list: [],
      query: {
        pageNum: 1,
        pageSize: 10,
        // type: '1,3',
        sceneType: '1,3',
        status: 0,
        // redEnvelopesType: 0,
      },
      form: {
        offset: 0,
        limit: 10,
      },
      total: 0,
      cardItem: null,
      detailDialog: false,
      tableList: [],
      dictStatusType: Object.freeze({ 0: '启用', 1: '停用' }),
      dictSendSence: { 1: '客户', 2: '客群', 3: '客户与客群' },
    }
  },
  computed: {
    Pvisible: {
      get() {
        return this.twoVisible
      },
      set(val) {
        this.$emit('update:twoVisible', val)
      },
    },
  },
  created() {
    this.getList()
  },
  methods: {
    goRouter() {
      this.$router.push('/customerMaintain/redPacketTool/enterprisePacket')
    },
    handleClose() {
      this.Pvisible = false
      this.list = []
    },
    submit(length) {
      if (length) {
        if (!this.cardItem) {
          this.qrType === 1 ? this.$message.error('请选择红包') : this.$message.error('请选择卡券')
        } else {
          this.$emit('selectCard', this.cardItem)
          this.Pvisible = false
          this.list = []
        }
      } else {
        this.Pvisible = false
      }
    },
    getList() {
      this.loading = true
      if (this.qrType === 1) {
        getRedList(this.query)
          .then(({ rows, total }) => {
            this.list = rows.map((i) => {
              i.money = (i.money / 100).toFixed(2)
              i.checked = false
              if (this.redId && i.id === this.redId) {
                i.checked = true
                this.cardItem = i.checked ? i : null
              }
              return i
            })
            this.total = Number(total)
            this.loading = false
          })
          .catch(() => {
            this.loading = false
          })
      } else {
        // 卡券
        getCardList(this.form)
          .then(({ rows, total }) => {
            console.log(rows)
            this.list = rows.map((i) => {
              i.checked = false
              i.available_begin_time = moment(i.available_begin_time.format(YYYY / MM / DD))
              i.available_end_time = moment(i.available_end_time.format(YYYY / MM / DD))
              i.stock_use_rule.fixed_normal_coupon.transaction_minimum = this.dealMoney(
                i.stock_use_rule.fixed_normal_coupon.transaction_minimum,
              )
              i.stock_use_rule.fixed_normal_coupon.coupon_amount = this.dealMoney(
                i.stock_use_rule.fixed_normal_coupon.coupon_amount,
              )
              return i
            })
            this.total = Number(total)
            this.loading = false
          })
          .catch(() => {
            this.loading = false
          })
      }
    },
    dealMoney(num) {
      // 将分转换为保留两位小数的元
      return (num / 100).toFixed(2)
    },
    onRowClick(row, column, event) {
      const evTarget = event.target.nodeName.toUpperCase(0)
      if (evTarget == 'INPUT') {
        return
      }
      const checked = row.checked
      if (!checked) {
        this.list.forEach((i) => (i.checked = false))
      }
      row.checked = !checked
      this.cardItem = row.checked ? row : null
    },
  },
}
</script>

<style lang="scss" scoped>
.empty {
  width: 30%;
  margin: 30px auto;
  text-align: center;
  .tips {
    color: var(--font-black-7);
    font-size: 12px;
    line-height: 60px;
  }
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
  background: url('../../../assets/image/newred1.png') 0 0/100% 100% no-repeat;
  .red-packet-text {
    width: 100%;
    height: 30px;
    overflow: hidden;
    white-space: nowrap; // 强制一行
    text-overflow: ellipsis; // 文字溢出显示省略号
  }
}
</style>
