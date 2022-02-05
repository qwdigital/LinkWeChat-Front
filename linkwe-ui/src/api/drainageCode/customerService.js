import request from '@/utils/request'

// 客服列表
export function getList (params) {
  return request({
    url: '/wecom/kf/list',
    params
  })
}

// 新增客服
export function addService (data) {
  return request({
    url: '/wecom/kf/add',
    method: 'post',
    data: data
  })
}

// 删除客服
export function remove (id) {
  return request({
    url: '/wecom/kf/delete/' + id,
    params
  })
}

// 场景列表
export function getSceneList (params) {
  return request({
    url: '/wecom/kf/scenes/list',
    params
  })
}

// 新增场景
export function addScene (data) {
  return request({
    url: '/wecom/kf/scenes/add',
    data: data,
    method: 'post'
  })
}

// 编辑场景
export function editScene (data) {
  return request({
    url: '/wecom/kf/scenes/edit',
    data: data,
    method: 'put'
  })
}

// 删除场景
export function deleteScene (ids) {
  return request({
    url: '/wecom/kf/scenes/delete/' + ids
  })
}