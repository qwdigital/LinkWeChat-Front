import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/kf'

// 同步客服
export function setAsync() {
  return request({
    url: service + '/list/async',
  })
}

// 客服接待人员列表
export function getMemeberInCustomer(data) {
  return request({
    url: service + '/servicer/list',
    params: data,
  })
}

// 客服列表
export function getList(params) {
  return request({
    url: service + '/list/page',
    params,
  })
}

// 新增客服 -- 账号
export function addService(data) {
  return request({
    url: service + '/add',
    method: 'post',
    data: data,
  })
}

// 客服编辑 -- 账号
export function editService(data) {
  return request({
    url: service + '/edit/account',
    method: 'post',
    data: data,
  })
}

// 新增客服 -- 欢迎语
export function addServiceWelcome(data) {
  return request({
    url: service + '/add/welcome',
    method: 'post',
    data: data,
  })
}

// 客服编辑 -- 欢迎语
export function editServiceWelcome(data) {
  return request({
    url: service + '/edit/welcome',
    method: 'post',
    data: data,
  })
}

// 新增客服 -- 规则
export function addServiceServicer(data) {
  return request({
    url: service + '/add/servicer',
    method: 'post',
    data: data,
  })
}

// 客服编辑 -- 规则
export function editServiceServicer(data) {
  return request({
    url: service + '/edit/servicer',
    method: 'post',
    data: data,
  })
}

// 删除客服
export function remove(id) {
  return request({
    url: service + '/delete/' + id,
    method: 'delete',
  })
}

// 客服详情
export function getDetail(id) {
  return request({
    url: service + '/get/' + id,
  })
}

// 批量下载场景二维码
export function downloadBatch(ids) {
  return request({
    url: service + '/scenes/batch/download',
    params: {
      ids: ids,
    },
    responseType: 'blob',
  })
}

// 场景列表
export function getSceneList(params) {
  return request({
    url: service + '/scenes/list',
    params,
  })
}

// 新增场景
export function addScene(data) {
  return request({
    url: service + '/scenes/add',
    data: data,
    method: 'post',
  })
}

// 编辑场景
export function editScene(data) {
  return request({
    url: service + '/scenes/edit',
    data: data,
    method: 'put',
  })
}

// 删除场景
export function deleteScene(ids) {
  return request({
    url: service + '/scenes/delete/' + ids,
    method: 'delete',
  })
}

// 咨询记录列表
export function getResultList(params) {
  return request({
    url: service + '/record/list',
    params,
  })
}

// 咨询记录导出
export function exportResult(params) {
  return request({
    url: service + '/record/export',
    responseType: 'blob',
    params: params,
  })
}

// 咨询记录详情
export function getResultDetail(params) {
  return request({
    url: service + '/record/detail',
    params: params,
  })
}

// 咨询记录-会话分析
export function getEvaluteData(data) {
  return request({
    url: service + '/msg/analyze',
    params: data,
  })
}

// 场景分析 抬头数据
export function getSceneTotal() {
  return request({
    url: service + '/statistic/scene/getAnalysis',
  })
}

// 场景分析 数据趋势 客户总数/实时数据
export function getLineChartTotal(params) {
  return request({
    url: service + '/statistic/scene/getRealCnt',
    params,
  })
}

// 场景分析 访问场景 top5
export function getBarTop5Total(params) {
  return request({
    url: service + '/statistic/scene/getRankCnt',
    params,
  })
}

// 场景分析 数据报表
export function getTableTotal(params) {
  return request({
    url: service + '/statistic/scene/getRealPageCnt',
    params,
  })
}

// 场景分析 数据报表 导出
export function getTableExport(params) {
  return request({
    url: service + '/statistic/scene/real/export',
    responseType: 'blob',
    params,
  })
}

// 咨询分析 抬头数据
export function getConsultTotal() {
  return request({
    url: service + '/statistic/consult/getAnalysis',
  })
}

// 咨询分析 数据趋势 客户总数/实时数据
export function getConsultLineChartTotal(params) {
  return request({
    url: service + '/statistic/consult/getRealCnt',
    params,
  })
}

// 咨询分析 访问场景 top5
export function getConsultBarTop5Total(params) {
  return request({
    url: service + '/statistic/consult/getRankCnt',
    params,
  })
}

// 咨询分析 数据报表
export function getConsultTableTotal(params) {
  return request({
    url: service + '/statistic/consult/getRealPageCnt',
    params,
  })
}

// 咨询分析 数据报表 导出
export function getConsultTableExport(params) {
  return request({
    url: service + '/statistic/consult/real/export',
    responseType: 'blob',
    params,
  })
}

// 质量分析 统计
export function getQualityTotal() {
  return request({
    url: service + '/statistic/quality/getAnalysis',
  })
}

// 质量分析  数据趋势
export function getQualityLineChartTotal(params) {
  return request({
    url: service + '/statistic/quality/getBrokenLine',
    params,
  })
}

// 质量分析 接待员工 Top5
export function getQualityBarTop5Total(params) {
  return request({
    url: service + '/statistic/quality/getHistogram',
    params,
  })
}

// 咨询分析 数据报表
export function getQualityTableTotal(params) {
  return request({
    url: service + '/statistic/quality/getChart',
    params,
  })
}

// 咨询分析 数据报表 导出
export function getQualityTableExport(params) {
  return request({
    url: service + '/statistic/quality/getChart/export',
    responseType: 'blob',
    params,
  })
}

// 获取微信客服升级服务配置信息
// pull 是否拉取企业微信最新客服服务数据  true 拉取 false 不拉取
export function getConfig(pull) {
  return request({
    url: service + '/get/upgrade/service/config',
    params: {
      pull,
    },
  })
}
