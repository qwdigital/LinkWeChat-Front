import request from '@/utils/request'
let getway = window.lwConfig.services.wecom
const service = getway + '/material'
// 素材详情-数据趋势
export function getCount(params) {
  return request({
    url: service + '/count',
    params,
  })
}

// top5列表
export function getTableTotal(params) {
  return request({
    url: service + '/analyseTop',
    params,
  })
}
// 素材详情-数据明细 分页
export function getTableDetail(params) {
  return request({
    url: service + '/dataDetail',
    params,
  })
}

// 分组
// 批量删除或移动
export function delAndRemoves(data) {
  return request({
    url: getway + '/category/delOrMuchMove',
    method: 'DELETE',
    data,
  })
}

export function lexicalAdd(data) {
  return request({
    url: service,
    method: 'post',
    data,
  })
}
// 详情
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
export function lexicalRemove(talkIds) {
  return request({
    url: service + '/del' + talkIds,
    method: 'DELETE',
  })
}
