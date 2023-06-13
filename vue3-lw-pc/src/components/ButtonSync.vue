<script>
export default {
  name: 'ButtonSync',
  emits: ['click'],
  props: {
    customeBtn: {
      type: Boolean,
      default: false,
    },
    lastSyncTime: {
      type: [String, Number],
      default: 0,
    },
  },
  components: {},
  data() {
    return {}
  },
  computed: {
    disabled() {
      // return this.lastSyncTime ? (+new Date() - +new Date(this.lastSyncTime)) / 3600000 < 2 : false
      return false
    },
  },
  watch: {},
  created() {},
  mounted() {},
  methods: {
    sync() {
      // if (this.disabled) {
      //   this.msgError('由于企业微信开放平台的限制，两小时内不得重复同步操作')
      //   return
      // }
      this.$emit('click')
    },
  },
}
</script>

<template>
  <div class="button-sync">
    <el-tooltip
      v-if="disabled"
      effect="light"
      class="item"
      content="由于企业微信开放平台的限制，两小时内不得重复同步操作"
      placement="top-start">
      <el-tag type="info" size="default"><slot></slot></el-tag>
    </el-tooltip>
    <div v-else v-preventReClick class="cp" @click="sync">
      <slot v-if="$slots.button" name="button"></slot>
      <el-button v-else type="primary">
        <slot></slot>
      </el-button>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.button-sync {
  display: inline-block;
}
</style>
