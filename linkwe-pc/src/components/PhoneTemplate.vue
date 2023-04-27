// 手机端背景框组件
<template>
  <div class="preview">
    <!-- <div class="preview-status">
      <div>13:14</div>
    </div> -->
    <div class="line"></div>
    <div class="preview-bar" v-if="isTab">
      <i class="icon el-icon-arrow-left"></i>
      {{ title }}
      <i class="icon el-icon-more"></i>
    </div>
    <el-scrollbar class="preview-content" wrap-class="scrollbar-wrapper">
      <template>
        <slot />
        <!-- <div class="bottom">看到底啦~</div> -->
      </template>
    </el-scrollbar>
    <div class="line2"></div>
  </div>
</template>
<script>
export default {
  components: {},
  props: {
    // 是否显示顶部tab标题栏
    isTab: {
      type: Boolean,
      default: true,
    },
    title: {
      type: String,
      default: 'LinkWeChat',
    },
  },
  data() {
    return {}
  },
  computed: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>
<style lang="scss" scoped>
.preview {
  display: flex;
  flex-direction: column;
  margin: 0 auto;
  position: relative;
  width: var(--phone-width, 350px);
  max-width: 375px;
  min-width: 320px;
  height: 720px;
  border: 12px solid #edf2f9;
  border-radius: 40px;
  box-sizing: content-box;
  overflow: hidden;
  background: #fff;
  // .preview-status {
  //   display: flex;
  //   justify-content: space-between;
  //   align-items: center;
  //   padding: 0 10px;
  // }
  .icon {
    font-size: 16px;
  }
  .line {
    flex: none;
    width: 100px;
    height: 25px;
    margin: 6px auto;
    border-radius: 50px;
    background: #bbb;
    // border: 10px solid #bbb;
    // box-sizing: content-box;
    // border-width: 13px 62px;
  }
  .line2 {
    position: absolute;
    width: 120px;
    height: 5px;
    bottom: 0;
    left: 50%;
    margin: 15px auto;
    border-radius: 10px;
    background: #bbb;
    transform: translateX(-50%);
    z-index: 10;
  }

  .preview-bar {
    // position: absolute;
    // top: 40px;
    // left: 50%;
    // transform: translateX(-50%);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 10px;
    height: 40px;
    width: 100%;
    flex: none;
    font-size: 14px;
    font-weight: 500;
    color: #333333;
  }

  .preview-content {
    position: relative;
    flex: auto;
    overflow: hidden;
    top: 0;
    // left: 50%;
    // transform: translateX(-50%);
    border-radius: 0 0 20px 20px;
    background: #f6f8ff;
    ::v-deep img {
      max-width: 100%;
    }
  }

  ::v-deep {
    .el-scrollbar__wrap {
      overflow-x: hidden;
    }
    .el-scrollbar__bar {
      transform: scale(1);
    }
  }
  .bottom {
    padding: 15px 0 20px;
    line-height: 1;
    color: #999;
    text-align: center;
  }
}
</style>
