import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/customerlink'

// 列表
export function getList(params) {
  return request({
    url: service + '/list',
    params
  })
}

// 删除
export function remove(ids) {
  return request({
    url: service + '/' + ids,
    method: 'delete'
  })
}
