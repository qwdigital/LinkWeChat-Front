import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom

// 新增
export function addSop(data) {
  return request({
    url: wecom + '/sop/createWeSop',
    method: 'post',
    data: data,
  })
}

// 更新
export function updateSop(data) {
  return request({
    url: wecom + '/sop/updateWeSop',
    method: 'put',
    data: data,
  })
}

//客户属性
export function getBaseData(data) {
  return request({
    url: wecom + '/strategic/crowd/getDownOptions',
    method: 'post',
    data: data,
  })
}

// 列表
export function getTableList(data) {
  return request({
    url: wecom + '/sop/findWeSopLists',
    params: data,
  })
}

// 列表 -- 删除
export function deleteTableItems(ids) {
  return request({
    url: wecom + '/sop/' + ids,
    method: 'delete',
  })
}

// 列表 -- 启停
export function updateSopState(data) {
  return request({
    url: wecom + '/sop/updateSopState',
    method: 'put',
    data,
  })
}

// 详情
export function getSopDetail(id) {
  return request({
    url: wecom + '/sop/getDetail/' + id,
  })
}

// 详情 --tab
export function getDetailTab(id) {
  return request({
    url: wecom + '/sop/findWeSopDetailTab/' + id,
  })
}

export function getChannelDetail(data) {
  return request({
    url: wecom + '/strategic/crowd/getCorpStateTagSource',
    params: data,
  })
}

// 详情 --列表详情 - 客户
export function getCustomerDetailTable(data) {
  return request({
    url: wecom + '/sop/findWeSopDetailCustomer',
    params: data,
  })
}

// 详情 --列表详情 - 客群
export function getGroupDetailTable(data) {
  return request({
    url: wecom + '/sop/findWeSopDetailGroup',
    params: data,
  })
}

// 详情  --推送内容 -客户
export function getCustomerSendContent(data) {
  return request({
    url: wecom + '/sop/findCustomerExecuteContent',
    params: data,
  })
}

// 详情  --推送内容 -客群
export function getGroupSendContent(data) {
  return request({
    url: wecom + '/sop/findGroupExecuteContent',
    params: data,
  })
}

// 详情 数据同步
export function getSyncData(id) {
  return request({
    url: wecom + '/sop/synchSopExecuteResult/' + id,
  })
}
