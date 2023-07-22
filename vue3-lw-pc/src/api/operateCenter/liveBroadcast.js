import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/live'
// top5列表
export function getList(params) {
  return request({
    url: service + '/findWelives',
    params,
  })
}
// 导出直播
export function liveExport(params) {
  return request({
    url: service + '/exportWeLives',
    responseType: 'blob',
    params,
  })
}
// 同步直播
export function oneStep() {
  return request({
    url: service + '/synchLive',
  })
}
/**
 * 通过id列表删除直播
 * @param {*} ids
 */
export function liveRemove(ids) {
  return request({
    url: service + '/' + ids,
    method: 'DELETE',
  })
}
/**
 * 取消直播
 */
export function cancelLive(data) {
  return request({
    url: service + '/cancelLive',
    method: 'post',
    data,
  })
}
/**
 * 新增/更新直播
 */
export function addOrUpdate(data) {
  return request({
    url: service + '/addOrUpdate',
    method: 'post',
    data,
  })
}

// 获取直播详情
export function detailLive(weLiveId) {
  return request({
    url: service + `/findLiveDetail/${weLiveId}`,
  })
}

// 分享统计-员工详情(客户或客群)
export function userDetail(params) {
  return request({
    url: service + '/findWeLiveTaskUserDetail',
    params,
  })
}

// 分享统计-客户详情(客户或客群)
export function customerDetail(params) {
  return request({
    url: service + '/findWeLiveTaskCustomerDetail',
    params,
  })
}
// 分享统计-tab
export function userDetailTab(params) {
  return request({
    url: service + '/findWeLiveTaskUserDetailTab',
    params,
  })
}
// 分享统计-客群
export function customerDetailTab(params) {
  return request({
    url: service + '/findWeLiveTaskCustomerDetailTab',
    params,
  })
}
// 获取观众列表
export function watchUserList(params) {
  return request({
    url: service + '/weLiveWatchUser',
    params,
  })
}
// 导出观看成员
export function exprotWeLiveWatchUser(params) {
  return request({
    url: service + '/exprotWeLiveWatchUser',
    responseType: 'blob',
    params,
  })
}
// 同步
export function liveOneStep(id) {
  return request({
    url: service + `/synchExecuteResult/${id}`,
  })
}
