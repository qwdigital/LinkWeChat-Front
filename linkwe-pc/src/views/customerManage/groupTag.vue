<script>
import List from './tag/list'
export default {
  name: '',
  components: { List },
  data() {
    return {
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {}
}
</script>

<template>
  <div>
    <List type="2"></List>
  </div>
</template>

<style lang="scss" scoped>
::v-deep.el-tabs__header {
  margin-bottom: 0;
}
</style>
