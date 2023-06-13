<template>
  <div>
    <el-dialog title="查看详情" :close-on-click-modal="false" :show-close="false" v-model="Pvisible">
      <el-tabs v-model="activeTab" @tab-click="(v) => opened.includes(v.paneName) || opened.push(v.paneName)">
        <el-tab-pane v-for="(item, index) of list" :key="index" :label="item.label" :name="item.type">
          <chatListClassTab
            v-if="opened.includes(item.type)"
            :queryChat="queryChat"
            :type="item.type"></chatListClassTab>
        </el-tab-pane>
      </el-tabs>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="Pvisible = false">关 闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import chatListClassTab from './component/chatListClassTab.vue'
export default {
  name: 'ChatList',
  components: { chatListClassTab },

  props: {
    visible: {
      type: Boolean,
      default: false,
    },
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
    // Pvisible(val) {
    //   this.selectList = this.defaultValues
    // }
  },
  computed: {
    Pvisible: {
      get() {
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      },
    },
  },
}
</script>
