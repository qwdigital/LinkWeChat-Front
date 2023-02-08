import request from '@/utils/request.js'
import config from '@/config.js'
const service = config.services.wecom + '/short/link'

// 智能短链

// 列表
export function getList(data) {
  return request({
    url: service + '/list',
    params: data,
  })
}

// 详情
export function getDetail(id) {
  return request({
    url: service + '/get/' + id,
  })
}

// 删除
export function remove(id) {
  return request({
    url: service + '/delete/' + id,
    method: 'DELETE',
  })
}

// 新增
export function add(data) {
  return request({
    url: service + '/add',
    method: 'POST',
    data,
  })
}

// 修改
export function update(data) {
  return request({
    url: service + '/update/' + id,
    method: 'PUT',
    data,
  })
}
