<template>
  <div class="preview">
    <div class="title">{{ name }}</div>
    <div class="content">
      <template v-if="!value">
        <div class="tip">
          {{ value.outOfRangeTip }}
        </div>
        <div class="code_content">
          <!-- <img class="code_img" src="../../../assets/drainageCode/no_code.svg" alt="" /> -->
          <img class="code_img" src="../../../assets/drainageCode/code.png" alt="" />
        </div>
        <div class="sub-des">长按识别二维码添加好友</div>
      </template>
      <template v-else>
        <img style="width: 100%" v-if="value" :src="value" alt="" />
      </template>
    </div>
  </div>
</template>
<script>
export default {
  name: 'preview-client-identity',
  components: {},
  props: {
    name: {
      type: String,
      default: '识客活码',
    },
    value: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      pro: 1,
      store: 1,
    }
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
  background: url(../../../assets/drainageCode/preview-bg.png);
  background-repeat: no-repeat;
  background-size: 100% 100%;

  .title {
    position: absolute;
    top: 37px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 14px;

    font-weight: 400;
    color: var(--font-black);
  }

  .content {
    // text-align: center;
    position: absolute;
    height: 545px;
    width: 280px;
    overflow-y: auto;
    top: 70px;
    left: 50%;
    transform: translateX(-50%);
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 20px;
    .tip {
      font-size: 12px;
      margin-top: 30px;
      text-align: center;
    }
    .code_content {
      margin-top: 10px;
      text-align: center;
      .code_img {
        height: 180px;
        width: 180px;
        margin: 10px auto;
      }
    }
  }
}
.sub-des {
  text-align: center;
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
