<template>
  <div>
    <el-dialog
      title="订单详情"
      v-model="dialogVisible"
      width="30%"
      v-if="dialogVisible"
      :before-close="handleClose"
    >
      <div class="g-card">
        <div class="title">订单信息</div>
      </div>
      <div class="g-card">
        <div class="title">商品信息</div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { orderDetail } from '@/api/customer'
export default {
  data() {
    return {
      dialogVisible: false,
      ruleForm: {},
    }
  },
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
    id: {
      type: String,
      default: '',
    },
  },
  watch: {
    visible: {
      handler(val) {
        this.dialogVisible = val
        if (!val) {
          this.ruleForm = {}
        } else {
          this.orderDetail(this.id)
        }
      },
    },
  },
  methods: {
    // 点击×按钮
    handleClose() {
      this.$emit('close', false)
    },
    orderDetail(id) {
      orderDetail(id).then((res) => {
        console.log(res)
      })
    },
  },
}
</script>

<style></style>
