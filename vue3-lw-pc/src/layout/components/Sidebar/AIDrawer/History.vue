<script>
import { getList, getDetail, remove } from './api'
export default {
  name: '',
  components: {
    MessageList: defineAsyncComponent(() => import('./MessageList')),
    ScrollLoadList: defineAsyncComponent(() => import('@/components/ScrollLoadList')),
  },
  data() {
    return { getList, getDetail, loading: false, visiable: false, sessionId: '' }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    remove() {
      this.$confirm()
        .then(() => {
          this.loading = true
          return remove(this.sessionId)
        })
        .then((res) => {
          this.msgSuccess('删除成功')
          this.visiable = false
          this.sessionId = ''
          this.$refs.ScrollLoadList.getList(1)
        })
        .catch((e) => {
          console.error(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<template>
  <div class="History" style="" v-loading="loading">
    <ScrollLoadList v-show="!visiable" ref="ScrollLoadList" :request="getList" key="1">
      <template #item="{ item }">
        <div class="list-item g-margin-b" @click=";(visiable = true), (sessionId = item.sessionId)">
          <div class="title toe">{{ item.content }}</div>
          <div class="time">{{ item.sendTime }}</div>
        </div>
      </template>
    </ScrollLoadList>

    <ScrollLoadList v-if="visiable" ref="ScrollLoadList2" :params="{ sessionId }" :request="getDetail" key="2">
      <template #list="{ list }">
        <MessageList :list="list"></MessageList>

        <div class="footer sticky-b pad10 ar">
          <el-button class="" type="primary" plain @click="visiable = false">返回</el-button>
          <el-button class="" type="danger" plain @click="remove()">删除</el-button>
        </div>
      </template>
    </ScrollLoadList>
  </div>
</template>

<style lang="scss" scoped>
.History {
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
.list-item {
  background: var(--bg-black-10);
  padding: 10px;
  border-radius: var(--border-radius);
  .title {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 10px;
  }
  .time {
    color: var(--font-black-8);
  }
}
</style>
