<script>
export default {
  components: {},
  props: {
    // 消息列表 根据text（文字），title（图文），image（图片）字段自动判断类型
    // 示例：[{ text: form.welcomeMsg || '请输入加群引导语' },{ title: form.linkTitle, desc: form.linkDesc, image: form.linkCoverUrl },]
    list: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {}
  },
  watch: {},
  computed: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>

<template>
  <PhoneTemplate class="PhoneDialog">
    <div class="time">13:14</div>

    <ul class="msg-ul">
      <li class="flex msg-li" v-if="$slots.default && Array.isArray($slots.default()[0].children)">
        <div class="avatar fxnone"><svg-icon icon="user" /></div>

        <div class="msg">
          <slot />
        </div>
      </li>

      <template v-for="(item, index) in list" :key="index">
        <li class="flex msg-li" v-if="item.text || item.image || item.title">
          <div class="avatar fxnone"><svg-icon icon="user" /></div>

          <div class="msg">
            <!-- 根据text（文字），title（图文），image（图片）字段自动判断类型 -->
            <!-- 文字 -->
            <span class="msg-text" v-if="item.text">{{ item.text }}</span>
            <!-- 图文 -->
            <slot v-else-if="item.title" name="imageText" :msg="item">
              <div class="msg-image-text">
                <div class="image-text-title">{{ item.title }}</div>
                <div class="image-text-content">
                  <div class="image-text-desc">{{ item.desc }}</div>
                  <el-image class="image-text-image fxnone" :src="item.image" fit="contain"></el-image>
                </div>
              </div>
            </slot>
            <!-- 图片 -->
            <el-image class="msg-image" v-else-if="item.image" :src="item.image" fit="contain" />
          </div>
        </li>
      </template>
    </ul>
  </PhoneTemplate>
</template>

<style lang="scss" scoped>
.time {
  font-size: 12px;
  color: var(--font-black-7);
  padding: 10px 0 5px;
  text-align: center;
}
.msg-ul {
  margin: 0;
  padding: 0;
  max-height: 80%;
  overflow: auto;
  padding: 0 10px;
}
.msg-li {
  margin-bottom: 10px;
}
.msg {
  min-height: 28px;
  background: var(--bg-white);
  border: 1px solid var(--border-black-9);
  display: inline-block;
  position: relative;
  text-align: left;
  font-size: 14px;
  line-height: 22px;
  padding: 6px 12px;
  border-radius: 4px;
  max-width: 80%;
  min-width: 24px;
  box-sizing: border-box;
  word-break: break-all;
  white-space: pre-line;
  margin-left: 10px;
  &:before {
    content: ' ';
    display: block;
    position: absolute;
    left: -6px;
    border-width: 4px 6px;
    border-left: 0;
    width: 0;
    border-style: solid;
    border-color: transparent;
    border-right-color: var(--border-white);
    top: 10px;
    z-index: 888;
  }
}
.avatar {
  border: 1px solid var(--border-white);
  background: var(--bg-white);
  border-radius: 6px;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.msg-image-text {
  .image-text-title {
    font-weight: 500;
  }
  .image-text-content {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    margin-top: 2px;
  }
  .image-text-desc {
    font-size: 12px;
    color: var(--font-black-6);
  }
  .image-text-image {
    width: 50px;
    height: 50px;
    border-radius: 6px;
    border: 1px solid var(--border-black-11);
  }
}
</style>
