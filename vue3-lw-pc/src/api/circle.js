import request from '@/utils/request'
const service = window.lwConfig.services.wecom

// 朋友圈 企业动态 列表
export function getEnterpriceList(data) {
  return request({
    url: service + '/moments/list',
    params: data,
  })
}

// // 朋友圈 企业 同步
// export function syncHMoments(data) {
//   return request({
//     url: service + '/moments/synchMoments',
//     params: data,
//   })
// }
// 朋友圈 全部 同步
export function syncHMoments(id) {
  return request({
    url: service + '/moments/sync/' + id,
  })
}

// 朋友圈 详情
export function getDetail(id) {
  return request({
    url: service + '/moments/get/' + id,
  })
}

// 朋友圈  企业  发布动态
export function gotoPublish(data) {
  return request({
    url: service + '/moments/addOrUpdate',
    method: 'post',
    data: data,
  })
}

// 朋友圈 停止发送朋友圈
export function cancelMoments(data) {
  return request({
    url: service + '/moments/cancel/' + data,
  })
}

// 朋友圈  新增
export function addMoments(data) {
  return request({
    url: service + '/moments/add',
    method: 'post',
    data: data,
  })
}

//  朋友圈 预估客户数量
export function numMoments(data) {
  return request({
    url: service + '/moments/estimate/num',
    method: 'post',
    data: data,
  })
}

// 朋友圈 提醒执行
export function reminderMoments(data) {
  return request({
    url: service + '/moments/reminder/execution/' + data,
  })
}
// 朋友圈 员工统计
export function statisticMoments(id) {
  return request({
    url: service + '/moments/statistic/user/' + id,
  })
}
// 朋友圈 员工记录
export function getRecordList(data) {
  return request({
    url: service + '/moments/statistic/user/record',
    params: data,
  })
}
// 员工记录导出
export function exportUser(data) {
  return request({
    url: service + '/moments/statistic/user/export',
    params: data,
    responseType: 'blob',
  })
}
// 朋友圈 客户统计
export function statisticCustomer(id) {
  return request({
    url: service + '/moments/statistic/customer/' + id,
  })
}
// 朋友圈 客户记录
export function getCustomerList(data) {
  return request({
    url: service + '/moments/statistic/customer/record',
    params: data,
  })
}
// 客户记录导出
export function exportCustomer(data) {
  return request({
    url: service + '/moments/statistic/customer/export',
    params: data,
    responseType: 'blob',
  })
}

// 朋友圈 互动统计
export function statisticInteract(id) {
  return request({
    url: service + '/moments/statistic/interact/' + id,
  })
}
// 朋友圈 互动记录
export function getInteractList(data) {
  return request({
    url: service + '/moments/statistic/interact/record',
    params: data,
  })
}
// 互动数据导出
export function exportInteract(data) {
  return request({
    url: service + '/moments/statistic/interact/export',
    params: data,
    responseType: 'blob',
  })
}
