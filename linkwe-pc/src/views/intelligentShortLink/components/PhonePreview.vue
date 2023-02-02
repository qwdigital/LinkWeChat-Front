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
  <div class="g-card" style="margin-top: 0">
    <div class="g-title">预览</div>
    <div class="g-pad20">
      <PhoneTemplate v-if="touchTypeDict[data.type]" :title="touchTypeDict[data.type].previewMobileTitle">
        <template v-if="data.type == 0">
          <div class="mask" style="position: absolute">
            <div class="cc ac g-card g-pad20" style="width: 70%">公众号文章示例</div>
          </div>
        </template>
        <div v-else class="g-card g-pad20 cc ac" style="width: 70%; padding-bottom: 50px">
          <!-- 个人小程序，企业小程序 -->
          <template v-if="[7, 9].includes(+data.type)">
            <div class="mt10">{{ data.name || '小程序' }}</div>
            <div class="mt20 mb20">
              <el-image style="width: 120px; height: 120px" :src="data.avatar"></el-image>
            </div>
            <el-button type="primary">点击打开{{ data.name || '小程序' }}</el-button>
          </template>
          <template v-else>
            <!-- 员工活码，客群活码-->
            <div v-if="[4, 5].includes(+data.type)" class="mt10">{{ data.name || '活码名称' }}</div>

            <div v-else class="al bfc-o">
              <el-image class="fl mr10" style="width: 50px; height: 50px" :src="data.avatar" fit="fit"></el-image>
              <div class="toe">{{ data.name || '名称' }}</div>
              <div class="tips mt20 toe">{{ data.describe || '描述' }}</div>
            </div>

            <el-image style="width: 120px; height: 120px; margin: 20px 0" :src="data.qrCode" fit="fit"></el-image>
            <div class="mt20">长按二维码{{ touchTypeDict[data.type].previewMobileTitle }}</div>
          </template>
        </div>
      </PhoneTemplate>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
