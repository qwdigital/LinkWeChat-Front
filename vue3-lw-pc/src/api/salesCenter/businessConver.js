import request from '@/utils/request'
let getway = window.lwConfig.services.wecom
const service = getway + '/strackStage'

// 列表
export function getList(params) {
  return request({
    url: service + '/findWeStrackStage',
    method: 'get',
    params,
  })
}

// 新增
export function addField(data) {
  return request({
    url: service + '/add',
    data,
    method: 'post',
  })
}

// 更新
export function updateField(data) {
  return request({
    url: service + '/batchUpdate',
    data,
    method: 'put',
  })
}

// 删除
export function deleteField(data) {
  return request({
    url: service + '/delete',
    method: 'delete',
    params: data,
  })
}

// 排序更新
export function multiField(data) {
  return request({
    url: service + '/batchUpdateSysField',
    method: 'post',
    data,
  })
}

// 获取对应客户数
export function getCustomerNum(val) {
  return request({
    url: service + '/getStrackStageCustomerNum/' + val,
  })
}
