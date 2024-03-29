import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/groupCode'

/**
 * 获取群活码列表
 * @param {*} params
{
    "pageNum": "当前页",
    "pageSize": "每页显示条数",
    "activityName": "活码名",
    "createBy": "创建人",
    "beginTime": "开始时间",
    "endTime": "结束时间"
}
 */
export function getList(params) {
  return request({
    url: service + '/list',
    params,
  })
}

/**
 * 新增群活码
 * @param {*} data
{
  "file": 活码头像
  "activityName": 活码名称
  "activityDesc": 活码描述
  "guide": 引导语
  "joinGroupIsTip": 进群是否提示:1:是;0:否
  "tipMsg": 进群提示语
  "customerServerQrCode":客服二维码
}
 */
export function add(data) {
  return request({
    url: service + '/',
    method: 'post',
    data,
  })
}

/**
 * 更新群活码
 * @param {*} id 群活码ID
 * @param {*} data
{
  "file": 活码头像
  "activityName": 活码名称
  "activityDesc": 活码描述
  "guide": 引导语
  "joinGroupIsTip": 进群是否提示:1:是;0:否
  "tipMsg": 进群提示语
  "customerServerQrCode":客服二维码
}
 */
export function update(data) {
  return request({
    url: service,
    method: 'put',
    data,
  })
}

/**
 * 根据ID获取群活码数据
 * @param {*} params
 */
export function getDetail(id) {
  return request({
    url: service + '/' + id,
  })
}

/**
 * 删除群活码
 * @param {*}
 * "ids": 群活码ID,多个ID以逗号分隔
 */
export function remove(ids) {
  return request({
    url: service + '/' + ids,
    method: 'delete',
  })
}

/**
 * 批量下载群活码
 * @param {*}
 * "ids": 群活码ID,多个ID以逗号分隔
 */
export function downloadBatch(ids) {
  return request({
    url: service + '/downloadBatch',
    params: {
      ids,
    },
    responseType: 'blob',
  })
}

/**
 * 下载群活码
 * @param {*}
 * "id": 群活码ID,多个ID以逗号分隔
 */
export function download(id) {
  return request({
    url: service + '/download',
    params: {
      id,
    },
    responseType: 'blob',
  })
}

export function getLineChartTotal(data) {
  return request({
    url: service + '/findWeGroupCodeCountTrend',
    params: data,
  })
}

export function getTableTotal(id) {
  return request({
    url: service + '/findWeGroupChatInfos/' + id,
  })
}

export function getGroupDetail(id) {
  return request({
    url: service + '/findWeGroupCodeById/' + id,
  })
}

// 获取群活码总数统计
export function getTotal(data) {
  return request({
    url: service + '/scan/total',
    params: data,
  })
}

/**
 * 获取活码折线图统计
 * @param {*} data
 * {
id,integer,false,,,活码Id
}
 */
export function getStatisticsLine(data) {
  return request({
    url: service + '/scan/line',
    params: data,
  })
}

/**
 * 获取活码表格统计
 * @param {*} data
 * {
id,integer,false,,,活码Id
}
 */
export function getStatisticsTable(data) {
  return request({
    url: service + '/scan/sheet',
    params: data,
  })
}

/**
 * 导出活码表格统计
 * @param {*} data
 * {
id,integer,false,,,活码Id
}
 */
export function exportStatisticsTable(data) {
  return request({
    url: service + '/scan/sheet/export',
    params: data,
    responseType: 'blob',
  })
}
