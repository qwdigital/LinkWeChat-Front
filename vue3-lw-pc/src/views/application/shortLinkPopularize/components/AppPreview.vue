<template>
  <div style="display: flex">
    <PhoneDialog>
      <div>
        【短链推广】
        <p style="margin-top: 10px">您有一条新的短链推广任务，请打开链接，进入任务页，分享短链内容给客户。</p>
        <div style="margin-top: 10px">
          <a class="self_a">{{ title }}</a>
        </div>
      </div>
    </PhoneDialog>

    <PhoneTemplate class="g-margin-l" :title="title">
      <div style="width: 80%; height: 380px; margin: 20px auto">
        <template v-if="!value">
          <div class="code_content">
            <img class="code_img" src="@/assets/drainageCode/code.png" alt="" />
          </div>
          <!-- <div class="g-tips">长按识别二维码添加好友</div> -->
        </template>
        <template v-else>
          <img style="width: 100%" v-if="value" :src="value" alt="" />
        </template>
      </div>
      <div style="width: 80%; margin: 10px auto">
        <el-button style="width: 100%" type="primary">分享给客户</el-button>
      </div>
    </PhoneTemplate>
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
  color: var(--color);
  text-decoration: underline;
  &:hover {
    opacity: 0.8;
  }
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
</style>
