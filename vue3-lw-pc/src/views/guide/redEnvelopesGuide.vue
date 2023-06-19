<template></template>

<script>
export default {
  methods: {
    popstate() {
      this.$msgbox.close()
    },
  },

  created() {
    window.addEventListener('popstate', this.popstate, false)
  },
  //   unmounted() {
  //     window.removeEventListener("popstate", this.popstate, false);
  //   },
  mounted() {
    let pageroute = this.$route.query.page
    if (pageroute === 'weAppParam') {
      this.$alert(
        `如需使用${lwConfig.SYSTEM_NAME}红包功能，请先前往<管理中心-授权管理-企业授权>配置公众号参数与微信支付参数。否则无法使用红包功能。`,
        '提示',
        {
          confirmButtonText: '确定',
          showClose: false,
          callback: (action) => {
            sessionStorage.setItem('currentActive', '4')
            this.$router.push({
              name: window.lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME,
            })
          },
        },
      )
    } else if (pageroute === 'chatParam') {
      this.$alert(
        `如需使用${lwConfig.SYSTEM_NAME}会话存档功能，请先前往<管理中心-授权管理-企业授权>配置“会话存档”参数。否则无法使用【会话存档】功能。`,
        '提示',
        {
          confirmButtonText: '确定',
          showClose: false,
          callback: (action) => {
            sessionStorage.setItem('currentActive', '3')
            this.$router.push({
              name: window.lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME,
            })
          },
        },
      )
    }
  },
}
</script>

<style lang="scss" scoped>
.red-envelopes-guide {
  img {
    width: 100%;
  }
}
</style>
