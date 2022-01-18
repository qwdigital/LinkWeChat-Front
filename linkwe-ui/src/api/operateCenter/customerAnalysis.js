import request from '@/utils/request'
const service = window.CONFIG.services.wecom + '/operation/customer'

/**
 * 客户数据分析
 * @param {*} params
 */
export function getAnalysis() {
  return request({
    url: 'http://demo.linkwechat.cn/prod-api/' + service + '/getAnalysis'
  })
}

/**
 * 客户数据-员工客户排行
 * @param {*}
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRankCnt() {
  return request({
    url: service + '/getRankCnt'
  })
}

/**
 * 客户数据-实时数据
 * @param {*}
* deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRealCnt() {
  return request({
    url: service + '/getRealCnt'
  })
}

/**
 * 客户数据-客户总数
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getTotalCnt() {
  return request({
    url: service + '/getTotalCnt'
  })
}
