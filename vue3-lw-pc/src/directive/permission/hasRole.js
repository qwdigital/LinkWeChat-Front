/**
 * 角色权限处理
 */

import stores from '@/stores'

export default {
  mounted(el, binding, vnode) {
    const { value } = binding
    const super_admin = 'admin'
    const roles = stores() && stores().roles

    if (value && value instanceof Array && value.length > 0) {
      const roleFlag = value

      const hasRole = roles.some((role) => {
        return super_admin === role || roleFlag.includes(role)
      })

      if (!hasRole) {
        el.parentNode && el.parentNode.removeChild(el)
      }
    } else {
      throw new Error(`请设置角色权限标签值"`)
    }
  },
}
