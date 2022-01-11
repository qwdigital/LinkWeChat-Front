// import {
//     envelope_list,
//     envelope_addOrUpdate,
//     envelope_getInfo,
//     envelope_remove,
//     limit_list,
//     limit_add,
//     limit_update,
//     scop_list,
//     scop_remove,
//     scop_add,
//     scop_update,
// } from '@/api/appTool/actionUrl'
import request from '@/utils/request'

export function getList(context, params) {
  return request(context, {
    url: envelope_list,
    params
  })
}
export function add(context, data) {
  return request(context, {
    url: envelope_addOrUpdate,
    method: 'post',
    data
  })
}
export function update(context, data) {
  return request(context, {
    url: envelope_addOrUpdate,
    method: 'put',
    data
  })
}
export function remove(context, redIds) {
  return request(context, {
    url: envelope_remove,
    method: 'delete',
    data: { redIds }
  })
}
export function getInfo(context, redId) {
  return request(context, {
    url: envelope_getInfo,
    params: { redId }
  })
}
/**
 * 红包管理-限额
 */
export function addLimit(context, data) {
  return request(context, {
    url: limit_add,
    method: 'post',
    data
  })
}
export function updateLimit(context, data) {
  return request(context, {
    url: limit_update,
    method: 'put',
    data
  })
}
export function getLimitList(context, params) {
  return request(context, {
    url: limit_list,
    method: 'get',
    params
  })
}
/**
 * 员工管理
 */
export function getScopList(context, params) {
  return request(context, {
    url: scop_list,
    params
  })
}

export function addScop(context, data) {
  return request(context, {
    url: scop_add,
    data,
    method: 'post'
  })
}
export function updatedScop(context, data) {
  return request(context, {
    url: scop_update,
    data,
    method: 'put'
  })
}
export function removeScop(context, ids) {
  return request(context, {
    url: scop_remove,
    params: {
      ids
    },
    method: 'delete'
  })
}
