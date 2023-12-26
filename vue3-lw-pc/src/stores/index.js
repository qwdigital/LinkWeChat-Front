import { createPinia, defineStore } from 'pinia'
import app from './modules/app'
import user from './modules/user'
import tagsView from './modules/tagsView'
import permission from './modules/permission'
import settings from './modules/settings'
import getters from './getters'

export const store = createPinia()

export default defineStore('app', {
  state: () => ({
    loading: false, // 页面loading
    AIDrawer: false, // AI抽屉
    app: { ...app.state },
    user: { ...user.state },
    tagsView: { ...tagsView.state },
    permission: { ...permission.state },
    settings: { ...settings.state },
  }),
  actions: {
    ...app.actions,
    ...user.actions,
    ...tagsView.actions,
    ...permission.actions,
    ...settings.actions,
  },
  getters,
})
