<script setup lang="js">
const props = defineProps({
  data: {
    type: Object,
    default: () => ({})
  }
})
</script>

<template>
  <div class="g-card">
    <div class="g-card-title">
      二维码
      <span class="desc">适用于海报、线下及微信生态等场景</span>
    </div>
    <div class="ac">
      <el-image :src="data.qrCode" style="width: 160px"></el-image>
      <br />
      <el-button text @click="downloadBlob(data.qrCode, data.name + '.png', 'image')">下载二维码</el-button>
    </div>
  </div>
  <div class="g-card">
    <div class="g-card-title">
      H5链接
      <span class="desc">适用于按钮、活动分享等场景</span>
    </div>
    <div class="flex">
      <el-input v-model="data.qrCode" disabled></el-input>
      <el-button class="ml10" @click="$copyText(data.qrCode)" text>复制</el-button>
    </div>
  </div>
  <div class="g-card">
    <div class="g-card-title">
      <span class="fxnone">智能短链</span>
      <span class="desc">适用于从微信外部的公域平台获客场景</span>
    </div>
    <div class="flex">
      <el-input v-model="data.qrShortLink" disabled></el-input>
      <el-button class="ml10" @click="$copyText(data.qrShortLink)" text>复制</el-button>
    </div>
    <div class="g-tip">
      注：必须在管理中心->企微配置->小程序配置中配置短链小程序，
      <el-button text @click="$router.push({ name: lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME, query: { index: 7 } })">
        去配置
      </el-button>
    </div>
  </div>
</template>

<style lang="scss" scoped></style>
