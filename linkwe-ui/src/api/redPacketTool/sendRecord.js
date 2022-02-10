import request from '@/utils/request'
const service = window.CONFIG.services.system + window.CONFIG.services.wecom + '/RedEnvelopes'

/**
 * 发放记录-发放客户
 * @param {*} params
 * {
        pageNum: 1,
        pageSize: 10,
        userId: '', // 员工id
        customerName: '', // 客户姓名
        sendState: '', // 发送状态:1:待领取;2:已领取;3:发放失败;4:退款中;5:已退款
        beginTime: '', // 创建开始时间
        endTime: '' // 创建结束时间
}
 */
export function getList(params) {
  return request({
    url: service + '/findRedEnveForUser',
    params
  })
}

/**
 * 发放记录-发放客户导出
 * params  * {
        userId: '', // 员工id
        customerName: '', // 客户姓名
        sendState: '', // 发送状态:1:待领取;2:已领取;3:发放失败;4:退款中;5:已退款
        beginTime: '', // 创建开始时间
        endTime: '' // 创建结束时间
}
 */
export function exportCustomer(params) {
  return request({
    url: service + '/exportRedEnveForUser',
    params
  })
}

/**
 * 发放记录-发放客户群
 * @param {*} params
 * {
        pageNum: 1,
        pageSize: 10,
        userId: '', // 员工id
        groupName: '', // 客户群名
        redEnvelopeType: '', // 1: 普通红包2:拼手气红包
        beginTime: '', // 创建开始时间
        endTime: '' // 创建结束时间
}
 */
export function getListgroupName(params) {
  return request({
    url: service + '/findRedEnveForUser',
    params
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
export function addOrUpdate(params) {
  return request({
    url: service + '/addorUpdateRedEnvelopes',
    method: 'post',
    data: params
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
export function startOrStop(params) {
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
export function remove(ids) {
  return request({
    url: service + `deleteRedEnvelop/${ids}`,
    method: 'delete'
  })
}
