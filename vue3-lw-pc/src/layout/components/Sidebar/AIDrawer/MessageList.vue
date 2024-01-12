<script>
import { collect } from './api'
export default {
  name: '',
  props: {
    // 消息列表 根据text（文字），title（图文），image（图片）字段自动判断类型
    // 示例：[{ text: form.welcomeMsg || '请输入加群引导语' },{ title: form.linkTitle, desc: form.linkDesc, image: form.linkCoverUrl },]
    list: {
      type: Array,
      default: () => [],
    },
    isDefault: Boolean,
  },
  components: {},
  data() {
    return {}
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    collect(item) {
      collect({ msgId: item.msgId, status: item.collection == 1 ? 0 : 1 }).then(() => {
        this.msgSuccess((item.collection == 1 ? '取消' : '') + '收藏成功')
        item.collection = item.collection == 1 ? 0 : 1
      })
    },
  },
}
</script>

<template>
  <ul class="msg-ul">
    <li class="flex msg-li" v-if="isDefault && !list?.length">
      <div class="avatar fxnone"><svg-icon icon="custom-ai" /></div>

      <div class="msg">
        <slot>你好，我是你的AI助手，如果你有任何问题或者需要帮助的地方，请随时告诉我，我会尽力回答你的问题</slot>
      </div>
    </li>

    <template v-for="(item, index) in list" :key="index">
      <li class="flex msg-li">
        <div class="avatar fxnone me" v-if="item.role == 'user'">我</div>
        <div class="avatar fxnone" v-else><svg-icon icon="custom-ai" /></div>

        <div class="msg">
          <div v-if="!(item.text || item.image || item.title)">正在思考...</div>
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

          <div class="mt20" v-if="item.sendTime && item.role !== 'user'">（免责说明，API返回）</div>
          <div class="fxbw mt10" v-if="item.sendTime && item.role !== 'user'">
            <span class="msg-time">{{ item.sendTime }}</span>
            <div class="msg-action-icon">
              <el-icon-copy-document
                class="el-icon-copy-document mr10 cp"
                title="复制"
                @click="$copyText(item.text)"></el-icon-copy-document>
              <el-icon-star
                class="el-icon-star cp"
                :style="{ color: item.collection == 1 ? 'var(--color)' : '' }"
                @click="collect(item)"></el-icon-star>
            </div>
          </div>
        </div>
      </li>
    </template>
  </ul>
</template>

<style lang="scss" scoped>
.msg-ul {
  margin: 0;
  overflow: auto;
  padding: 0 10px;
}
.msg-li {
  margin-bottom: 20px;
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
}
.avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  color: var(--font-white);
  background: var(--color);
  font-size: 20px;
  &.me {
    background: var(--font-black-7);
    font-size: 16px;
    font-weight: 700;
  }
}
.msg-time {
  color: var(--font-black-6);
}
.msg-action-icon {
  color: var(--font-black-6);
  font-size: 16px;
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
