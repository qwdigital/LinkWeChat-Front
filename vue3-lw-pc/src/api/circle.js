import request from '@/utils/request'
const service = window.lwConfig.services.system + window.lwConfig.services.wecom

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
export function syncHMoments(data) {
  return request({
    url: service + '/moments/sync/' + data,
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
