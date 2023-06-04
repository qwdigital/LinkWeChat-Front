import request from '@/utils/request'
const base = window.lwConfig.services.system

// 查询服务器详细
export function getServer() {
  return request({
    url: base + '/monitor/server',
    method: 'get',
  })
}
