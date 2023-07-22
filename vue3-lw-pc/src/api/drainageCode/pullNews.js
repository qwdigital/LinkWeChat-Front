import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/lxqr'

// 列表
export function getList(params) {
  return request({
    url: service + '/list',
    params,
  })
}
// 卡券列表
export function getCardList(params) {
  return request({
    url: window.lwConfig.services.wecom + '/coupon/getCouponList',
    params,
  })
}
// 红包列表
export function getRedList(params) {
  return request({
    url: window.lwConfig.services.wecom + '/RedEnvelopes/list',
    params,
  })
}
// 新增
export function add(params) {
  return request({
    url: service + '/add',
    data: params,
    method: 'post',
  })
}
// 编辑
export function update(data) {
  return request({
    url: service + '/update/' + data.id,
    data,
    method: 'put',
  })
}

// 详情
export function getDetail(id) {
  return request({
    url: service + '/get/' + id,
  })
}

//删除
export function remove(ids) {
  return request({
    url: service + '/del/' + ids,
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
    url: service + '/line/statistics',
    params,
  })
}

// 详情数据报表
export function getTableData(params) {
  return request({
    url: service + '/list/statistics',
    params,
  })
}

// 活码统计数据报表导出
export function getTableExport(params) {
  return request({
    url: service + '/list/statistics/export',
    params,
    responseType: 'blob',
  })
}
// 领取红包金额统计（折线图）
export function getMoneyLineData(params) {
  return request({
    url: service + '/receive/line/amount',
    params,
  })
}
// 领取红包个数统计（折线图）
export function getNumLineData(params) {
  return request({
    url: service + '/receive/line/num',
    params,
  })
}
// 领取红包列表统计（表格）
export function getRedTableData(params) {
  return request({
    url: service + '/receive/list/statistics',
    params,
  })
}
// 领取红包列表统计（表格导出）
export function getRedTableExport(params) {
  return request({
    url: service + '/receive/list/statistics/export',
    params,
    responseType: 'blob',
  })
}
// 领取总数统计（表格）
export function getTotalData(params) {
  return request({
    url: service + '/receive/statistics',
    params,
  })
}
