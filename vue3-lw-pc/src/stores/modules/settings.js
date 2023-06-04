const { showSettings, tagsView, fixedHeader, sidebarLogo } = window.lwConfig

const state = {
  theme: getComputedStyle(document.documentElement).getPropertyValue('--color'),
  showSettings: showSettings,
  tagsView: tagsView,
  fixedHeader: fixedHeader,
  sidebarLogo: sidebarLogo,
}

const actions = {
  changeSetting({ key, value }) {
    if (state.hasOwnProperty(key)) {
      this.setting[key] = value
    }
  },
}

export default {
  state,
  actions,
}
