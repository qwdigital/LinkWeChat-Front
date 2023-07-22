import request from '@/utils/request'
let getway = window.lwConfig.services.wecom
const service = getway + '/content/talk'
// 话术中心
// 企业话术
// 新增
export function lexicalAdd(data) {
  return request({
    url: service,
    method: 'post',
    data,
  })
}
// 话术详情
export function lexicalDetail(talkId) {
  return request({
    url: service + `/detail/${talkId}`,
  })
}
//分页查询
export function getLexicalList(params) {
  return request({
    url: service + '/selectPage',
    method: 'get',
    params,
  })
}
// 批量删除
export function scriptRemove(talkIds) {
  return request({
    url: service + '/del/' + talkIds,
    method: 'DELETE',
  })
}
// 话术素材明细
export function getLexicalDetail(params) {
  return request({
    url: service + '/detail/getTalkMaterial',
    method: 'get',
    params,
  })
}
// 话术分析-数据明细
export function getTalkMaterial(params) {
  return request({
    url: service + '/detail/getTalkMaterial',
    params,
  })
}
