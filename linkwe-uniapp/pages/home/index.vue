<template>
  <view class="content">
    <view class="navgite">
      <image class="logo" src="/static/logo.png"></image>
    </view>
    <swiper :autoplay="true" interval="3000" duration="1000" :circular="true" previous-margin="36rpx"
      easing-function="linear">
      <swiper-item v-for="(item, index) in swiperList" :key="index">
        <view class="swiper-item">
          <image :src="item" />
        </view>
      </swiper-item>
    </swiper>
    <view class="about-us">
      <view class="text-title">
        关于我们
      </view>
      <view class="text-area">
        合肥仟微网络科技有限公司致力于互联网多领域软件应用开发、客户端开发、服务端开发、手机软件开发方向。仟微科技坚持以技术创新为核心，以用户需求为导向，关注用户体验，顺应市场发展方向，努力成为国内领先的互联网应用开发服务商，为企业客户提供最专业的应用产品开发支持和解决方案。仟微科技旗下自主产品目前已在政务、医疗、营销及电商等十多个行业落地。仟微科技团队成员来自腾讯科技、有赞科技等知名互联网企业，并拥有各自擅长的专业领域，同时拥有丰富的互联网工作及软件开发经验，为客户提供最优质的服务。
      </view>
    </view>
    <view class="partner">
      <view class="text-title">
        企业文化
      </view>
      <view class="corporate-culture-content">
        <view class="left">
          <text>我们的使命</text>
          <text>以开源为源动力，以企业私域增长为核心，把客户当做合作伙伴，互创影响力，实现共同增长</text>
        </view>
        <view class="left">
          <text>我们的愿景</text>
          <text>让每个合作伙伴都成为私域增长专家</text>
        </view>
        <view class="left">
          <text>我们的价值观</text>
          <ul>
            <li><text>开源开放</text><text>坚持创新</text></li>
            <li><text>成就客户</text><text>互创价值</text></li>
          </ul>
        </view>
      </view>
    </view>
    <!-- <u-button type="primary" shape="circle" @click="finishRename">联系我们</u-button> -->
    <view class="call-us" @click="show = true">
      联系我们
    </view>
    <u-popup :show="show" @close="close" @open="open" mode="center" :round="8">
      <view class="popClass">
        <view class="text-title">联系我们</view>
        <u-cell-group>
          <u-cell title="联系邮箱：xiarui1@linkwechat.cn" arrow-direction="down">
            <u-icon slot="icon" size="28" name="email-fill"></u-icon>
          </u-cell>
          <u-cell title="公司地址：安徽省合肥市高新区创新产业园二期J2栋C座24楼A-2403" arrow-direction="down">
            <u-icon slot="icon" size="28" name="map-fill"></u-icon>
          </u-cell>
        </u-cell-group>
      </view>
    </u-popup>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        swiperList: ['/static/banner1.png', '/static/banner2.png', '/static/banner3.png'],
        show: false,
      }
    },
    onLoad() {

    },
    methods: {
      close() {
        this.show = false
      },
      open() {}

    }
  }
</script>

<style lang="scss" scoped>
  .popClass {
    width: 300px;
    padding: 10px;
    padding-bottom: 30px;

  }

  .call-us {
    width: 60%;
    height: 60rpx;
    text-align: center;
    line-height: 60rpx;
    cursor: pointer;
    background-color: #3e95ef;
    color: #fff;
    font-size: 18rpx;
    margin: 40rpx 0;
    border-radius: 6px;
  }

  .content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    .navgite {
      width: 100%;
      display: flex;
      justify-content: space-between;
      padding: 20rpx 40rpx;

      .user {
        width: 60rpx;
        height: 60rpx;
        // background-color: #3e95ef;
        border-radius: 40rpx;
        margin-right: 20rpx;
        border: 1px solid #3e95ef;
      }
    }
  }

  .logo {
    width: 400rpx;
    height: 60rpx;
    // margin-right: auto;
    // margin-bottom: 50rpx;
  }

  .text-area {
    display: flex;
    justify-content: center;
    margin: 20rpx;
    padding: 40rpx;
    font-size: 20rpx;
    line-height: 40rpx;
    width: 80%;
    background: #ffffff;
    box-shadow: 0px 8px 26px 1px rgba(0, 0, 0, 0.08);
    border-radius: 4px 4px 4px 4px;
    border: 1px solid #f4f4f4;
    margin-top: 40rpx;
  }

  .partner {
    width: 100%;

    .corporate-culture-content {
      display: flex;
      flex-direction: column;
      align-items: center;
      width: 100%;

      .left {
        width: 80%;
        height: 118px;
        border-radius: 4rpx 4rpx 4rpx 4rpx;
        background-image: url("/static/m-3.png");
        background-size: 100%;
        background-repeat: no-repeat;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        margin-bottom: 10rpx;

        text:nth-child(1) {
          color: #ffffff;
          line-height: 60rpx;
          font-size: 28rpx;
        }

        text:nth-child(2) {
          max-width: 265px;
          display: block;
          font-weight: normal;
          color: #ffffff;
          text-align: center;
          font-size: 18rpx;
          font-family: PingFang SC-中等, PingFang SC;
          line-height: 34rpx;
        }
      }

      .left:nth-of-type(2) {
        background-image: url("/static/m-2.png");
      }

      .left:nth-of-type(3) {
        background-image: url("/static/m-3.png");

        ul {
          width: 36.5%;

          li {
            display: flex;
            justify-content: space-between;

            text {
              font-size: 18rpx;
              font-family: PingFang SC-中等, PingFang SC;
              font-weight: normal;
              color: #ffffff;
              line-height: 40rpx;
            }
          }
        }
      }
    }
  }

  .title {
    font-size: 36rpx;
    color: #8f8f94;
  }

  .text-title {
    margin: 20rpx;
    font-size: 16px;
    color: #2b2d3a;
    text-align: center;
    width: 100%;
    margin-top: 40rpx;
    margin-bottom: 40rpx;
  }

  swiper {
    // width: 726rpx;
    width: 100%;
    height: 200rpx;
    overflow: hidden;
    margin-top: 20rpx;

    .swiper-item {
      width: 684rpx;
      height: 200rpx;

      image {
        width: 100%;
        height: 100%;
      }
    }
  }
</style>
