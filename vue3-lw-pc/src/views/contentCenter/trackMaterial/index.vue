<template>
  <div>
    <!-- 基础素材 -->
    <!-- <div class="g-card" style="padding: 10px"> -->
    <el-tabs v-model="activeName" @tab-click="tabClick">
      <el-tab-pane v-for="(item, index) in list" :key="index" :label="item.label" :name="item.name">
        <component v-if="opened.includes(item.name)" :is="item.component"></component>
      </el-tab-pane>
    </el-tabs>
    <!-- </div> -->
  </div>
</template>

<script>
import OutChain from './outChain'
import Marticle from './article'
import Mvideo from './video'
import Mfile from './file'
import Mposter from './poster'
let activeTab = ''
export default {
  name: '',
  components: {
    OutChain,
    Marticle,
    Mvideo,
    Mfile,
    Mposter,
  },
  data() {
    return {
      activeName: activeTab,
      list: [
        { label: '外链', name: 'outChain', component: OutChain },
        { label: '文章', name: 'article', component: Marticle },
        { label: '视频', name: 'video', component: Mvideo },
        { label: '文件', name: 'file', component: Mfile },
        { label: '海报', name: 'poster', component: Mposter },
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
      <div>支持智能记录客户访问行为，辅助运营把握客户动向。</div>
    `
    )
    let activeName = this.$route.query.activeName
    if (activeName) {
      this.activeName = activeName
      this.opened = ['poster']
    } else {
      let first = 'outChain'
      activeTab || (this.activeName = activeTab = first)
      this.opened.push(activeTab)
    }
  },
}
</script>

<style></style>
