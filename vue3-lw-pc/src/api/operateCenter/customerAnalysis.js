import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/operation/customer'

/**
 * 客户数据分析
 */
export function getAnalysis() {
  return request({
    url: service + '/getAnalysis',
  })
}

/**
 * 客户数据-客户总数
 * @params {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getTotalCnt(params) {
  return request({
    url: service + '/getTotalCnt',
    params,
  })
}

/**
 * 客户数据-实时数据
 * @params {*}
* deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRealCnt(params) {
  return request({
    url: service + '/getCustomerRealPageCnt',
    params,
  })
}

/**
 * 客户数据-员工客户排行
 * @params {*}
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRankCnt(params) {
  return request({
    url: service + '/getRankCnt',
    params,
  })
}

/**
 * 客户数据-实时数据-导出
 * @params {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function realDataExport(params) {
  return request({
    url: service + '/real/export',
    params,
    responseType: 'blob',
  })
}
