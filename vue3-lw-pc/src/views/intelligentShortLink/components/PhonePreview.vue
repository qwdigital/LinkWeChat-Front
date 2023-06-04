// 短链移动端样式预览
<script>
import { touchTypeDict } from './mixin'
export default {
  name: '',
  components: {},
  props: {
    data: {
      type: Object,
      default: {},
    },
  },
  data() {
    return {
      touchTypeDict,
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>

<template>
  <div class="g-card mt0">
    <div class="g-title">预览</div>
    <div class="pad20">
      <PhoneTemplate v-if="touchTypeDict[data.type]" :title="touchTypeDict[data.type].previewMobileTitle">
        <template v-if="data.type == 0">
          <div class="mask" style="position: absolute">
            <div class="cc ac g-card" style="width: 70%">公众号文章示例</div>
          </div>
        </template>
        <div v-else class="g-card cc ac" style="width: 70%; padding-bottom: 50px">
          <!-- 个人小程序，企业小程序 -->
          <template v-if="[7, 9].includes(+data.type)">
            <div class="mt10">{{ data.name || '小程序' }}</div>
            <el-image
              style="width: 120px; height: 120px; display: block; margin: 20px auto 30px"
              :src="data.avatar"></el-image>
            <el-button type="primary">点击打开{{ data.name || '小程序' }}</el-button>
          </template>
          <template v-else>
            <!-- 员工活码，客群活码 门店导购活码 门店群活码 -->
            <div v-if="[4, 5, 6, 8].includes(+data.type)" class="mt10">
              {{ data.name || touchTypeDict[data.type].name }}
            </div>

            <div v-else class="al bfc-o">
              <el-image class="fl mr10" style="width: 50px; height: 50px" :src="data.avatar" fit="fill"></el-image>
              <div class="toe">{{ data.name || '名称' }}</div>
              <div class="tips mt20 toe">{{ data.describe || '描述' }}</div>
            </div>

            <el-image style="width: 120px; height: 120px; margin: 20px 0 30px" :src="data.qrCode" fit="fill"></el-image>
            <div class="">长按二维码{{ touchTypeDict[data.type].previewMobileTitle }}</div>
          </template>
        </div>
      </PhoneTemplate>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
