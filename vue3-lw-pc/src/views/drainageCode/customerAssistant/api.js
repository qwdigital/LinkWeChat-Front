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

// 详情
export function detail(id) {
  return request({
    url: service + '/getCustomerLinkById/' + id
  })
}

// 创建
export function addItem(data) {
  return request({
    url: service + '/createCustomerLink',
    data,
    method: 'post'
  })
}

// 编辑
export function editItem(data) {
  return request({
    url: service + '/updateCustomerLink',
    data,
    method: 'post'
  })
}
