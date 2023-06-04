<template>
  <div>
    <div class="top mb10">
      <span class="name" v-if="queryChat">与 {{ queryChat.receiveName }} 的聊天</span>
      <span class="fr download" @click="exportList()">下载会话</span>
    </div>
    <el-tabs v-model="activeTab" @tab-click="(v) => opened.includes(v.paneName) || opened.push(v.paneName)">
      <el-tab-pane v-for="(item, index) of list" :key="index" :label="item.label" :name="item.type">
        <chatListClassTab v-if="opened.includes(item.type)" :queryChat="queryChat" :type="item.type"></chatListClassTab>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import chatListClassTab from './chatListClassTab.vue'
import { dateFormat } from '@/utils/index'

import * as api from '@/api/conversation/content.js'
export default {
  components: { chatListClassTab },
  props: {
    queryChat: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      activeTab: 'all',
      opened: ['all'],
      list: [
        {
          label: '全部',
          type: 'all',
        },
        {
          label: '图片及视频',
          type: 'image,video',
        },
        {
          label: '文件',
          type: 'file',
        },
        {
          label: '链接',
          type: 'link',
        },
        {
          label: '语音',
          type: 'voice,meeting_voice_call',
        },
      ],
    }
  },
  watch: {
    queryChat() {
      this.opened = ['all']
      this.activeTab = 'all'
    },
  },
  mounted() {},
  methods: {
    exportList() {
      this.$confirm('是否确认导出所有数据项?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return api.exportList(this.queryChat)
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' })

          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '会话存档')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_会话存档.xlsx' //指定下载文件名
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
        })
        .catch(function (err) {
          console.log(err)
        })
    },
  },
}
</script>
<style lang="scss" scoped>
::v-deep .el-tabs__header {
  margin: 0;
}

.name {
  font-size: 16px;
  font-weight: 600;
}

.download {
  color: var(--color);
  text-align: right;
  font-size: 16px;
  cursor: pointer;
  &:hover {
    opacity: 0.7;
  }
}
</style>
