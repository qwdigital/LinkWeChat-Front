<template>
  <div class="home">
    <div class="logo ac">linkWeChat</div>
    <template v-if="isShow">
      <router-link
        class="router-link"
        v-for="(item, index) in $router.options.routes"
        :to="item.path"
        :key="index"
        >{{ item.meta.title }}</router-link
      >
    </template>
    <div v-else class="cc">
      {{ tips }}
    </div>
  </div>
</template>

<script>
// @ is an alias to /src

export default {
  name: 'Home',
  components: {},
  data() {
    return {
      isShow: process.env.NODE_ENV === 'development',
      tips: '',
    }
  },
  created() {
    if (location.hash.indexOf('redPacketReceive') && !navigator.userAgent.indexOf('Mobile')) {
      this.tips = '请在手机端微信打开'
    } else {
    }
  },
}
</script>

<style lang="less" scoped>
.logo {
  margin: 0 auto;
  width: 150px;
  height: 50px;
  line-height: 50px;
  border: 2px solid #6582ff;
  border-radius: 50px;
}
.router-link {
  display: block;
  text-align: center;
  line-height: 40px;
}
</style>
