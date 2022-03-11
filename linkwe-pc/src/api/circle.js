import request from '@/utils/request'
const service = window.CONFIG.services.system

// 朋友圈 企业动态 列表
export function getEnterpriceList (data) {
  return request({
    url: service + '/wecom/moments/list',
    params: data
  })
}

// 朋友圈 企业 同步
export function syncHMoments (data) {
  return request({
    url: service + '/wecom/moments/synchMoments',
    params: data
  })
}

// 朋友圈 企业 详情
export function getDetail (id) {
  return request({
    url: service + '/wecom/moments/findMomentsDetail/' + id
  })
}

// 朋友圈  企业  发布动态
export function gotoPublish (data) {
  return request({
    url: service + '/wecom/moments/addOrUpdate',
    method: 'post',
    data: data
  })
}

