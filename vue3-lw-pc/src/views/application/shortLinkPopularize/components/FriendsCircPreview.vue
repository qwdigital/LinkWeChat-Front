<template>
  <div class="preview">
    <!-- <div class="title">{{ name }}</div> -->
    <div class="content">
      <div class="header_bg">
        <img class="header" src="../assets/header_b.png" alt="" />
      </div>
      <div class="header_con">
        <div class="img">
          <div>
            <img width="32px" src="../assets/header_a.png" alt="" />
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
    </div>
  </div>
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
.preview {
  margin: 0 auto;
  position: relative;
  width: 300px;
  height: 640px;
  background: url(../../../../assets/drainageCode/preview-bg.png);
  background-repeat: no-repeat;
  background-size: 100% 100%;

  .title {
    position: absolute;
    top: 37px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 14px;

    font-weight: 400;
    color: #333333;
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
          color: #191919;
        }
        .code_img {
          height: 140px;
          width: 140px;
          margin: 5px auto;
        }
      }
    }
  }
}
.sub-des {
  text-align: center;
  font-size: 12px;

  font-weight: 400;
  color: #999999;
}
</style>
