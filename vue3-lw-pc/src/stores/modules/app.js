import { getServerState } from '@/api/common'
import Cookies from 'js-cookie'
import { useDark, useToggle } from '@vueuse/core'

const state = {
  sidebar: {
    opened: Cookies.get('sidebarStatus') ? !!+Cookies.get('sidebarStatus') : true,
    withoutAnimation: false,
  },
  device: 'desktop',
  size: Cookies.get('size') || 'medium',
  busininessDesc: undefined,
  isDark: useDark(),
  serverState: {},
}

const actions = {
  toggleSideBar() {
    this.app.sidebar.opened = !this.app.sidebar.opened
    this.app.sidebar.withoutAnimation = false
    if (this.app.sidebar.opened) {
      Cookies.set('sidebarStatus', 1)
    } else {
      Cookies.set('sidebarStatus', 0)
    }
  },
  closeSideBar({ withoutAnimation }) {
    Cookies.set('sidebarStatus', 0)
    this.app.sidebar.opened = false
    this.app.sidebar.withoutAnimation = withoutAnimation
  },
  toggleDevice(device) {
    this.app.device = device
  },
  setSize(size) {
    this.app.size = size
    Cookies.set('size', size)
  },
  setBusininessDesc(busininessDesc) {
    this.app.busininessDesc = busininessDesc
  },

  getServerState() {
    getServerState()
      .then(({ data }) => {
        data.ai = data['linkwe-ai']
        this.app.serverState = data
      })
      .catch((error) => {})
  },
}

export default {
  state,
  actions,
}
