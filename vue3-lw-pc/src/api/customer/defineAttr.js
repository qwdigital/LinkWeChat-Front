import request from '@/utils/request'
let getway = window.lwConfig.services.wecom
const service = getway + '/field'

// 列表
export function getList(params) {
  return request({
    url: service + '/list',
    method: 'get',
    params,
  })
}

// 新增
export function addField(data) {
  return request({
    url: service + '/addSysField',
    data,
    method: 'post',
  })
}

// 更新
export function updateField(data) {
  return request({
    url: service + '/updateSysField',
    data,
    method: 'put',
  })
}

// 删除
export function deleteField(ids) {
  return request({
    url: service + '/' + ids,
    method: 'delete',
  })
}

// 排序更新
export function multiField(data) {
  return request({
    url: service + '/batchUpdateSysField',
    method: 'post',
    data,
  })
}
