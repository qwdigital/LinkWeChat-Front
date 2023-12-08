import { requestOpen } from '@/utils/request'
const { get, post, put, del: _del } = requestOpen
const serve = '/groupchat'

/**
 * 获取列表
 * @param {*} data
{
  memberName 群成员名称
}
 *
 */
export function getList(data) {
  return get(serve + '/findDeduplications', data)
}

/**
 * 客户加入或移除黑名单
 * @param {*} data
{
  "externalUserids": "string",
  "isJoinBlacklist": 0  //0:加入黑名单;1:不加入黑名单;
}
 * @returns
 */
export function setBlackList(data) {
  return post(serve + '/joinOrRemoveBlackList', data)
}

/**
 * 群去重提醒
 * @param {*} data
{
  "externalUserids": "多个企业微信客户id查询",
}
 * @returns
 */
export function remindDuplicateMembers(externalUserids) {
  return post(serve + '/remindDuplicateMembers', { externalUserids })
}
