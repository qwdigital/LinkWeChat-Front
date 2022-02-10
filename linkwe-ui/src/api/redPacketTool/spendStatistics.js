import request from '@/utils/request'
const service = window.CONFIG.services.system + window.CONFIG.services.wecom + '/RedEnvelopes'

/**
 * 设置红包限额
 * params {
    "id":12321312,//有就传没有就传null
    "singleDayPay": 60, //单日付款总额
    "singleCustomerReceiveNum": 17, //单日客户收红包次数
    "singleCustomerReceiveMoney": 69 //单日每客户收红包总额
}
 */
export function limitRedEnvelopes (params) {
  return request({
    url: service + '/limitRedEnvelopes',
    method: 'post',
    data: params
  })
}

/**
 * 红包限额获取
 */
export function findLimitRedEnvelopes (params) {
  return request({
    url: service + '/findLimitRedEnvelopes'
  })
}

/**
 * 新建或编辑红包
 * params {
    "money": 45, //金额
    "sceneType": 37,//场景 1:客户;2:客群;3:客户与客群
    "name": "华东界派" //红包名称
}
 */
export function addorUpdateRedEnvelopes (params) {
  return request({
    url: service + '/addorUpdateRedEnvelopes',
    method: 'post',
    data: params
  })
}

/**
 * 获取企业红包列表
 * @param {*} params
 * {
pageNum	是 当前页
pageSize	是 每页显示条数
status	是 0:启用;1:停用
sceneType	是 1:客户;2:客群;3:客户与客群
}
 */
export function redEnvelopes (params) {
  return request({
    url: service + '/redEnvelopes',
    params
  })
}

/**
 * 启用或者停用红包
 * @param {*}
{
    "id": 1483268831952322561, //主键
    "status": 1 //0:启用;1:停用
}
 */
export function startOrStopRedEnvelope (params) {
  return request({
    url: service + '/startOrStopRedEnvelope',
    method: 'put',
    data: params
  })
}

/**
 * 删除红包
ids	红包主键，多个用逗号隔开
 */
export function deleteRedEnvelop (ids) {
  return request({
    url: service + `deleteRedEnvelop/${ids}`,
    method: 'delete'
  })
}

/**
 * 新建或编辑员工限额
 * @param {*} params
{
    "id":1483367396696686593,//存在则传，不存在则传null
    "userId": "haon", //员工id
    "singleCustomerReceiveNum": 39, //单日每员工发红包次数
    "singleCustomerReceiveMoney": 23.94 //单日每员工发红包总额
}
 */
export function addOrUpdateUserRedEnvelopsLimit (params) {
  return request({
    url: service + '/addOrUpdateUserRedEnvelopsLimit',
    method: 'post',
    data: params
  })
}

/**
 * 批量更新或编辑员工限额
 * @param {*} params
{
    "ids": "1483367396696686593,1483369708055994370",//id,多个使用逗号隔开
    "singleCustomerReceiveNum": 90,//单日每员工发红包次数
    "singleCustomerReceiveMoney": 90 //单日每员工发红包总额
}
 */
export function batchUpdateUserRedEnvelopsLimit (params) {
  return request({
    url: service + '/batchUpdateUserRedEnvelopsLimit',
    method: 'post',
    data: params
  })
}

/**
 * 员工限额列表获取
 * @param {*} params
{
pageNum	是 当前页
pageSize	是 每页显示条数
userId	是 检索条件，传员工id
}
 */
export function findLimitUserRedEnvelops (params) {
  return request({
    url: service + '/findLimitUserRedEnvelops',
    params
  })
}
