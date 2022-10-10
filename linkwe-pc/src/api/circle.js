import request from '@/utils/request'
const service = window.CONFIG.services.system + window.CONFIG.services.wecom

// 朋友圈 企业动态 列表
export function getEnterpriceList (data) {
  return request({
    url: service + '/moments/list',
    params: data
  })
}

// 朋友圈 企业 同步
export function syncHMoments (data) {
  return request({
    url: service + '/moments/synchMoments',
    params: data
  })
}

// 朋友圈 企业 详情
export function getDetail (id) {
  return request({
    url: service + '/moments/findMomentsDetail/' + id
  })
}

// 朋友圈  企业  发布动态
export function gotoPublish (data) {
  return request({
    url: service + '/moments/addOrUpdate',
    method: 'post',
    data: data
  })
}

