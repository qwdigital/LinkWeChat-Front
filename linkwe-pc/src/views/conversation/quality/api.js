import request from '@/utils/request'
const service = window.lwConfig.services.system + window.lwConfig.services.wecom

// 列表
export function getList(data) {
  return request({
    url: service + '/qi/list',
    method: 'get',
    params: data
  })
}

// 新增
export function addQuality(data) {
  return request({
    url: service + '/qi/add',
    method: 'post',
    data
  })
}

// 编辑
export function editQuality(id, data) {
  return request({
    url: service + '/qi/update/' + id,
    method: 'put',
    data
  })
}
