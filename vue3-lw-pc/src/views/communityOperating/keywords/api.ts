import { pageParams } from 'env'
import { requestOpen } from '@/utils/request'
const { get, post, put, del: _del } = requestOpen
const service = '/communityKeywordGroup'

/**
 * 获取关键词拉群列表
 * @param {*} params
 * {title}
 */
export const getList = (data: pageParams) => get(`${service}/findLists`, data)

/**
 * 获取关键词拉群详情
 * @param {*} params
 */
export const getDetail = (id) => get(`${service}/getKeyWordGroupBaseInfo/${id}`)

/**
 * 新增或更新关键词群
 * @param {Object} data
{
  "taskName": "string",
  "groupCodeId": 0,
  "welcomeMsg": "string",
  "keywords": "string",
}
 */
export const addOrUpdate = (data) => post(`${service}/createOrUpdateBaseInfo`, data)

/**
 * 删除关键词拉群
 * @param {*} ids
 */
export const remove = (ids) => _del(`${service}/batchRemoveKeyWordGroupSub/${ids}`)

/**
 * 新增或更新关键词群点击取消时触发(避免还未新建,导致群活码创建过多占位)
 * @param {Object} data
{
  "taskName": "string",
  "groupCodeId": 0,
  "welcomeMsg": "string",
  "keywords": "string",
}
 */
export const addOrUpdateCancel = (data) => post(`${service}/cancelCreateBaseInfo`, data)
