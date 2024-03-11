import '../config.js'
import 'normalize.css/normalize.css'

import { createApp, h, defineAsyncComponent } from 'vue'
// configureCompat({
//   WATCH_ARRAY: false,
// })
import App from './App.vue'
import router from './router'

const app = createApp(App)

import ElementPlus, { ElNotification, ElMessageBox } from 'element-plus'
import 'element-plus/theme-chalk/dark/css-vars.css'
import 'element-plus/dist/index.css'
app.use(ElementPlus, {})
let ElInput = app.component('ElInput')
ElInput.props.clearable.default = true
let ElSelect = app.component('ElSelect')
ElSelect.props.clearable = { type: Boolean, default: true }

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
  Empty: () => import('./components/Empty.vue'),
  Upload: () => import('./components/Upload.vue'),
  Pagination: () => import('./components/Pagination.vue'),
  RightToolbar: () => import('./components/RightToolbar.vue'),
  ButtonSync: () => import('./components/ButtonSync.vue'),
  TagEllipsis: () => import('./components/TagEllipsis.vue'),
  SelectTag: () => import('./components/SelectTag.vue'),
  SelectUser: () => import('./components/SelectUser.vue'),
  SelectStaffForm: () => import('./components/SelectStaffForm.vue'),
  CoRemoteSelect: () => import('./components/CoRemoteSelect.vue'),
  PhoneTemplate: () => import('./components/PhoneTemplate.vue'),
  PhoneDialog: () => import('./components/PhoneDialog.vue'),
  CardGroupIndex: () => import('./components/CardGroupIndex.vue'),
  TextareaExtend: () => import('./components/TextareaExtend.vue'), // 带 插入 表情/客户昵称 等扩展工具栏的文本内容框
  DateSearchChartTable: () => import('./components/DateSearchChartTable.vue'),
  RequestChartTable: () => import('./components/RequestChartTable.vue'),
  SearchResetButton: () => import('./components/SearchResetButton.vue'),
  CustomerRangeForm: () => import('./components/CustomerRangeForm.vue'),
  CacheElTabs: () => import('./components/CacheElTabs.vue'),
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
import { dictMaterialType } from '@/utils/dictionary'
Object.assign(app.config.globalProperties, methods, {
  // 动态配置
  lwConfig: window.lwConfig,
  // 日期时间控件快捷配置
  pickerOptions,
  ClipboardJS,
  msgSuccess(msg = '操作成功') {
    this.$message({
      showClose: true,
      message: msg,
      type: 'success',
    })
  },
  msgError(msg = '操作失败') {
    this.$message({ showClose: true, message: msg, type: 'error' })
  },
  msgInfo(msg) {
    this.$message.info(msg)
  },
  $confirm(message = '确认删除吗？', title, options = {}) {
    let defaultConfig = {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
      title: '警告',
    }
    if (typeof title === 'string') {
      defaultConfig.title = title
      Object.assign(options, defaultConfig)
    } else {
      Object.assign(options, defaultConfig, title || {})
    }
    return ElMessageBox.confirm(message, title, options)
  },
  // $confirmDel(message = '确认删除吗？', title, options = {}) {
  //   this.$confirm(message, title, options)
  // },
  $dictMaterialType: dictMaterialType,
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
