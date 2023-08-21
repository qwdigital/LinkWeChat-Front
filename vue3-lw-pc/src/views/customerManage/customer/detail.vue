<template>
  <div>
    <el-dialog
      title="订单详情"
      v-model="dialogVisible"
      width="30%"
      v-if="dialogVisible"
      :before-close="handleClose"
    >
      <div class="g-card" v-for="(item, index) in detailList" :key="index">
        <div class="title">{{ item.name }}</div>
        <div class="content">
          <div class="content-item" v-for="(obj, i) in item.properties" :key="i">
            <template v-if="obj.type !== 7">
              <span>{{ obj.name }}</span>
              <span>{{ query[obj.code] }}</span>
            </template>
            <template v-else>
              <!-- 附件 -->
            </template>
          </div>
        </div>
      </div>
      <!-- <div class="g-card">
        <div class="title">商品信息</div>
      </div> -->
    </el-dialog>
  </div>
</template>

<script>
import { orderDetail, getProperties } from '@/api/customer'
export default {
  data() {
    return {
      dialogVisible: false,
      ruleForm: {},
      detailList: [],
      query: {},
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
          this.getDetail(this.id)
          this.getProperties()
        }
      },
    },
  },
  created() {
    // this.getDetail()
  },
  methods: {
    // 点击×按钮
    handleClose() {
      this.$emit('close', false)
    },
    //  获取全部属性
    getProperties(id) {
      getProperties(id).then((res) => {
        console.log(res)
        this.query = res.data
      })
    },
    // 获取详情
    getDetail() {
      orderDetail(id).then((res) => {
        console.log(res)
        this.detailList = res.data
      })
    },
  },
}
</script>

<style></style>
