import request from '@/utils/request'
const service = window.CONFIG.services.system

// 获取路由
export const getRouters = () => {
  return request({
    url: service + '/getRouters',
    method: 'get'
  })
}