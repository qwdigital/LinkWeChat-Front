<!-- 搜索查询、重置按钮 -->
<script>
export default {
  // props: {},
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
    <el-button type="primary" @click="$emit('search')">查询</el-button>
    <el-button @click="$emit('reset')">重置</el-button>
  </div>
</template>

<style lang="scss" scoped></style>
