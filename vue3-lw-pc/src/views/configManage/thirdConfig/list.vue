<template>
  <div>
    <CacheElTabs #="{ active, opened }">
      <el-tab-pane v-for="(item, key) in tabs" :key="key" :label="item" :name="key">
        <component :is="'part' + key" :ref="'part' + key" :data="form"></component>
      </el-tab-pane>
    </CacheElTabs>
    <div class="g-footer-sticky">
      <el-button type="primary" v-loading="loading" @click="submit">保存配置</el-button>
    </div>
  </div>
</template>
<script>
import * as api from '@/api/enterpriseId'
export default {
  components: {
    part0: defineAsyncComponent(() => import('./part0.vue')),
  },
  props: {},
  data() {
    return {
      active: this.$route.query.index || '0',
      tabs: {
        0: 'AI 配置',
      },
      form: {},
      loading: false,
    }
  },
  watch: {},
  computed: {},
  created() {
    this.getDetail()
  },
  mounted() {},
  methods: {
    getDetail() {
      this.loading = true
      api
        .getDetail()
        .then(({ data }) => {
          this.form = data
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    submit() {
      this.$refs['part' + this.active]?.[0]?.submit().then(() => {
        this.loading = true
        api
          .addOrUpdate(data)
          .then(() => {
            this.msgSuccess()
            this.getDetail()
          })
          .finally(() => {
            this.loading = false
          })
      })
    },
  },
}
</script>

<style lang="scss" scoped></style>
