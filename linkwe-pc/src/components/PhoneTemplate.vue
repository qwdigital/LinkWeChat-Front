<template>
  <div class="preview">
    <div class="title">{{ name }}</div>
    <div class="content">
      <slot />
    </div>
  </div>
</template>
<script>
export default {
  components: {},
  props: {
    name: {
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
  position: relative;
  width: 300px;
  height: 640px;
  background: url(../assets/drainageCode/preview-bg.png);
  background-repeat: no-repeat;
  background-size: 100% 100%;

  .title {
    position: absolute;
    top: 37px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 14px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #333333;
  }

  .content {
    position: absolute;
    height: 545px;
    width: 280px;
    overflow-y: auto;
    top: 70px;
    left: 50%;
    transform: translateX(-50%);
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 20px;
    padding: 20px;
  }
}
</style>
