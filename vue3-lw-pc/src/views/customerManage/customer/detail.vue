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
              <span>{{ obj.name }} ：</span>
              <span>{{ obj.actualValue }}</span>
            </template>
            <template v-else>
              <!-- 附件 -->
              <span>{{ obj.name }} ：</span>
              <template v-for="(item2, j) in dealValue(obj.actualValue)" :key="j">
                <!-- 图片 -->
                <el-image
                  :src="obj.actualValue"
                  fit="contain"
                  class="imgsize"
                  v-if="item2 && chargeType(item2)"
                ></el-image>
                <!-- 文件/doc/xls/pdf -->
                <a :href="obj.actualValue" v-else>{{ obj.actualValue }}</a>
              </template>
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
    dealValue(val) {
      let url = []
      if (val) {
        url = val.split(',')
      }
      return url
    },
    chargeType(val) {
      if (val) {
        let url = val.split('.')
        if (['jpg', 'jpeg', 'png'].includes(url[url.length - 1])) {
          return true
        } else {
          return false
        }
      }
    },
    // 点击×按钮
    handleClose() {
      this.$emit('close', false)
    },
    //  获取全部属性
    getProperties() {
      getProperties().then((res) => {
        console.log(res)
        this.query = res.data
      })
    },
    // 获取详情
    getDetail(id) {
      orderDetail(id).then((res) => {
        console.log(res)
        this.detailList = res.data
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.g-card {
  .title {
    font-size: 16px;
    margin-bottom: 16px;
  }
  .content-item {
    line-height: 34px;
  }
}
.imgsize {
  width: 120px;
  height: 120px;
}
</style>
