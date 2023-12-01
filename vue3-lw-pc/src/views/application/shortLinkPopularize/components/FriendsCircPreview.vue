<template>
  <PhoneTemplate>
    <div class="header_bg">
      <img class="header" src="@/assets/image/header_b.png" alt="" />
    </div>
    <div class="header_con">
      <div class="img">
        <div>
          <img width="32px" src="@/assets/image/header_a.png" alt="" />
        </div>
        <div class="name">运营部-小王</div>
      </div>
      <div class="circle_con">
        <div class="word">
          {{ value }}
        </div>
        <div>
          <img class="code_img" v-if="poster" :src="poster" alt="" />
          <img v-else class="code_img" src="@/assets/drainageCode/code.png" alt="" />
        </div>
      </div>
    </div>
  </PhoneTemplate>
</template>
<script>
export default {
  name: 'short-link-preview-type-3',
  components: {},
  props: {
    name: {
      type: String,
      default: '短链推广',
    },
    value: {
      type: String,
      default: '',
    },
    poster: {
      type: String,
      default: '',
    },
  },
  watch: {
    value(val) {
      // this.$forceUpdate()
    },
    poster() {
      // this.$forceUpdate()
    },
  },
  data() {
    return {
      list: [],
    }
  },
  created() {},
  mounted() {},
  methods: {},
}
</script>

<style lang="scss" scoped>
.header_bg {
  height: 200px;
  background-color: #cdf3df;
  position: relative;
  .header {
    height: 48px;
    width: 48px;
    position: absolute;
    bottom: -25px;
    right: 16px;
  }
}
.header_con {
  padding: 0 20px;
  margin-top: 60px;
  .img {
    display: flex;
    align-items: center;
    .name {
      margin-left: 10px;
      font-size: 14px;
      font-weight: 600;
      color: #596c94;
    }
  }
  .circle_con {
    margin-left: 42px;
    // margin-top: 10px;
    .word {
      font-size: 14px;
      font-weight: 400;
      color: var(--font-black);
    }
    .code_img {
      height: 140px;
      width: 140px;
      margin: 5px auto;
    }
  }
}
</style>
