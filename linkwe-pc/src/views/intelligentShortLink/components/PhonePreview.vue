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
        <template v-else-if="[7, 9, 10].includes(+data.type)">
          <div class="g-card g-pad20 cc ac" style="width: 80%">
            小程序
            <el-image style="width: 120px; height: 120px" :src="data.avatar" error="头像" fit="fit"></el-image>
            <el-button type="primary">点击打开小程序</el-button>
          </div>
        </template>
        <template v-else>
          <div class="g-card g-pad20 cc ac" style="width: 80%">
            <div class="al bfc-o">
              <el-image
                class="fl mr10"
                style="width: 50px; height: 50px"
                :src="data.avatar"
                error="头像"
                fit="fit"></el-image>
              <div class="toe">{{ data.name || '名称' }}</div>
              <div class="tips mt20 toe">{{ data.describe || '描述' }}</div>
            </div>
            <el-image style="width: 120px; height: 120px; margin: 20px 0" :src="data.qrCode" fit="fit"></el-image>
            <div class="mt20">长按二维码{{ touchTypeDict[data.type].previewMobileTitle }}</div>
          </div>
        </template>
      </PhoneTemplate>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
