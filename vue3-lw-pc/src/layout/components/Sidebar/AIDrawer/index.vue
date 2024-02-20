<script>
import { getDetail, getCollectList, closeConnect, sendMsg } from './api'
import { useZIndex } from 'element-plus'

export default {
  components: {
    History: defineAsyncComponent(() => import('./History')),
    MessageList: defineAsyncComponent(() => import('./MessageList')),
    ScrollLoadList: defineAsyncComponent(() => import('@/components/ScrollLoadList')),
  },
  data() {
    return {
      getDetail,
      getCollectList,
      useZIndex: 0,
      active: '0',
      loading: false,
      sessionId: undefined,
      keywords: '',
      list: [
        // { text: '我想问一下LinkWeChat是什么？', role: 'user' },
        // {
        //   text: 'LinkWeChat 是基于企业微信的开源 SCRM 系统，前端采用 vue3 架构，后端采用主流的 Java 微服务架构，是企业私域流量管理与营销的综合解决方案，助力企业提高客户运营效率，强化营销能力，拓展盈利空间。',
        //   sendTime: '2023-11-25 17:19:50',
        // },
      ],
      answer: { text: '', sendTime: '' },
    }
  },
  computed: {},
  watch: {
    '$store.AIDrawer'(val) {
      val && (this.useZIndex = useZIndex().nextZIndex())
    },
  },
  created() {},
  mounted() {},
  methods: {
    createDialog() {
      // this.loading = true
      closeConnect(this.sessionId)
      this.keywords = ''
      this.sessionId = ''
      this.list = []
      // createConnect().then((res) => {
      //   debugger
      //   console.log(res)
      // })
    },
    send(v) {
      // v == 1 &&
      //   setTimeout(() => {
      //     this.send()
      //   }, 15000)

      // this.keywords = this.keywords.trim().replace(/^\n/, '')
      if (!this.keywords) return

      this.loading = true
      this.list.push({ text: this.keywords, role: 'user' })
      let answer = this.answer
      this.list.push(answer)
      let finish = false
      let scrollEl = this.$refs.scroll.$refs.scroll
      this.$nextTick(() => (scrollEl.scrollTop = scrollEl.scrollHeight))
      sendMsg({ sessionId: this.sessionId, msg: { content: this.keywords, role: 'user' } }, ({ code, data, msg }) => {
        if (finish) return
        if (code == 200) {
          answer.text = ''
          data?.forEach?.((element, index) => {
            // v !== 1 && console.log('element?.event', element, element?.event)
            if (element?.event == 'msg') {
              try {
                answer.text += element.data?.choices?.[0]?.delta?.content + ''
                this.$nextTick(() => (scrollEl.scrollTop = scrollEl.scrollHeight))
                if (element.data?.choices?.[0]?.finishReason == 'stop') {
                  // console.log(element.data?.choices?.[0]?.finishReason)
                  answer.sendTime = new Date().toLocaleString()
                  answer.msgId = element.data?.id
                  this.keywords = ''
                  this.loading = false
                  this.answer = { text: '', sendTime: '' }
                  this.sessionId = data?.[0]?.data
                  finish = true
                }
              } catch (error) {
                // console.log(error)
              }
            }
          })
        } else {
          this.loading = false
          answer.text = '回答失败'
          this.msgError(msg)
          this.answer = { text: '', sendTime: '' }
          finish = true
        }
      })
    },
  },
}
</script>

<template>
  <el-drawer
    v-model="$store.AIDrawer"
    title="AI 助手"
    append-to-body
    :z-index="useZIndex"
    :close-on-click-modal="false"
    :close-on-press-escape="false">
    <template #default>
      <div class="main">
        <el-tabs v-model="active" @tab-click="(v) => v.paneName == 0 && (list = [])">
          <el-tab-pane label="AI 对话" name="0"></el-tab-pane>
          <el-tab-pane label="历史对话" name="1"></el-tab-pane>
          <el-tab-pane label="我的收藏" name="2"></el-tab-pane>
        </el-tabs>

        <!-- <template v-if="active == 0">
          <MessageList v-if="!sessionId" isDefault :list="list"></MessageList>
        </template> -->
        <ScrollLoadList
          ref="scroll"
          v-if="active == 0"
          :params="{ sessionId, pageSize: 1000 }"
          :isQuery="false"
          :request="getDetail"
          :disabled="!sessionId || !!list?.length"
          finishedText=""
          key="1">
          <template #list="{ list: _list }">
            <MessageList isDefault :list="_list.concat(list)"></MessageList>
          </template>
          <template #empty>
            <span></span>
          </template>
        </ScrollLoadList>

        <History v-if="active == 1"></History>

        <ScrollLoadList v-if="active == 2" :params="{ collection: 1 }" :request="getCollectList" key="2">
          <template #list="{ list }">
            <MessageList :list="list"></MessageList>
          </template>
        </ScrollLoadList>
      </div>
    </template>
    <template #footer v-if="active == 0">
      <div class="footer bfc-o" v-loading="loading">
        <el-button class="mb10 fl" type="primary" plain @click="createDialog">新建对话</el-button>
        <el-input
          class="textarea"
          type="textarea"
          v-model="keywords"
          placeholder="请您输入问题，shift +（左）回车换行，回车发送"
          :maxlength="200"
          :show-word-limit="false"
          :autosize="{ minRows: 1 }"
          @keydown.enter.exact.prevent
          @keyup.enter.exact="send"
          @input="(val) => (keywords = val.trim().replace(/(^\n|\n$)/, ''))"></el-input>
        <el-button class="send" :type="!keywords ? 'info' : 'primary'" :disabled="!keywords" @click="send(1)">
          发送
        </el-button>
      </div>
    </template>
  </el-drawer>
</template>

<style lang="scss" scoped>
.main {
  height: 100%;
  overflow: auto;
  display: flex;
  flex-direction: column;
}

::v-deep.textarea {
  .el-textarea__inner {
    resize: none;
    padding: 15px calc(50px + 10px * 2) 15px 10px;
  }
}
.send {
  position: absolute;
  bottom: 10px;
  right: 10px;
  width: 50px;
}
</style>
