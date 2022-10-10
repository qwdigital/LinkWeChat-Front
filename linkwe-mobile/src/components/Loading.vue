<template>
  <van-overlay :show="isLoad" @click="show = false" z-index="999">
    <div class="popup">
      <div class="pop-box">
        <div class="pop-box-bg"></div>
        <div class="pop-box-content">
          <!-- <img src="@/assets/lodash.png" alt="" /> -->
          <svg-icon class="lodash-icon" name="lodash"></svg-icon>
          <span>数据查询中，请稍后...</span>
        </div>
      </div>
    </div>
  </van-overlay>
</template>

<script>
export default {
  props: {
    isLoad: {
      type: Boolean,
      default: false,
    },
  },
};
</script>

<style lang="less" scoped>
.popup {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  .pop-box {
    width: 310px;
    height: 110px;
    background: #ffffff;
    border-radius: 12px 12px 12px 12px;
    position: relative;
    .pop-box-bg {
      width: 100%;
      height: 100%;
      background: #0079de;
      opacity: 0.1;
    }
    .pop-box-content {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      display: flex;
      flex-direction: column;
      align-items: center;
      .lodash-icon {
        width: 22px;
        height: 22px;
        margin-bottom: 20px;
      }
      @keyframes turnZ {
        0% {
          transform: rotateZ(0deg);
        }

        100% {
          transform: rotateZ(360deg);
        }
      }
      .lodash-icon {
        animation-name: turnZ;

        animation-duration: 1.5s;

        animation-timing-function: linear;

        animation-iteration-count: infinite;
      }
      span {
        font-size: 13px;
        font-family: "PingFang SC-中等", "PingFang SC";
        font-weight: normal;
        color: #999999;
        line-height: 12px;
      }
    }
  }
}
</style>
