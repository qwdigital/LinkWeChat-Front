<template>
  <view class="content">
    <template v-if="data.type == 0">
      <div class="mask" style="position: absolute">
        <web-view :webview-styles="webviewStyles" :src="data.longLink"></web-view>
      </div>
    </template>
    <template v-else-if="[7, 9].includes(+data.type)">
      <div class="g-card g-pad20 cc ac" style="width: 70%">
        <div class="">{{ data.name || '小程序' }}</div>
        <div class="mt20 mb20">
          <image style="width: 150px; height: 150px" :src="data.avatar" show-menu-by-longpress fit="fit"></image>
        </div>
        <button type="primary" @tap="open()">点击打开{{ data.name || '小程序' }}</button>
      </div>
    </template>
    <template v-else>
      <div class="g-card g-pad20 cc ac" style="width: 70%">
        <div class="al bfc-o">
          <image class="fl mr10" style="width: 50px; height: 50px" :src="data.avatar" show-menu-by-longpress fit="fit">
          </image>
          <div class="toe">{{ data.name || '无名称' }}</div>
          <div class="tips mt20 toe">{{ data.describe || '无描述' }}</div>
        </div>
        <image style="width: 180px; height: 180px; margin: 20px 0" :src="data.qrCode" show-menu-by-longpress fit="fit">
        </image>
        <div class="mt20">长按二维码{{ touchTypeDict[data.type].previewMobileTitle }}</div>
      </div>
    </template>
  </view>
</template>

<script>
  import {
    getDetail
  } from '@/api/intelligentShortLink'
  import {
    touchTypeDict
  } from './mixin'

  export default {
    data() {
      return {
        loading: false,
        data: {},
        touchTypeDict,
      }
    },
    onLoad(options) {
      console.log('onLoad options', options); // 场景值为 1065﻿
      this.getDetail(options.id)
    },
    created() {
      // let id = this.$route.query.id
      // var pages = getCurrentPages()
      // var page = pages[pages.length - 1]
      // console.log('当前页面路由地址数据信息', page)
    },
    methods: {
      getDetail(path) {
        console.log('path', path)
        this.loading = true
        getDetail(path)
          .then(({
            data
          }) => {
            this.data = data
            console.log('data', data)
            uni.setNavigationBarTitle({
              // title: touchTypeDict[data.type].previewMobileTitle,
              title: data.shortLinkName
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
          extraData: {
            foo: 'bar',
          },
          envVersion: 'develop',
          success(res) {
            // 打开成功
          },
        })
      },
    },
  }
</script>

<style lang="scss" scoped></style>
