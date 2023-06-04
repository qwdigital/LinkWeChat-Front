import request from '@/utils/request'
const service = window.lwConfig.services.system

// 获取路由
export const getRouters = () => {
  return request({
    url: service + '/system/user/getRouters',
    method: 'get',
  })
}
