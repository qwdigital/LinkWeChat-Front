<template>
  <div class="takecontent">
    <ul id="123">
      <li v-for="(item, index) in data" :key="index" :id="item.msgId">
        <div :class="['mb10', queryChat.fromId === item.fromId && 'ar']">
          <span :class="['', queryChat.fromId === item.fromId && 'fr']" style="color: #4e5969">{{ item.name }}</span>
          <span :style="{ color: item.action == 'send' ? '#86909C' : '#999', margin: '0 8px' }">
            {{ item.msgTime }}
          </span>
        </div>
        <div :class="[queryChat.msgId === item.msgId && 'line-height', queryChat.fromId === item.fromId && 'ar']">
          <img
            :class="['image', queryChat.fromId === item.fromId && 'fr']"
            :src="item.avatar || '@/assets/image/profile.jpg'" />
          <ChatContent :queryChat="queryChat" :message="item"></ChatContent>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import ChatContent from '@/components/ChatContent'
export default {
  components: {
    ChatContent,
  },
  props: {
    data: {
      type: Array,
      defluat: () => [],
    },
    queryChat: {
      type: Object,
      default: () => ({}),
    },
  },
  mounted() {
    this.$nextTick(() => {
      setTimeout(() => {
        document.getElementById(this.queryChat.msgId).scrollIntoView({ behavior: 'smooth', block: 'center' })
      }, 300)
    })
  },
  data() {
    return {}
  },
  methods: {},
}
</script>
<style lang="scss" scoped>
.line-height {
  padding: 5px;
  border-radius: 8px 8px 8px 8px;
  background: var(--bg-white);
}
.image {
  width: 40px;
  height: 40px;
  vertical-align: top;
  box-shadow: 0px 6px 8px 0px rgba(78, 89, 105, 0.3);
  border-radius: 8px 8px 8px 8px;
  border: 1px solid var(--border-white);
  background: var(--bg-white);
}
.shabowbox {
  position: fixed;
  width: 100%;
  height: 100%;
  background: var(--bg-black-6);
  left: 0;
  top: 0;
  z-index: 2000;
}

.shabowboxvidoe {
  position: fixed;
  width: 800px;
  height: 475px;
  left: 50%;
  margin-left: -400px;
  top: 50%;
  margin-top: -235px;
  z-index: 2001;
  background: var(--bg-white);
}

.shabowboxaudio {
  height: 125px;
  padding: 12px;
}

.close {
  position: fixed;
  width: 50px;
  height: 50px;
  right: 10px;
  z-index: 2012;
  top: 10px;
  text-align: center;
  line-height: 50px;
  font-size: 20px;
  color: var(--font-white, #fff);
  cursor: pointer;
  font-size: 43px;
}

.takecontent {
  border-radius: 3px;
  background-color: var(--bg-black-9);
  position: relative;
  text-align: left;
  height: 100%;
  width: 100%;
  overflow-y: scroll;

  ::-webkit-scrollbar {
    display: none;
  }

  ul li {
    padding: 10px;
  }
}
</style>
