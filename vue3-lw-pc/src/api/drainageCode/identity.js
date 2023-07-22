import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/knowCustomer'

// 列表
export function getList(params) {
  return request({
    url: service + '/findWeKnowCustomerCodes',
    params,
  })
}

// 详情
export function getDetail(id) {
  return request({
    url: service + '/getKnowCustomerDetail/' + id,
  })
}

//删除
export function remove(ids) {
  return request({
    url: service + '/' + ids,
    method: 'delete',
  })
}

export function addOrUpdate(params) {
  return request({
    url: service + '/addOrUpdateKnowCustomer',
    data: params,
    method: 'post',
  })
}

// 导出excel
export function downloadBatch() {
  return request({
    url: service + '/exportKnowCustomers',
    params: {},
    responseType: 'blob',
  })
}

// 单个下载
export function download(id) {
  return request({
    url: service + '/downloadKnowCustomerUrl/' + id,
    responseType: 'blob',
  })
}

// 详情头部Card
export function getIdentityCodeTab(params) {
  return request({
    url: service + '/findWKCountDetailTab',
    params,
  })
}

// 详情数据趋势
export function getLineData(params) {
  return request({
    url: service + '/findWeKCountTrend',
    params,
  })
}

// 详情数据报表
export function getTableData(params) {
  return request({
    url: service + '/findWeKCounTtable',
    params,
  })
}

// 详情数据报表导出
export function getTableExport(params) {
  return request({
    url: service + '/exportWeKnowCustomerCounTtable',
    params,
    responseType: 'blob',
  })
}
