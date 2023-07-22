import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/operation/group'

/**
 * 客群数据分析
 */
export function getAnalysis() {
  return request({
    url: service + '/getAnalysis',
  })
}

/**
 * 客群数据-客群总数
 * @param {*} params
* chatIds	否[]群聊id
ownerIds	否[]群主id
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
 * 客群数据-客群成员总数
 * @param {*} params
* chatIds	否[]群聊id
ownerIds	否[]群主id
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getTotalCntMember(params) {
  return request({
    url: service + '/member/getTotalCnt',
    params,
  })
}

/**
 * 客群数据-客群实时数据
 * @param {*}
* chatIds	否[]群聊id
ownerIds	否[]群主id
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRealCnt(params) {
  return request({
    url: service + '/getGroupRealPageCnt',
    params,
  })
}

/**
 * 客群数据-客群成员实时数据
 * @param {*}
* chatIds	否[]群聊id
ownerIds	否[]群主id
beginTime	是 开始时间
endTime	是 结束时间
 */
export function getRealCntMember(params) {
  return request({
    url: service + '/member/getGroupMemberRealPageCnt',
    params,
  })
}

/**
 * 客群数据-客群实时数据-导出
 * @param {*} params
* chatIds	否[]群聊id
ownerIds	否[]群主id
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

/**
 * 客群数据-客群成员实时数据-导出
 * @param {*} params
* chatIds	否[]群聊id
ownerIds	否[]群主id
beginTime	是 开始时间
endTime	是 结束时间
 */
export function realDataExportMember(params) {
  return request({
    url: service + '/member/real/export',
    params,
    responseType: 'blob',
  })
}
