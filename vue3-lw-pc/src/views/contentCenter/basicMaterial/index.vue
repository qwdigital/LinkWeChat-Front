<template>
  <div>
    <!-- 基础素材 -->
    <!-- <div class="g-card" style="padding: 10px"> -->
    <el-tabs v-model="activeName" @tab-click="tabClick">
      {{ activeTab }}
      <el-tab-pane v-for="(item, index) in list" :key="index" :label="item.label" :name="item.name">
        <component v-if="opened.includes(item.name)" :is="item.component"></component>
      </el-tab-pane>
    </el-tabs>
    <!-- </div> -->
  </div>
</template>

<script>
import Mtext from './text'
import Mimage from './image'
import MimageText from './imageText'
import Mapplet from './applet'
let activeTab = ''
export default {
  name: '',
  components: {
    // Mtext,
    // Mimage,
    // MimageText,
    // Mapplet,
  },
  data() {
    return {
      activeName: activeTab,
      list: [
        { label: '文本', name: 'text', component: Mtext },
        { label: '图片', name: 'image', component: Mimage },
        { label: '图文', name: 'imageText', component: MimageText },
        { label: '小程序', name: 'applet', component: Mapplet },
      ],
      opened: [activeTab],
    }
  },
  methods: {
    tabClick(v) {
      activeTab = v.paneName
      this.opened.includes(v.paneName) || this.opened.push(v.paneName)
    },
  },
  created() {
    this.$store.setBusininessDesc(
      `
      <div>文本、图片等基础素材，可直接用于聊天话术、欢迎语等场景</div>
    `
    )
    let first = 'text'
    activeTab || (this.activeName = activeTab = first)
    this.opened.push(activeTab)
  },
}
</script>

<style></style>
