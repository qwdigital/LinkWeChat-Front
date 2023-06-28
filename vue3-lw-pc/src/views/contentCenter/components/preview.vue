<template>
  <div class="content-box">
    <!-- 文章 -->
    <div>
      <div class="title">{{ contentObj.materialName }}</div>
      <p v-html="contentObj.content"></p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      contentObj: {},
      show: false,
    }
  },
  created() {
    this.show = true
    this.contentObj = JSON.parse(decodeURIComponent(this.$route.query.obj))
  },
  methods: {},
}
</script>

<style lang="scss" scoped>
.content-box {
  padding: 10px;
  padding-top: 20px;
}
.title {
  width: 100%;
  text-align: center;
  color: var(--font-black);
  font-size: 16px;
  margin-bottom: 20px;
}
.pic {
  width: 100%;
  margin: 20px 0;
}
.content {
  color: var(--font-black);
  font-size: 12px;
  line-height: 16px;
}
</style>
