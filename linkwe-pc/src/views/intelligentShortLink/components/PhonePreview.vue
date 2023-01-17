// 短链移动端样式预览
<script>
import { touchTypeDict } from './components/mixin'
export default {
  name: '',
  components: {},
  props: {
    data: {
      type: Object,
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
  <div>
    <div class="title">预览</div>

    <PhoneTemplate :title="touchTypeDict[data.touchType].previewMobileTitle">
      <template v-if="data.touchType == 0">
        <div class="mask" style="position: absolute">
          <div class="cc ac g-card g-pad20" style="width: 70%">公众号文章示例</div>
        </div>
      </template>
      <template v-else-if="[7, 9, 10].includes(+data.touchType)">
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
          <el-image style="width: 120px; height: 120px; margin: 20px 0" :src="url" :fit="fit"></el-image>
          <div class="mt20">长按二维码{{ touchTypeDict[data.touchType].previewMobileTitle }}</div>
        </div>
      </template>
    </PhoneTemplate>
  </div>
</template>

<style lang="scss" scoped></style>
