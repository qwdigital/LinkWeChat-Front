<template>
  <div>
    <!-- 基础素材 -->
    <!-- <div class="g-card" style="padding: 10px"> -->
    <el-tabs v-model="activeName" @tab-click="(v) => opened.includes(v.paneName) || opened.push(v.paneName)">
      <el-tab-pane v-for="(item, index) in list" :key="index" :label="item.label" :name="item.name">
        <component v-if="opened.includes(item.name)" :is="item.component"></component>
      </el-tab-pane>
    </el-tabs>
    <!-- </div> -->
  </div>
</template>

<script>
import Marticle from './article'
import Mvideo from './video'
import Mfile from './file'
import Mposter from './poster'

export default {
  name: '',
  components: {
    Marticle,
    Mvideo,
    Mfile,
    Mposter,
  },
  data() {
    return {
      activeName: 'article',
      list: [
        { label: '文章', name: 'article', component: Marticle },
        { label: '视频', name: 'video', component: Mvideo },
        { label: '文件', name: 'file', component: Mfile },
        { label: '海报', name: 'poster', component: Mposter },
      ],
      opened: ['article'],
    }
  },
  created() {
    this.$store.setBusininessDesc(
      `
      <div>支持智能记录客户访问行为，辅助运营把握客户动向。</div>
    `,
    )
    let activeName = this.$route.query.activeName
    if (activeName) {
      this.activeName = activeName
      this.opened = ['poster']
    }
  },
}
</script>

<style></style>
