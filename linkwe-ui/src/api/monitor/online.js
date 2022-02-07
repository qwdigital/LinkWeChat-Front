import request from '@/utils/request'
const base = window.CONFIG.services.system

// 查询在线用户列表
export function list (query) {
  return request({
    url: base + '/monitor/online/list',
    method: 'get',
    params: query
  })
}

// 强退用户
export function forceLogout (tokenId) {
  return request({
    url: base + '/monitor/online/' + tokenId,
    method: 'delete'
  })
}
