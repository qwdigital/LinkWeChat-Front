import request from '@/utils/request'
const base = window.lwConfig.services.wecom
const groundBase = window.lwConfig.services.wecom + '/substitute/customer/order'

// 2.0
// 分组list
export function getCodeCategoryList() {
  return request({
    url: groundBase + '/catalogue',
  })
}

// 新增分组
export function addCodeCategory(data) {
  return request({
    url: groundBase + '/catalogue',
    method: 'post',
    data: data,
  })
}

// 更新分组
export function updateCodeCategory(data) {
  return request({
    url: groundBase + '/catalogue',
    method: 'put',
    data: data,
  })
}

// 删除分组
export function removeCodeCategory(id) {
  return request({
    url: groundBase + '/catalogue/' + id,
    method: 'delete',
  })
}

// 移动分组
export function moveCodeCategory(data) {
  return request({
    url: groundBase + '/catalogue/move',
    method: 'put',
    data: data,
  })
}

// 列表
export function getList(params) {
  return request({
    url: groundBase + '/property',
    params,
  })
}

// 列表删除
export function remove(id) {
  return request({
    url: groundBase + '/property/' + id,
    method: 'delete',
  })
}

export function fnRemove(ids) {
  return request({
    url: groundBase + '/property',
    method: 'delete',
    params: { ids },
  })
}

// 列表新增
export function add(data) {
  return request({
    url: groundBase + '/property',
    method: 'post',
    data,
  })
}
// 列表修改
export function update(data) {
  return request({
    url: groundBase + '/property',
    method: 'put',
    data,
  })
}

// 列表详情
export function getDetail(id) {
  return request({
    url: groundBase + '/property/' + id,
  })
}

// 字段类型列表
export function getTypeList() {
  return request({
    url: groundBase + '/property/type',
  })
}

// 列表修改
export function listMove(data) {
  return request({
    url: groundBase + '/property/move',
    method: 'put',
    data,
  })
}
