import request from '@/utils/request'
const service = window.lwConfig.services.system + window.lwConfig.services.wecom + '/short/link'

// 智能短链

// 列表
export function getList(data) {
  return request({
    url: service + '/list',
    params: data,
  })
}

// 详情
export function getDetail(id) {
  return request({
    url: service + '/get/' + id,
  })
}

// 删除
export function remove(id) {
  return request({
    url: service + '/delete/' + id,
    method: 'DELETE',
  })
}

// 新增
export function add(data) {
  return request({
    url: service + '/add',
    method: 'POST',
    data,
  })
}

// 修改
export function update(data) {
  return request({
    url: service + '/update/' + id,
    method: 'PUT',
    data,
  })
}

// 短链数据统计（传ID查单个）
export function getAnalysis(data) {
  return request({
    url: service + '/data/statistics',
    params: data,
  })
}

// 通过短链接获取短链详情
export function getDetailByUrl(shortUrl) {
  return request({
    url: service + '/getByShort/' + shortUrl,
  })
}
