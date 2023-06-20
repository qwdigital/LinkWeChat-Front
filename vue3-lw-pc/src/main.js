import '@/config.js'
import 'normalize.css/normalize.css'

import { createApp, h, defineAsyncComponent } from 'vue'
// configureCompat({
//   WATCH_ARRAY: false,
// })
import App from './App.vue'
import router from './router'

const app = createApp(App)

import ElementPlus, { ElNotification } from 'element-plus'
import 'element-plus/dist/index.css'
app.use(ElementPlus, {})

// import 'element-plus/theme-chalk/dark/css-vars.css'
// import { useDark, useToggle } from '@vueuse/core'
// useDark()

import '@/styles/index.scss'

// svg图标
import 'virtual:svg-icons-register'
import SvgIcon from '@/components/SvgIcon'
app.component('SvgIcon', SvgIcon)

import * as ElementPlusIconsVue from '@element-plus/icons-vue'
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component('ElIcon' + key, component)
}

// 全局异步组件挂载，
// 所有异步组件，在其父组件需要更改其样式时可能会导致同级权重css样式顺序覆盖问题，使用时需注意加权
let components = {
  Pagination: () => import('./components/Pagination.vue'),
  RightToolbar: () => import('./components/RightToolbar.vue'),
  Upload: () => import('./components/Upload.vue'),
  ButtonSync: () => import('./components/ButtonSync.vue'),
  TagEllipsis: () => import('./components/TagEllipsis.vue'),
  SelectUser: () => import('./components/SelectUser.vue'),
  SelectStaffForm: () => import('./components/SelectStaffForm.vue'),
  CoRemoteSelect: () => import('./components/CoRemoteSelect.vue'),
  PhoneTemplate: () => import('./components/PhoneTemplate.vue'),
  CardGroupIndex: () => import('./components/CardGroupIndex.vue'),
  TextareaExtend: () => import('./components/TextareaExtend.vue'), // 带 插入 表情/客户昵称 等扩展工具栏的文本内容框
}
for (const c in components) {
  app.component(c, defineAsyncComponent(components[c]))
}

// 全局方法挂载
import ClipboardJS from 'clipboard'
ClipboardJS.prototype.e = {
  success: [
    {
      fn() {
        ElNotification.success({
          title: '复制成功',
          // message: '链接已复制到剪切板，可粘贴。',
        })
      },
    },
  ],
  error: [
    {
      fn() {
        ElNotification.error({
          title: '复制失败',
          // message: '链接复制失败',
        })
      },
    },
  ],
}
import * as methods from '@/utils/common'
import { pickerOptions } from '@/utils/index'
Object.assign(app.config.globalProperties, methods, {
  // 动态配置
  lwConfig: window.lwConfig,
  // 日期时间控件快捷配置
  pickerOptions,
  ClipboardJS,
  msgSuccess(msg) {
    this.$message({
      showClose: true,
      message: msg,
      type: 'success',
    })
  },
  msgError(msg) {
    this.$message({ showClose: true, message: msg, type: 'error' })
  },
  msgInfo(msg) {
    this.$message.info(msg)
  },
})

// import VideoPlayer from 'vue-video-player'
// app.use(VideoPlayer)
// import AudioPlayer from '@liripeng/vue-audio-player'
// import '@liripeng/vue-audio-player/lib/vue-audio-player.css'

// app.use(AudioPlayer)

// import Driver from 'driver.js'
// import 'driver.js/dist/driver.min.css'
// app.config.globalProperties.$driver = new Driver({
//   className: 'scoped-class',
//   allowClose: false, //禁止点击外部关闭
//   doneBtnText: '完成', // 完成按钮标题
//   closeBtnText: '关闭', // 关闭按钮标题
//   stageBackground: '#fff', // 引导对话的背景色
//   nextBtnText: '下一步', // 下一步按钮标题
//   prevBtnText: '上一步', // 上一步按钮标题
//   keyboardControl: false, // 禁止键盘控制
//   // showButtons:false
// })

import directive from './directive'
app.use(directive)

import stores, { store } from '@/stores'

app.use(store)
app.use(router)
app.config.globalProperties.$store = stores()

app.mount('#app')
