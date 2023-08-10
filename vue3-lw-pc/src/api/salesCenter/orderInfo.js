import request from '@/utils/request'
const base = window.lwConfig.services.wecom
const groundBase = window.lwConfig.services.wecom + '/substitute/customer/order/catalogue'

const service = window.lwConfig.services.wecom + '/category'

export function download(data) {
  // return request({
  //   url: service + '/update',
  //   method: 'put',
  //   data
  // })
}
export function getUserAddCustomerStat(data) {
  // return request({
  //   url: service + '/update',
  //   method: 'put',
  //   data
  // })
}

/**
 * 批量新增员工活码
 * @param {*} data
 */
export function batchAdd(data) {
  return request({
    url: service + '/batchAdd',
    method: 'post',
    data,
  })
}

/**
 * 删除员工活码
 * @param {*} id
 */

/**
 *获取员工二维码
 * @param {*} params
{
  userIds=员工id,多个逗号隔离&
  departmentIds=部门id,多个逗号隔离
}
 */
export function getQrcode(params) {
  return request({
    url: service + '/getQrcode',
    params,
  })
}

// 2.0
// 分组list
export function getCodeCategoryList() {
  return request({
    url: groundBase,
  })
}

// 新增分组
export function addCodeCategory(data) {
  return request({
    url: groundBase,
    method: 'post',
    data: data,
  })
}

// 更新分组
export function updateCodeCategory(data) {
  return request({
    url: groundBase,
    method: 'put',
    data: data,
  })
}

// 删除分组
export function removeCodeCategory(id) {
  return request({
    url: groundBase + '/' + id,
    method: 'delete',
  })
}

// 移动分组
export function moveCodeCategory(data) {
  return request({
    url: groundBase + '/move',
    method: 'put',
    data: data,
  })
}

// 活码列表
export function getList(params) {
  return request({
    url: base + '/qr/list',
    params,
  })
}

// 活码删除
export function remove(id) {
  return request({
    url: base + '/qr/del/' + id,
    method: 'delete',
  })
}

// 活码新增
export function add(data) {
  return request({
    url: base + '/qr/add',
    method: 'post',
    data,
  })
}

export function update(data) {
  return request({
    url: base + '/qr/update',
    method: 'put',
    data,
  })
}

// 活码详情
export function getDetail(id) {
  return request({
    url: base + '/qr/get/' + id,
  })
}

// 活码统计
export function getTotal(data) {
  return request({
    url: base + '/qr/scan/count',
    params: data,
  })
}
