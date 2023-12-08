import request from '@/utils/request'
import config from '@/config.js'
const service = config.services.wecom

// 通过短链接获取短链详情
export function getDetail(path, type) {
  let url = ''
  switch (type) {
    case 'qr': // 员工活码短链
      url = '/qr/getByDetail/'
      break

    case 'gqr': // 群活码短链
      url = '/groupCode//getByDetail/'
      break

    default: // 智能短链
      url = '/short/link/getByShort/'
      break
  }
  return request({
    url: service + url + path,
  })
}
