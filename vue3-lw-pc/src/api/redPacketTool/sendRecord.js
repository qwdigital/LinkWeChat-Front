import request from '@/utils/request'
const service = window.lwConfig.services.wecom + '/RedEnvelopes'

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
    params,
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
    params,
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
export function getListGroup(params) {
  return request({
    url: service + '/findRedEnveForGroup',
    params,
  })
}

/**
 * 发放记录-发放客户群-获取群成员领取红包列表
 * @param {*} params
 * {
        pageNum: 1,
        pageSize: 10,
          chatId: '' // 群id
          orderNo: '' //订单id
}
 */
export function getListGroupUser(params) {
  return request({
    url: service + '/findRedEnveForGroupUser',
    params,
  })
}

/**
 * 发放记录-发放客户群导出
 * params  * {
        userId: '', // 员工id
        groupName: '', // 客户群名
        redEnvelopeType: '', // 1: 普通红包2:拼手气红包
        beginTime: '', // 创建开始时间
        endTime: '' // 创建结束时间
}
 */
export function exportGroup(params) {
  return request({
    url: service + '/exportRedEnveForGroup',
    params,
  })
}
