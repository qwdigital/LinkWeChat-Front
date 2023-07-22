import request from '@/utils/request'
let getway = window.lwConfig.services.wecom
const service = getway + '/tlp'
// 模板中心
// 模板新增
export function templateAdd(data) {
  return request({
    url: service + '/addOrUpdate',
    method: 'post',
    data,
  })
}
// 模板详情
export function templateDetail(tlpId) {
  return request({
    url: service + `/preview/${tlpId}`,
  })
}
