<script>
import Voice from '@/components/Voice'
import { parseTime } from '@/utils/common.js'
import { emotion } from '@/utils/index.js'
export default {
  name: 'ChatContent',
  props: {
    message: {
      type: Object,
      default: () => ({}),
    },
    queryChat: {
      type: Object,
      default: () => ({}),
    },
  },
  components: { Voice, BaiduMap: defineAsyncComponent(() => import('@/components/common/BaiduMap')) },
  data() {
    return {}
  },
  computed: {
    content() {
      let typeDict = {
        text: 'content',
        image: 'attachment',
        emotion: 'attachment',
        file: 'filename',
        docmsg: 'title',
        video: 'attachment',
        voice: 'attachment',
        location: 'address',
        weapp: 'title',
      }
      let attr = typeDict[this.message.msgType]
      if (attr) {
        return JSON.parse(this.message.contact)[typeDict[this.message.msgType]]
      } else {
        return JSON.parse(this.message.contact)
      }
    },
  },
  watch: {},
  created() {},
  mounted() {},
  methods: {
    setIndex(str) {
      return emotion.findIndex((dd) => dd === str)
    },
    setDate(str) {
      return parseTime(str)
    },
  },
}
</script>

<template>
  <div :class="message.fromId === queryChat.fromId ? 'message-right' : 'message'">
    <template v-if="message.msgType === 'text'">
      <template v-if="setIndex(JSON.parse(message.contact).content) == -1">
        <div>
          {{ content }}
        </div>
      </template>
      <img
        v-else
        :src="`https://res.wx.qq.com/mpres/htmledition/images/icon/emotion/${setIndex(
          JSON.parse(this.message.contact).content,
        )}.gif`"
        alt="" />
    </template>
    <template v-else-if="message.msgType === 'revoke'">已撤回</template>
    <template v-else-if="'image,emotion'.includes(message.msgType)">
      <el-image style="width: 100px" :src="content" fit="fill" :preview-src-list="[content]"></el-image>
    </template>
    <a v-else-if="'file'.includes(message.msgType)" class="msgtypefile">
      <!-- :href="JSON.parse(this.message.contact).attachment"
      target="_black" -->
      {{ content }}
    </a>
    <a
      v-else-if="'docmsg'.includes(message.msgType)"
      class="msgtypefile"
      :href="JSON.parse(this.message.contact).link_url"
      target="_black">
      {{ content }}
    </a>
    <div v-else-if="message.msgType === 'voice'" class="ac">
      <voice :amrUrl="JSON.parse(message.contact)['attachment']"></voice>
      <div style="font-size: 12px">语音消息</div>
    </div>
    <div v-else-if="message.msgType === 'meeting_voice_call'" class="ac">
      <voice :amrUrl="JSON.parse(message.contact)['attachment']"></voice>
      <span style="font-size: 12px" v-if="JSON.parse(message.contact)['endtime']">
        语音通话-结束时间：{{ setDate(JSON.parse(message.contact)['endtime']) }}
      </span>
    </div>
    <template v-else-if="message.msgType === 'video'">
      <video
        id="video"
        class="video-js vjs-default-skin vjs-big-play-centered"
        controls
        webkit-playsinline="true"
        playsinline="true"
        :autoplay="false"
        preload="none"
        style="height: 100%; width: 100%">
        <source :src="content" type="video/mp4" />
      </video>
    </template>
    <div v-else-if="message.msgType === 'location'" class="msgtypecard">
      <div class="card-content">
        <BaiduMap
          isDetail
          isOnlyShowMap
          mapWidth="300px"
          mapHeight="120px"
          :initData="JSON.parse(message.contact)"></BaiduMap>
      </div>
      <div class="card-foot">{{ content }}</div>
    </div>
    <div v-else-if="message.msgType === 'weapp'" class="msgtypecard">
      <div class="card-content">{{ content }}</div>
      <div class="card-foot">小程序</div>
    </div>
    <div v-else-if="message.msgType === 'card'" class="msgtypecard">
      <div class="card-content">
        <span style="flex: none">{{ content.corpname }}：</span>
        <span>
          {{ content.userid }}
        </span>
      </div>
      <div class="card-foot">个人名片</div>
    </div>
    <!-- 图文链接 -->
    <div v-else-if="message.msgType === 'link'" class="msgtypecard">
      <a target="_black" :href="content.link_url">
        <div class="card-content fxbw">
          <div style="flex: 1; margin-right: 10px">
            <div class="card--link-title">{{ content.title }}</div>
            <div class="card--link-desc">{{ content.description }}</div>
          </div>
          <el-image style="width: 50px; height: 50px" :src="content.image_url" fit="fill"></el-image>
        </div>
      </a>
    </div>
    <div v-else-if="message.msgType === 'agree'">客户已同意会话存档</div>
    <div v-else-if="message.msgType === 'disagree'">客户不同意会话存档</div>
    <div v-else>不支持的消息类型：{{ message.msgType }}</div>
  </div>
</template>

<style lang="scss" scoped>
// .angle {
//   content: '';
//   display: inline-block;
//   position: absolute;
//   top: 8px;
//   width: 8px;
//   height: 8px;
//   background: var(--bg-white);
//   transform: rotate(45deg);
//   border: 1px solid var(--color-light-9);
//   z-index: 888;
//   box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
// }
.mes {
  max-width: calc(100% - 24px);
  position: relative;
  padding: 15px;
  line-height: 14px;
  border-radius: 12px;
  // box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
  // border: 1px solid var(--color-light-9);
  display: inline-block;
  word-break: break-all;
}

.message {
  @extend .mes;
  color: var(--font-black);
  margin-left: 10px;
  background: var(--bg-white);
  border-top-left-radius: 0;
  // &::before {
  //   @extend .angle;
  //   left: -5px;
  //   border-width: 0 0 1px 1px;
  // }
}
.message-right {
  @extend .mes;
  color: var(--font-white, #fff);
  margin-right: 10px;
  background-color: var(--color);
  border-top-right-radius: 0;
  // &::before {
  //   @extend .angle;
  //   right: -5px !important;
  //   border-width: 1px 1px 0 0;
  // }
}
.msgtypefile {
  margin: 5px;
  width: 200px;
  display: inline-block;
  line-height: 30px;
  cursor: pointer;
  color: var(--color);
  // text-indent: 10px;
  // box-shadow: 0 1px 4px 0 rgba(0, 0, 0, 0.2), 0 1px 4px 0 rgba(0, 0, 0, 0.19);
}

.msgtypecard {
  // width: 320px;
  // height: 140px;
  // margin: 10px 5px;
  border-radius: 8px;
  -webkit-box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 8px 0 rgba(0, 0, 0, 0.19);
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 8px 0 rgba(0, 0, 0, 0.19);
  position: relative;
  background: var(--bg-black-11);
  overflow: hidden;

  .card-content {
    width: 250px;
    height: 100%;
    display: flex;
    align-items: center;
    padding: 10px;
    line-height: 1.5;
    // text-indent: 10px;
    color: var(--font-black);
    z-index: -1;
    .card--link-title {
      font-size: 15px;
      font-weight: 500;
      margin-bottom: 5px;
      text-overflow: -o-ellipsis-lastline;
      overflow: hidden;
      text-overflow: ellipsis;
      word-break: break-all;
      display: -webkit-box;
      white-space: pre-wrap;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
    }
    .card--link-desc {
      font-size: 13px;
      color: var(--font-black-4);
      text-overflow: -o-ellipsis-lastline;
      overflow: hidden;
      text-overflow: ellipsis;
      word-break: break-all;
      display: -webkit-box;
      white-space: pre-wrap;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
    }
  }
  .card-foot {
    border-top: 1px solid var(--border-black-10);
    text-align: left;
    padding: 10px;
    color: var(--font-black);
    font-weight: bold;
    width: 100%;
  }
}
</style>
