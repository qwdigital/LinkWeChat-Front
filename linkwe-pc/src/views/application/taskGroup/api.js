import request from '@/utils/request'
const service = window.lwConfig.services.system
const wecom = window.lwConfig.services.system + window.lwConfig.services.wecom + '/fission'

// 列表
export function getList(data) {
  return request({
    url: wecom + '/list',
    method: 'get',
    params: data
  })
}

// 列表删除
export function deleteFassion(id) {
  return request({
    url: wecom + '/' + id,
    method: 'delete'
  })
}

// 列表批量删除
export function deleteMultFa(ids) {
  return request({
    url: wecom + '/' + ids,
    method: 'delete'
  })
}

// 新建
export function addFassion(data) {
  return request({
    url: wecom + '/add',
    method: 'post',
    data
  })
}

// 编辑
export function editFassion(data) {
  return request({
    url: wecom + '/update',
    method: 'put',
    data
  })
}

// 获取任务详情
export function getFassionDetail(id) {
  return request({
    url: wecom + '/getWeFissionDetail/' + id
  })
}
