import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom + '/short/link'

// 列表
export function getList(data) {
  return request({
    url: wecom + '/promotion/list',
    method: 'get',
    params: data,
  })
}

// 新增
export function addPromotion(data) {
  return request({
    url: wecom + '/promotion/add',
    method: 'post',
    data,
  })
}

//编辑
export function editPromotion(data) {
  return request({
    url: wecom + '/promotion/edit',
    method: 'put',
    data,
  })
}

//暂存推广
export function savePromotion(data) {
  return request({
    url: wecom + '/promotion/ts',
    method: 'post',
    data,
  })
}

// 带占位码的海报
export function getPosterList(data) {
  return request({
    url: wecom + '/promotion/poster/list',
    params: data,
  })
}

// 详情
export function getDetail(id) {
  return request({
    url: wecom + '/promotion/' + id,
  })
}

// 列表删除
export function deletePomotion(id) {
  return request({
    url: wecom + '/promotion/delete/' + id,
    method: 'delete',
  })
}

// 列表批量删除
export function deleteMultPo(ids) {
  return request({
    url: wecom + '/promotion/batch/delete/' + ids,
    method: 'delete',
  })
}

// 统计 头部
export function getTotal(id) {
  return request({
    url: wecom + '/promotion/day/stat/statistics/' + id,
  })
}

// 统计 折线图
export function getLineData(data) {
  return request({
    url: wecom + '/promotion/day/stat/statistics/line',
    params: data,
  })
}
