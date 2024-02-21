<script>
import { wxQrLogin } from '@/api/login'
import { getQueryValue } from '@/utils/index'
import { setToken } from '@/utils/auth'

export default {
  async beforeRouteEnter(to, from, next) {
    // http://106.13.201.219/?auth_code=xxx#/authWehatCallback
    // console.log('routerbeforeCreate', this.$route);
    document.getElementById('loader-wrapper').classList.remove('loaded')
    let auth_code = getQueryValue('code')
    try {
      let { data } = await wxQrLogin(auth_code)
      setToken(data.access_token)
      // 用以重置浏览器回调的url
      history.replaceState({}, 'page', window.lwConfig.BASE_URL)
      next((vm) => {
        vm.$router.replace(window.lwConfig.BASE_URL)
      })
      // location.href = window.lwConfig.BASE_URL
    } catch (error) {
      document.getElementById('loader-wrapper').classList.add('loaded')
      console.log(error)
    }
  },
}
</script>

<template>
  <div></div>
</template>
