import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom + '/fission'

// 列表
export function getList(data) {
  return request({
    url: wecom + '/list',
    method: 'get',
    params: data
  })
}

// 列表删除
export function deleteFassion(id) {
  return request({
    url: wecom + '/' + id,
    method: 'delete'
  })
}

// 列表批量删除
export function deleteMultFa(ids) {
  return request({
    url: wecom + '/' + ids,
    method: 'delete'
  })
}

// 新建
export function addFassion(data) {
  return request({
    url: wecom + '/add',
    method: 'post',
    data
  })
}

// 编辑
export function editFassion(data) {
  return request({
    url: wecom + '/update',
    method: 'put',
    data
  })
}

// 获取任务详情
export function getFassionDetail(id) {
  return request({
    url: wecom + '/getWeFissionDetail/' + id
  })
}

// 统计 头部
export function getTotal(id) {
  return request({
    url: wecom + '/findWeFissionTab/' + id
  })
}

// 统计 折线图
export function getLineData(data) {
  return request({
    url: wecom + '/findWeFissionTrend',
    params: data
  })
}

// 统计 表格
export function getTableData(data) {
  return request({
    url: wecom + '/findWeFissionDataReport',
    params: data
  })
}

// 统计 导出
export function getTableExport(data) {
  return request({
    url: wecom + '/exportWeFissionDataReport',
    params: data,
    responseType: 'blob'
  })
}

// 裂变明细 - 客户
export function getFissionCustomerTable(data) {
  return request({
    url: wecom + '/findWeTaskFissionDetail',
    params: data
  })
}

// 裂变明细 - 客群
export function getFissionGroupTable(data) {
  return request({
    url: wecom + '/findWeGroupFissionDetail',
    params: data
  })
}

// 裂变明细 - sub table
export function getFissionSubTable(data) {
  return request({
    url: wecom + '/findWeFissionDetailSub',
    params: data
  })
}

// 裂变明细 导出 - 任务裂变
export function exportCustomerTable(data) {
  return request({
    url: wecom + '/exportWeTaskFissionDetail',
    params: data,
    responseType: 'blob'
  })
}

// 裂变明细 导出 - 客群裂变
export function exportGroupTable(data) {
  return request({
    url: wecom + '/exportWeGroupFissionDetail',
    params: data,
    responseType: 'blob'
  })
}

// 任务状态
export function updateState(data) {
  return request({
    url: wecom + '/updateFissionState',
    data,
    method: 'post'
  })
}
