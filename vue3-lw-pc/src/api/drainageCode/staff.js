import request from '@/utils/request'
const base = window.lwConfig.services.wecom
const service = window.lwConfig.services.wecom + '/category'

/**
 * 编辑员工活码
 * @param {*} data
{
    "id": "员工活码id",
    "isJoinConfirmFriends": "客户添加时无需经过确认自动成为好友",
    "codeType": "活码类型:1:单人;2:多人;3:批量;",
    "activityScene": "活动场景",
    "welcomeMsg": "欢迎语",
    "mediaId": "素材的id",
    "weEmpleCodeUseScops": [{
        "id": "主键",
        "empleCodeId": "员工活码id",
        "useUserId": "活码类型下业务使用人的id"
    }],
    "weEmpleCodeTags": [{
        "id": "",
        "tagId": "标签id",
        "tagName": "标签",
        "empleCodeId": "员工活码id"
    }]
}
 */
export function download(data) {
  // return request({
  //   url: service + '/update',
  //   method: 'put',
  //   data
  // })
}
export function getUserAddCustomerStat(data) {
  // return request({
  //   url: service + '/update',
  //   method: 'put',
  //   data
  // })
}

/**
 * 批量新增员工活码
 * @param {*} data
 */
export function batchAdd(data) {
  return request({
    url: service + '/batchAdd',
    method: 'post',
    data,
  })
}

/**
 * 删除员工活码
 * @param {*} id
 */

/**
 *获取员工二维码
 * @param {*} params
{
  userIds=员工id,多个逗号隔离&
  departmentIds=部门id,多个逗号隔离
}
 */
export function getQrcode(params) {
  return request({
    url: service + '/getQrcode',
    params,
  })
}

// 2.0
// 分组list
export function getCodeCategoryList(data) {
  return request({
    url: service + '/list',
    params: data,
  })
}

// 新增分组
export function addCodeCategory(data) {
  return request({
    url: service,
    method: 'post',
    data: data,
  })
}

// 更新分组
export function updateCodeCategory(data) {
  return request({
    url: service,
    method: 'put',
    data: data,
  })
}

// 删除分组
export function removeCodeCategory(ids) {
  return request({
    url: service + '/' + ids,
    method: 'delete',
  })
}

// 活码列表
export function getList(params) {
  return request({
    url: base + '/qr/list',
    params,
  })
}

// 活码下载
export function downloadBatch(ids) {
  return request({
    url: base + '/qr/batch/download',
    params: {
      ids: ids,
    },
    responseType: 'blob',
  })
}
// 活码删除
export function remove(id) {
  return request({
    url: base + '/qr/del/' + id,
    method: 'delete',
  })
}

// 活码新增
export function add(data) {
  return request({
    url: base + '/qr/add',
    method: 'post',
    data,
  })
}

export function update(data) {
  return request({
    url: base + '/qr/update',
    method: 'put',
    data,
  })
}

// 活码详情
export function getDetail(id) {
  return request({
    url: base + '/qr/get/' + id,
  })
}

// 活码统计
export function getTotal(data) {
  return request({
    url: base + '/qr/scan/count',
    params: data,
  })
}

/**
 * 获取活码折线图统计
 * @param {*} data
 * {
 * groupId,string,false,,,分组id
qrId,integer,false,,,活码Id
qrName,string,false,,,活码名称
qrUserIds,string,false,,,员工ID
}
 */
export function getStatisticsLine(data) {
  return request({
    url: base + '/qr/scan/line',
    params: data,
  })
}

/**
 * 获取活码表格统计
 * @param {*} data
 * {
 * groupId,string,false,,,分组id
qrId,integer,false,,,活码Id
qrName,string,false,,,活码名称
qrUserIds,string,false,,,员工ID
}
 */
export function getStatisticsTable(data) {
  return request({
    url: base + '/qr/scan/sheet',
    params: data,
  })
}

/**
 * 导出活码表格统计
 * @param {*} data
 * {
 * groupId,string,false,,,分组id
qrId,integer,false,,,活码Id
qrName,string,false,,,活码名称
qrUserIds,string,false,,,员工ID
}
 */
export function exportStatisticsTable(data) {
  return request({
    url: base + '/qr/scan/sheet/export',
    params: data,
    responseType: 'blob',
  })
}
