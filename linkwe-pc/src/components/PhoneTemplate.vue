<template>
  <div class="preview">
    <div class="preview-title">{{ title }}</div>
    <div class="preview-content">
      <slot />
    </div>
  </div>
</template>
<script>
export default {
  components: {},
  props: {
    title: {
      type: String,
      default: '小微',
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
  margin: 0 auto;
  padding: 0 10px;
  position: relative;
  width: 300px;
  height: 640px;
  background: url(../assets/drainageCode/preview-bg.png);
  background-repeat: no-repeat;
  background-size: 100% 100%;

  .preview-title {
    position: absolute;
    top: 37px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 14px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #333333;
  }

  .preview-content {
    position: relative;
    height: 545px;
    overflow-y: auto;
    top: 70px;
    // left: 50%;
    // transform: translateX(-50%);
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 20px;
  }
}
</style>
