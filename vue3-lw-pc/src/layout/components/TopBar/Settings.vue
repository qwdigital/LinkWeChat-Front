<template>
  <div class="pl20">
    <!-- <h3 class="drawer-title">系统布局配置</h3> -->

    <div class="drawer-item">
      <span class="mr20">主题颜色</span>
      <el-color-picker
        v-model="theme"
        @active-change="themeActiveChange"
        color-format="hsl"
        :predefine="['#409EFF', '#1890ff', '#304156', '#212121', '#11a983', '#13c2c2', '#6959CD', '#f5222d']" />
    </div>

    <div class="drawer-item">
      <span class="mr20">主题辅色</span>
      <el-color-picker
        v-model="themeSub"
        @active-change="themeSubActiveChange"
        color-format="hsl"
        :predefine="['#409EFF', '#1890ff', '#304156', '#212121', '#11a983', '#13c2c2', '#6959CD', '#f5222d']" />
    </div>
    <!-- <div class="drawer-item">
      <span>开启 Tags-Views</span>
      <el-switch v-model="tagsView" class="drawer-switch" />
    </div>

    <div class="drawer-item">
      <span>固定 Header</span>
      <el-switch v-model="fixedHeader" class="drawer-switch" />
    </div>

    <div class="drawer-item">
      <span>显示 Logo</span>
      <el-switch v-model="sidebarLogo" class="drawer-switch" />
    </div> -->

    <div class="mt10">
      <el-button type="primary" @click="cancel">取消</el-button>
      <el-button @click="reset">重置</el-button>
    </div>
  </div>
</template>

<script>
export default {
  components: {},
  data() {
    return {
      theme: getComputedStyle(document.documentElement).getPropertyValue('--color'),
      themeSub: getComputedStyle(document.documentElement).getPropertyValue('--color-sub'),
      themeOld: this.theme,
      themeSubOld: this.themeSub,
    }
  },
  computed: {
    // fixedHeader: {
    //   get() {
    //     return this.$store.settings.fixedHeader
    //   },
    //   set(val) {
    //     this.$store.changeSetting({
    //       key: 'fixedHeader',
    //       value: val,
    //     })
    //   },
    // },
    // tagsView: {
    //   get() {
    //     return this.$store.settings.tagsView
    //   },
    //   set(val) {
    //     this.$store.changeSetting({
    //       key: 'tagsView',
    //       value: val,
    //     })
    //   },
    // },
    // sidebarLogo: {
    //   get() {
    //     return this.$store.settings.sidebarLogo
    //   },
    //   set(val) {
    //     this.$store.changeSetting({
    //       key: 'sidebarLogo',
    //       value: val,
    //     })
    //   },
    // },
  },
  created() {
    this.themeOld = this.theme
    this.themeSubOld = this.themeSub
  },
  methods: {
    themeActiveChange(val) {
      val || (val = this.themeOld)
      if (val) {
        let [h, s, l] = val
          .slice(4, -1)
          .split(',')
          .map((e) => e.trim())
        // let l1 = l.slice(0, -1) - 5 // 主题色明暗度减5%即为深主题色
        let style = document.documentElement.style
        style.setProperty('--h', h)
        style.setProperty('--s', s)
        style.setProperty('--l', l)
        // style.setProperty('--hsl', `${h},${s},${l}`)
        // l1 && style.setProperty('--hsl-dark', `${h},${s},${l1}%`)

        localStorage.hsl = `${h},${s},${l}`
      }
    },
    themeSubActiveChange(val) {
      val || (val = this.themeSubOld)
      if (val) {
        let style = document.documentElement.style
        style.setProperty('--color-sub', val)
        localStorage.colorSub = val
      }
    },
    // 恢复默认主题
    reset() {
      let style = document.documentElement.style
      style.removeProperty('--h')
      style.removeProperty('--s')
      style.removeProperty('--l')
      // style.removeProperty('--hsl')
      // style.removeProperty('--hsl-dark')
      style.removeProperty('--color-sub')
      localStorage.hsl = ''
      localStorage.colorSub = ''
    },
    // 恢复上一次主题
    cancel() {
      this.themeActiveChange(this.themeOld)
      this.themeSubActiveChange(this.themeSubOld)
    },
  },
}
</script>

<style lang="scss" scoped>
.drawer-title {
  margin-bottom: 12px;
  color: var(--font-black-2);
  font-size: 14px;
  line-height: 22px;
}

.drawer-item {
  color: var(--font-black-5);
  font-size: 14px;
  padding: 0 0 12px;
}

.drawer-switch {
  float: right;
}
</style>
