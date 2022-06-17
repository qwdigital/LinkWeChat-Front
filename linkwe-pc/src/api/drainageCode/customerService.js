import request from '@/utils/request'
const service = window.lwConfig.KF_API

// 同步客服
export function setAsync() {
  return request({
    url: service + '/wecom/kf/list/async',
  })
}

// 客服接待人员列表
export function getMemeberInCustomer(data) {
  return request({
    url: service + '/wecom/kf/servicer/list',
    params: data,
  })
}

// 客服列表
export function getList(params) {
  console.log(service)
  return request({
    url: service + '/wecom/kf/list',
    params,
  })
}

// 新增客服
export function addService(data) {
  return request({
    url: service + '/wecom/kf/add',
    method: 'post',
    data: data,
  })
}

// 客服编辑
export function editService(data) {
  return request({
    url: service + '/wecom/kf/edit/account',
    method: 'post',
    data: data,
  })
}

// 删除客服
export function remove(id) {
  return request({
    url: service + '/wecom/kf/delete/' + id,
    method: 'delete',
  })
}

// 客服详情
export function getDetail(id) {
  return request({
    url: service + '/wecom/kf/get/' + id,
  })
}

// 批量下载场景二维码
export function downloadBatch(ids) {
  return request({
    url: service + '/wecom/kf/scenes/batch/download',
    params: {
      ids: ids,
    },
    responseType: 'blob',
  })
}

// 场景列表
export function getSceneList(params) {
  return request({
    url: service + '/wecom/kf/scenes/list',
    params,
  })
}

// 新增场景
export function addScene(data) {
  return request({
    url: service + '/wecom/kf/scenes/add',
    data: data,
    method: 'post',
  })
}

// 编辑场景
export function editScene(data) {
  return request({
    url: service + '/wecom/kf/scenes/edit',
    data: data,
    method: 'put',
  })
}

// 删除场景
export function deleteScene(ids) {
  console.log(33333)
  return request({
    url: service + '/wecom/kf/scenes/delete/' + ids,
    method: 'delete',
  })
}

// 咨询记录列表
export function getResultList(params) {
  return request({
    url: service + '/wecom/kf/record/list',
    params,
  })
}

// 咨询记录导出
export function exportResult(params) {
  return request({
    url: service + '/wecom/kf/record/export',
    params: params,
  })
}

// 咨询记录详情
export function getResultDetail(params) {
  return request({
    url: service + '/wecom/kf/record/detail',
    params: params,
  })
}

// 场景分析 抬头数据
export function getSceneTotal() {
  return request({
    url: service + '/wecom/kf/statistic/scene/getAnalysis',
  })
}

// 场景分析 数据趋势 客户总数/实时数据
export function getLineChartTotal(params) {
  return request({
    url: service + '/wecom/kf/statistic/scene/getRealCnt',
    params,
  })
}

// 场景分析 访问场景 top5
export function getBarTop5Total(params) {
  return request({
    url: service + '/wecom/kf/statistic/scene/getRankCnt',
    params,
  })
}

// 场景分析 数据报表
export function getTableTotal(params) {
  return request({
    url: service + '/wecom/kf/statistic/scene/getRealPageCnt',
    params,
  })
}

// 场景分析 数据报表 导出
export function getTableExport(params) {
  return request({
    url: service + '/wecom/kf/statistic/scene/real/export',
    params,
  })
}

// 咨询分析 抬头数据
export function getConsultTotal() {
  return request({
    url: service + '/wecom/kf/statistic/consult/getAnalysis',
  })
}

// 咨询分析 数据趋势 客户总数/实时数据
export function getConsultLineChartTotal(params) {
  return request({
    url: service + '/wecom/kf/statistic/consult/getRealCnt',
    params,
  })
}

// 咨询分析 访问场景 top5
export function getConsultBarTop5Total(params) {
  return request({
    url: service + '/wecom/kf/statistic/consult/getRankCnt',
    params,
  })
}

// 咨询分析 数据报表
export function getConsultTableTotal(params) {
  return request({
    url: service + '/wecom/kf/statistic/consult/getRealPageCnt',
    params,
  })
}

// 咨询分析 数据报表 导出
export function getConsultTableExport(params) {
  return request({
    url: service + '/wecom/kf/statistic/consult/real/export',
    params,
  })
}
