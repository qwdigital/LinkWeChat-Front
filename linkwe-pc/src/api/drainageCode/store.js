import request from '@/utils/request'
const service = window.lwConfig.services.system + window.lwConfig.services.wecom + '/storeCode'

// 门店活码类型 storeCodeType 1:门店导购码  2:门店群活码
export function getCode(type) {
  return request({
    url: service + '/config/' + type
  })
}

// 门店列表
export function getTableList(params) {
  return request({
    url: service + '/storeCodes',
    params
  })
}

// 门店删除
export function deleteStore(ids) {
  return request({
    url: service + '/' + ids,
    method: 'delete'
  })
}

// 门店启停
export function updateState(ids, params) {
  return request({
    url: service + '/batchStartOrStop/' + ids,
    method: 'put',
    data: params
  })
}

// 门店模板下载
export function downloadTemplate() {
  return request({
    url: service + '/importTemplate',
    responseType: 'blob'
  })
}

// 门店导入
export function uploadStore(params) {
  console.log(params)
  return request({
    url: service + '/importData',
    method: 'post',
    data: params
  })
}

// 新建或编辑 门店
export function addOrUpdateStore(params) {
  return request({
    url: service + '/code/createOrUpdateStoreCode',
    method: 'post',
    data: params
  })
}

// 门店详情
export function storeDetail(id) {
  return request({
    url: service + '/getWeStoreCodeById/' + id
  })
}

// 新建或编辑 导购码/群活码
export function addOrUpdateCodeInStore(params) {
  return request({
    url: service + '/config/createOrUpdate',
    method: 'post',
    data: params
  })
}

// 门店详情统计 头部
export function getTabTotalInStore(id) {
  return request({
    url: service + '/countWeStoreTab/' + id
  })
}

// 门店详情统计 数据趋势 导购码
export function getLineDataGuideCode(params) {
  return request({
    url: service + '/countStoreShopGuideTrend',
    params
  })
}

// 门店详情统计 数据趋势 群码
export function getLineDataStoreCode(params) {
  return request({
    url: service + '/countStoreGroupTrend',
    params
  })
}

// 下载门店导购码或群码
export function downloadUrl(params) {
  return request({
    url: service + '/downloadStoreCodeConfigUrl',
    params,
    responseType: 'blob'
  })
}

// 门店导购码详情 数据统计 头部
export function getGuideCodeTab(params) {
  return request({
    url: service + '/countWeStoreShopGuideTab',
    params
  })
}

// 门店群码详情 数据统计 头部
export function getStoreCodeTab(params) {
  return request({
    url: service + '/countWeStoreGroupTab',
    params
  })
}

// 门店导购码详情 数据统计 top10
export function getBarTop10GuideCode(params) {
  return request({
    url: service + '/countStoreShopGuideDrum',
    params
  })
}

// 门店群码详情 数据统计 top10
export function getBarTop10StoreCode(params) {
  return request({
    url: service + '/countStoreShopGroupDrum',
    params
  })
}

// 门店导购码详情 数据统计 数据报表
export function getTableInGuideCode(params) {
  return request({
    url: service + '/countShopGuideReport',
    params
  })
}

// 门店导购码详情 数据统计 数据报表导出
export function getTableGuideCodeExport(params) {
  return request({
    url: service + '/exportCountShopGuideReport',
    params,
    responseType: 'blob'
  })
}

// 门店导购码详情 数据统计 数据报表
export function getTableInStoreCode(params) {
  return request({
    url: service + '/countStoreGroupReport',
    params
  })
}

// 门店导购码详情 数据统计 数据报表导出
export function getTableStoreCodeExport(params) {
  return request({
    url: service + '/exportCountStoreGroupReport',
    params,
    responseType: 'blob'
  })
}
