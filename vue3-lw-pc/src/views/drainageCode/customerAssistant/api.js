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

// 同步
export function syncData(id) {
  return request({
    url: service + '/synchCustomerCount/' + id
  })
}

//tab 数据
export function getTabData(id) {
  return request({
    url: service + '/selectLinkCountTab/' + id
  })
}

// 折线图
export function getLineData(data) {
  return request({
    url: service + '/selectLinkCountTrend',
    params: data
  })
}

// 数据报表
export function getTableData(data) {
  return request({
    url: service + '/selectLinkCountTable',
    params: data
  })
}

// 导出
export function getTableExport(data) {
  return request({
    url: service + '/exportLinkCount',
    params: data,
    responseType: 'blob'
  })
}

// 数据明细
export function getCustomerInLink(data) {
  return request({
    url: service + '/findLinkWeCustomer',
    params: data
  })
}

export function refresh() {
  return request({
    url: service + '/synchAcquisitionQuota'
  })
}
