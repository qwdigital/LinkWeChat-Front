<template>
  <div id="app">
    <router-view class="app-view" />

    <!-- 这里使用和index.html同样的loading，无缝衔接 -->
    <div id="loader-wrapper">
      <div id="loader"></div>
      <div class="loader-section section-left"></div>
      <div class="loader-section section-right"></div>
      <div class="load_title">正在加载系统资源，请耐心等待</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style scoped>
.app-view + #loader-wrapper {
  display: none;
}
</style>
