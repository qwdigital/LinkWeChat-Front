<template>
  <div style="display: flex">
    <div class="preview">
      <div class="title">LinkWeChat</div>
      <div class="content">
        <div class="item">
          <div class="avatar222"><img src="@/assets/drainageCode/header.png" /></div>
          <div class="bg_con">
            【短链推广】
            <p style="margin-top: 10px">您有一条新的短链推广任务，请打开链接，进入任务页，分享短链内容给客户。</p>
            <div style="margin-top: 10px">
              <a class="self_a">{{ title }}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="preview" style="margin-left: 20px">
      <div class="title">{{ title }}</div>
      <div class="content">
        <div style="width: 80%; height: 380px; margin: 20px auto">
          <template v-if="!value">
            <div class="code_content">
              <img class="code_img" src="@/assets/drainageCode/code.png" alt="" />
            </div>
            <!-- <div class="sub-des">长按识别二维码添加好友</div> -->
          </template>
          <template v-else>
            <img style="width: 100%" v-if="value" :src="value" alt="" />
          </template>
        </div>
        <div style="width: 80%; margin: 10px auto">
          <el-button style="width: 100%" type="primary">分享给客户</el-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'short-link-preview-type-4',
  components: {},
  props: {
    name: {
      type: String,
      default: '短链推广',
    },
    title: {
      type: String,
      default: '',
    },
    value: {
      type: String,
      default: '',
    },
  },
  watch: {
    value(val) {
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
.self_a {
  color: #07c160;
  text-decoration: underline;
  &:hover {
    opacity: 0.8;
  }
}
.bg_con {
  padding: 10px 20px;
  background-color: #f2eeee;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 400;
  color: var(--font-black);
}
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
      margin-top: 100px;
      text-align: center;
      .code_img {
        height: 180px;
        width: 180px;
        margin: 10px auto;
      }
    }
    .item {
      font-size: 12px;

      font-weight: 400;
      color: var(--font-black-4);
      display: flex;
      margin-top: 20px;
      padding: 20px;
      &:first-child {
        margin-top: 0;
      }
      .avatar222 {
        // align-self: center;
        margin-right: 5px;
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
