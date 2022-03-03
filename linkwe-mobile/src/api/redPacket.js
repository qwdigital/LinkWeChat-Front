import request from '@/utils/request'
const wecom = window.CONFIG.services.wecom
const service = wecom + '/RedEnvelopes'

/**
 * 获取企业红包模版列表
 * @param {*} sceneType 1:客户 2:客群
 * @returns
 */
export function getList(sceneType) {
  return request({
    url: service + '/findCompanyRedEnvelopes',
    params: {
      sceneType,
    },
  })
}

/**
 * 为客户发送个人红包
 * @param {*} data
 * {
  "redEnvelopeAmount": "2.00",
  "redEnvelopeName": "个人客户红包",
  "sendUserId": "45DuXiangShangQingXie",
  "externalUserId": "wmiGuBCgAA-3Xa7nUo7-8q492q0nmZ5A"
}
 * @returns
 */
export function sendCustomerPersonalRedPacket(data) {
  return request({
    url: service + '/sendReEnvelopesToCustomer',
    method: 'post',
    data: data,
  })
}

/**
 * 为客户发送企业红包
 * @param {*} data
{
  "redenvelopesId": "1494182309006471169",
  "sendUserId": "45DuXiangShangQingXie",
  "externalUserId": "wmiGuBCgAA-3Xa7nUo7-8q492q0nmZ5A"
}
 * @returns
 */
export function sendCustomerEnterpriseRedPacket(data) {
  return request({
    url: service + '/sendCompanyEnvelopesToCustomer',
    method: 'post',
    data: data,
  })
}

/**
 * 为客户群发送个人红包
 * @param {*} data
{
  "redEnvelopeAmount": "28", // 红包金额
  "redEnvelopeName": "队起单元", // 红包名
  "redEnvelopeNum": 45, // 红包数量
  "sendUserId": "31", // 发送人id
  "redEnvelopesType":1, // 2, 红包类型 1: 普通红包 2:拼手气红包
  "chatId": "59" // 群id
}
 * @returns
 */
export function sendCustomerGroupPersonalRedPacket(data) {
  return request({
    url: service + '/sendPersonReEnvelopesToGroup',
    method: 'post',
    data: data,
  })
}

/**
 * 为客户群发送企业红包
 * @param {*} data
{
  "redenvelopesId": "1494182309006471169", // 红包id
  "redEnvelopeNum": 17,
  "chatId": "88",
  "sendUserId": "76",
  "redEnvelopesType": 25
}
 * @returns
 */
export function sendCustomerGroupEnterpriseRedPacket(data) {
  return request({
    url: service + '/sendCompanyEnvelopesToGroup',
    method: 'post',
    data: data,
  })
}

/**
 * 获取红包封面信息 （公司名，logo）
 * @returns
 */
export function getRedPacketInfo() {
  return request({
    url: service + '/findRedEnvelopesInfo',
  })
}

/**
 * 红包领取接口
 * @param {*} params
{
  "orderNo": "1494182309006471169", // 订单id
  "openId": 17, // 客户公众号id
  "appId": "88", // 微信公众号id
  "externalUserid": "76", // 客户企微id
}
 * @returns
 */
export function receiveRedPacket(params) {
  return request({
    url: service + '/receiveRedEnvelopes',
    params,
  })
}

/**
 * 校验客户是否已领取过红包
 * @param {*}
{
  "orderNo": "1494182309006471169", // 订单id
  "openId": "76", // 客户公众号id
}
 * @returns 返回true的时候客户已领取过红包，false客户未领取红包
 */
export function getReceiveStatus(params) {
  return request({
    url: service + '/checkRecevieRedEnvelopes',
    params,
  })
}

/**
 * 红包领取列表
 * @param {*}
{
  "orderNo": "1494182309006471169", // 订单id
  "openId": "76", // 客户公众号id
  "appld": 17, // 微信公众号id
  receiveName: 领取人姓名
  avalar: 领取人头像
  "chatId": 17, // 群id
}
 * @returns
 */
export function getReceiveList(params) {
  return request({
    url: service + '/receiveRedEnvelopesLists',
    params,
  })
}
