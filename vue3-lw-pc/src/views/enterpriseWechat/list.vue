<template>
  <div>
    <CacheElTabs v-model="active">
      <el-tab-pane v-for="(item, key) in tabs" :key="key" :label="item" :name="key">
        <component :is="'part' + key" :ref="'part' + key" @submit="submit" :data="form" :initData="welcome"></component>
      </el-tab-pane>
    </CacheElTabs>
    <div class="g-footer-sticky">
      <el-button type="primary" @click="$refs['part' + active]?.[0]?.submit()">保存配置</el-button>
    </div>
  </div>
</template>
<script>
import * as api from '@/api/enterpriseId'
import part1 from './part1.vue'
import part2 from './part2.vue'
// import part3 from './part3.vue'
import part4 from './part4.vue'
import part5 from './part5.vue'
// import part6 from './part6.vue'
import part7 from './part7.vue'
import part8 from './part8.vue'
export default {
  components: {
    part1,
    part2,
    // part3,
    part4,
    part5,
    // part6,
    part7,
    part8,
  },
  props: {},
  data() {
    return {
      active: this.$route.query.index || '1',
      tabs: {
        1: '基础配置',
        2: '应用配置',
        // 3: '客服配置',
        4: '支付配置',
        5: '公众号配置',
        // 6: '直播配置',
        7: '小程序配置',
        8: '欢迎语配置',
      },
      form: {},
      loading: false,
      welcome: [],
    }
  },
  watch: {},
  computed: {},
  created() {
    this.getDetail()
  },
  mounted() {},
  methods: {
    submit(data) {
      if (this.active == 8) {
        api.setWecomeTemplate(data).then(() => {
          this.msgSuccess('操作成功')
          this.getDetail()
        })
      } else {
        api
          .addOrUpdate(data)
          .then(() => {
            this.msgSuccess('操作成功')
            // this.dialogVisible = false
            this.getDetail()
          })
          .catch(() => {
            // this.dialogVisible = false
          })
      }
    },
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
      api.getWecomeTemplate().then(({ data }) => {
        this.welcome = data
      })
    },

    // start(corpId) {
    //   api.start(corpId).then(({ rows, total }) => {
    //     this.msgSuccess('操作成功')
    //     this.getList()
    //   })
    // },
  },
}
</script>

<style lang="scss" scoped>
.tips {
  color: var(--font-black-7);
  font-size: 12px;
}
</style>
