<template>
  <div class="takecontent">
    <ul>
      <li v-for="(item, index) in data" :key="index">
        <div class="mb15 my_header right" v-if="queryChat.fromId === item.fromId">
          <span :style="{ color: item.action == 'send' ? 'var(--color)' : '#999' }">{{ item.msgTime }}</span>
          <span class="ml10">{{ item.name }}</span>
          <img v-if="item.avatar" class="image" style="margin-left: 10px" :src="item.avatar" />
          <img v-else style="margin-left: 10px" src="../../../../assets/drainageCode/header.png" />
        </div>
        <div v-else class="mb15 my_header">
          <img v-if="item.avatar" class="image" :src="item.avatar" />
          <img v-else style="margin-right: 5px" src="../../../../assets/drainageCode/header.png" />
          <span class="mr10">{{ item.name }}</span>
          <span :style="{ color: item.action == 'send' ? 'var(--color)' : '#999' }">{{ item.msgTime }}</span>
        </div>
        <div class="right" v-if="queryChat.fromId === item.fromId">
          <ChatContent :queryChat="queryChat" :message="item"></ChatContent>
        </div>
        <div v-else>
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
  mounted() {},
  data() {
    return {}
  },
  methods: {},
}
</script>
<style lang="scss" scoped>
.right {
  display: flex;
  justify-content: flex-end;
}
.my_header {
  display: flex;
  align-items: center;
}
.image {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  margin-right: 5px;
}
.shabowbox {
  position: fixed;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.4);
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
  background: #fff;
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
  color: #fff;
  cursor: pointer;
  font-size: 43px;
}

.takecontent {
  border-radius: 3px;
  background-color: #eee;
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
