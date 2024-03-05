import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/operation/session'

/**
 * 会话分析-客户联系总数
 * @param {*} params
 */
export function getAnalysisCustomer() {
  return request({
    url: service + '/customer/getAnalysis',
  })
}

/**
 * 会话分析-客户会话总数
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getTotalCntCustomer(params) {
  return request({
    url: service + '/customer/getTotalPageCnt',
    params,
  })
}

/**
 * 会话分析-员工平均恢复时长
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getUserAvgReplyTimeRank(params) {
  return request({
    url: service + '/customer/getUserAvgReplyTimeRank',
    params,
  })
}

/**
 * 会话分析-员工单聊总数
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getUserChatRank(params) {
  return request({
    url: service + '/customer/getUserChatRank',
    params,
  })
}

/**
 * 客群数据-会话总数-导出
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function dataExportGroup(params) {
  return request({
    url: service + '/customer/total/export',
    params,
    responseType: 'blob',
  })
}

/**
 * 会话分析-客群联系总数
 */
export function getAnalysisGroup() {
  return request({
    url: service + '/group/getAnalysis',
  })
}

/**
 * 会话分析-群聊会话总数
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getTotalCntGroup(params) {
  return request({
    url: service + '/group/getTotalPageCnt',
    params,
  })
}

/**
 * 会话分析-群聊会话总数-导出
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function realDataExportGroup(params) {
  return request({
    url: service + '/group/total/export',
    params,
    responseType: 'blob',
  })
}

/**
 * 会话存档同意明细
 * @param {*} params
 * deptIds	否[]部门
userIds	否[]员工
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getArchiveList(params) {
  return request({
    url: service + '/archive/details',
    params,
  })
}

/**
 * 会话存档数据分析
 * @param {*} params
 */
export function getAnalysisArchive() {
  return request({
    url: service + '/archive/getAnalysis',
  })
}
