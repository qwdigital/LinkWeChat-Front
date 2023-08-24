<!-- 搜索查询、清空按钮 -->
<script>
export default {
  props: { search: { type: Function }, reset: { type: Function } },
  // data() {
  //   return {}
  // },
  // computed: {},
  // watch: {},
  // created() {},
  // mounted() {},
  // methods: {},
}
</script>

<template>
  <div class="SearchClearButton bfc-d">
    <el-button type="primary" @click="search">查询</el-button>
    <el-button @click="reset(), search(1)">重置</el-button>
  </div>
</template>

<style lang="scss" scoped></style>
