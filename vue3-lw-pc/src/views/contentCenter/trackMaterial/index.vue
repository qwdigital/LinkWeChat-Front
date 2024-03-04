<template>
  <div>
    <!-- 轨迹素材 -->
    <CacheElTabs v-model="activeName" #="{ opened }">
      <el-tab-pane v-for="(item, index) in list" :key="index" :label="item.label" :name="item.name">
        <component v-if="opened.includes(item.name)" :is="item.component"></component>
      </el-tab-pane>
    </CacheElTabs>
  </div>
</template>

<script>
import OutChain from './outChain'
import Marticle from './article'
import Mvideo from './video'
import Mfile from './file'
import Mposter from './poster'
export default {
  name: '',
  components: {
    // OutChain,
    // Marticle,
    // Mvideo,
    // Mfile,
    // Mposter,
  },
  data() {
    return {
      activeName: this.$route.query.activeName || 'outChain',
      list: [
        { label: '外链', name: 'outChain', component: OutChain },
        { label: '文章', name: 'article', component: Marticle },
        { label: '视频', name: 'video', component: Mvideo },
        { label: '文件', name: 'file', component: Mfile },
        { label: '海报', name: 'poster', component: Mposter },
      ],
    }
  },
  methods: {},
  created() {
    this.$store.setBusininessDesc(
      `
      <div>支持智能记录客户访问行为，辅助运营把握客户动向。</div>
    `,
    )
  },
}
</script>

<style></style>
