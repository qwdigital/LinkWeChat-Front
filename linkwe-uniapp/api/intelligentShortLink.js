import request from '@/utils/request'
import config from '@/config.js'
const service = config.services.wecom + '/short/link'

// 智能短链

// 列表
export function getList(data) {
  return request({
    url: service + '/list',
    params: data,
  })
}

// 通过短链接获取短链详情
export function getDetail(path) {
  return request({
    url: service + '/getByShort/' + path,
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
export function getAnalysis(id) {
  return request({
    url: service + '/data/statistics',
    params: { id },
  })
}

/**
 * 短链折线统计
 * {
beginTime,,string,false,,开始时间
endTime,,string,false,,结束时间
id,,integer,false,,主键id
}
 */
export function getLineAnalysis(data) {
  return request({
    url: service + '/line/statistics',
    params: data,
  })
}

// 通过短链接获取短链详情
export function getDetailByUrl(shortUrl) {
  return request({
    url: service + '/getByShort/' + shortUrl,
  })
}
