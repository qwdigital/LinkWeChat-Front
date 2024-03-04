<template>
  <view class="content">
    <view class="navgite">
      <image class="logo" src="/static/logo.png"></image>
    </view>
    <swiper
      :autoplay="true"
      interval="3000"
      duration="1000"
      :circular="true"
      previous-margin="36rpx"
      easing-function="linear">
      <swiper-item v-for="(item, index) in swiperList" :key="index">
        <view class="swiper-item">
          <image :src="item" />
        </view>
      </swiper-item>
    </swiper>
    <view class="about-us">
      <view class="text-title">SCRM</view>
    </view>
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
  onLoad() {},
  methods: {
    close() {
      this.show = false
    },
    open() {},
  },
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
      background-image: url('/static/m-3.png');
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
      background-image: url('/static/m-2.png');
    }

    .left:nth-of-type(3) {
      background-image: url('/static/m-3.png');

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
