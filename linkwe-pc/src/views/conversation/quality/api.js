import request from '@/utils/request'
const service = window.lwConfig.services.system + window.lwConfig.services.wecom

export function getList(data) {
  return request({
    url: service + '/qi/list',
    method: 'get',
    params: data
  })
}
