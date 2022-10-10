import Vue from 'vue'
import '@/assets/icons' // icon
import 'normalize.css/normalize.css'

import Vant, { Dialog, Toast } from 'vant'
import 'vant/lib/index.less'
Vue.use(Vant)
// import { color } from './styles/varibles.less'
Dialog.setDefaultOptions({
  title: '系统提示',
  width: '68vw',
  //  confirmButtonColor: color
})
Toast.setDefaultOptions('loading', {
  message: '加载中...',
  forbidClick: true,
  loadingType: 'spinner',
  duration: 0,
})

import '@/styles/index.less' // global css

import './config'

import { stringifyError } from '@/utils/index'
stringifyError()

import App from './App.vue'
import router from './router'
import store from './store'

import VConsole from 'vconsole'
window.lwConfig.IS_VCONSOLE && new VConsole()

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount('#app')
