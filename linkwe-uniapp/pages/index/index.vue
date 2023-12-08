<template>
  <view class="content">
    <!-- <template v-if="data.type == 0">
      <div class="mask" style="position: absolute">
        <web-view :src="data.longLink"></web-view>
      </div>
    </template> -->
    <div class="cc ac" style="max-width: 68vw">
      <!-- 个人小程序，企业小程序 -->
      <template v-if="[7, 9].includes(+data.type)">
        <div class="">{{ data.name || '小程序' }}</div>
        <image
          style="width: 200px; height: 200px; display: block; margin: 20px auto 30px"
          :src="data.avatar"
          show-menu-by-longpress
          fit="fit"></image>
        <button class="" type="primary" @tap="open()">点击打开{{ data.name || '小程序' }}</button>
      </template>

      <template v-else>
        <!-- 员工活码，客群活码 门店导购活码 门店群活码 -->
        <div v-if="[4, 5, 6, 8].includes(+data.type)" class="mt10">
          {{ data.name || touchTypeDict[data.type].name }}
        </div>

        <div v-else class="al bfc-o">
          <image class="fl mr10" style="width: 50px; height: 50px" :src="data.avatar" show-menu-by-longpress></image>
          <div class="toe">{{ data.name || '名称' }}</div>
          <div class="tips mt20 toe">{{ data.describe || '描述' }}</div>
        </div>

        <image style="width: 68vw; height: 68vw; margin: 20px 0 30px" :src="data.qrCode" show-menu-by-longpress></image>

        <div v-if="[5, 6, 8].includes(+data.type)" class="toe">长按二维码保存后，使用微信扫一扫打开</div>
        <div v-else class="">长按二维码{{ touchTypeDict[data.type].previewMobileTitle || '' }}</div>
      </template>
    </div>
    <!-- <canvas canvas-id="mycanvas" id="mycanvas" type="2d" style="width: 500px; height: 500px; display: none"></canvas> -->
  </view>
</template>

<script>
// const jsQR = require('jsqr')
import { getDetail } from './api'
import { touchTypeDict } from './mixin'

export default {
  data() {
    return {
      loading: false,
      data: {},
      touchTypeDict,
      id: '',
      promotionId: '',
      type: '',
      // qrCodeUrl: '',
    }
  },
  onLoad(options) {
    // console.log('onLoad options', options)
    this.id = options.id
    this.promotionId = options.promotionId
    this.type = options.sence
  },
  onReady() {
    this.getDetail(this.id + (this.promotionId ? '/' + this.promotionId : ''), this.type)
  },
  created() {
    // let id = this.$route.query.id
    // var pages = getCurrentPages()
    // var page = pages[pages.length - 1]
    // console.log('当前页面路由地址数据信息', page)
  },
  mounted() {},
  methods: {
    getDetail(path, type) {
      console.log('path', path)
      this.loading = true
      getDetail(path, type)
        .then(({ data }) => {
          // if ([5, 6].includes(+data.type)) {
          //   var query = uni.createSelectorQuery().in(this)
          //   query
          //     .select('#mycanvas')
          //     .fields({ node: true, size: true })
          //     .exec((res) => {
          //       var canvas = res[0].node
          //       // var ctx = uni.createCanvasContext('mycanvas', this)
          //       var ctx = canvas.getContext('2d')

          //       // Canvas 画布的实际绘制宽高
          //       const width = res[0].width
          //       const height = res[0].height

          //       // 初始化画布大小
          //       const dpr = wx.getWindowInfo().pixelRatio
          //       debugger
          //       canvas.width = width * dpr
          //       canvas.height = height * dpr
          //       // ctx.scale(1, 1)

          //       var img = canvas.createImage()
          //       img.onload = function () {
          //         ctx.drawImage(img, 0, 0)
          //         // canvas.toDataURL()
          //         var imageData = ctx.getImageData(0, 0, img.width, img.height)
          //         var code = jsQR(imageData.data, imageData.width, imageData.height, {})
          //         if (code) {
          //           console.log('code', code.data)
          //           this.qrCodeUrl = code.data
          //         } else {
          //           console.log('识别错误')
          //         }

          //         // uni.canvasGetImageData({
          //         //   mycanvas: 'mycanvas',
          //         //   x: 0,
          //         //   y: 0,
          //         //   width: img.width,
          //         //   height: img.height,
          //         //   success(imageData) {
          //         //     var code = jsQR(imageData.data, imageData.width, imageData.height, {
          //         //       inversionAttempts: 'dontInvert',
          //         //     })
          //         //     if (code) {
          //         //       console.log('code', code.data)
          //         //     } else {
          //         //       console.log('识别错误')
          //         //     }
          //         //   },
          //         // })
          //       }
          //       img.src = data.qrCode
          //     })
          // }

          if (type == 'qr') {
            data.type = 4
          } else if (type == 'gqr') {
            data.type = 5
            data.qrCode = data.codeUrl
          }
          this.data = data
          // console.log('data', data)
          uni.setNavigationBarTitle({
            title: touchTypeDict[data.type].previewMobileTitle,
            // title: data.shortLinkName
          })
        })
        .catch(() => {})
        .finally(() => {
          this.loading = false
        })
    },
    open() {
      wx.navigateToMiniProgram({
        appId: this.data.appId,
        path: this.data.longLink,
        // extraData: {
        //   foo: 'bar',
        // },
        // envVersion: 'develop',
        success(res) {
          // 打开成功
        },
      })
    },
    // copy() {
    //   uni.setClipboardData({
    //     data: this.data.longLink,
    //     success: function () {
    //       console.log('success')
    //     },
    //   })
    // },
  },
}
</script>

<style lang="scss" scoped></style>
