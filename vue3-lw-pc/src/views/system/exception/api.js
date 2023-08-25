import { requestOpen } from '@/utils/request'
const { get, post, put, del: _del } = requestOpen
const serve = '/error'

/**
 * 列表
 * @param {*} data
{
  pageNum:
  pageSize:
 }
 */
export function getList(data) {
  return get(`${serve}/findWeError`, data)
}

// 详情
export function getDetail(id) {
  return get(service + '/get/' + id)
}

// 删除
export function del(id) {
  return _del(`${serve}/removeWeError/${id}`)
}

/**
 * 新增
 * @param {*} data
 * @returns
 */
export function add(data) {
  return post(`${serve}/add`, data)
}

// 修改
export function update(data) {
  return put(`${serve}/update`, data)
}
