import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/RedEnvelopes'

/**
 * 支出统计-头部
 */
export function getAnalysis(params) {
  return request({
    url: service + '/countTab',
  })
}

/**
 * 支出统计-支出趋势
 * params  * {
        beginTime: '', // 创建开始时间
        endTime: '' // 创建结束时间
}
 */
export function getChartList(params) {
  return request({
    url: service + '/countLineChart',
    params,
  })
}

/**
 * 支出统计-支出记录
 * @param {*} params
 * {
pageNum	是 当前页
pageSize	是 每页显示条数
status	是 0:启用;1:停用
sceneType	是 1:客户;2:客群;3:客户与客群
}
 */
export function getRecordList(params) {
  return request({
    url: service + '/findRecordGroupByUserId',
    params,
  })
}
