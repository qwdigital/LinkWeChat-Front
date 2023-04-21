// 手机端背景框组件
<template>
  <div class="preview">
    <div class="line"></div>
    <div class="preview-bar" v-if="isTab">
      <i class="el-icon-arrow-left"></i>
      {{ title }}
      <i class="el-icon-more"></i>
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
  width: var(--phone-width);
  max-width: 375px;
  min-width: 320px;
  height: 750px;
  border: 15px solid #ddd;
  border-radius: 40px;
  box-sizing: content-box;
  overflow: hidden;
  background: #fff;
  .line {
    flex: none;
    width: 65px;
    height: 6px;
    margin: 0 auto 6px;
    border-radius: 0 0 50px 50px;
    background: #eee;
    border: 10px solid #333;
    box-sizing: content-box;
    border-width: 13px 62px;
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
    background: #f8f8f8;
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
