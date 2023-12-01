<template>
  <PhoneTemplate>
    <template v-if="!value">
      <!-- <div class="tip">
          {{ value.outOfRangeTip }}
        </div> -->
      <div class="code_content">
        <!-- <img class="code_img" src="../../../assets/drainageCode/no_code.svg" alt="" /> -->
        <img class="code_img" src="@/assets/drainageCode/code.png" alt="" />
      </div>
      <!-- <div class="sub-des">长按识别二维码添加好友</div> -->
    </template>
    <template v-else>
      <img style="width: 100%" v-if="value" :src="value" alt="" />
    </template>
  </PhoneTemplate>
</template>
<script>
export default {
  name: 'short-link-preview-in-phone',
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
</style>
