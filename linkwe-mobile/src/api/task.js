import request from '@/utils/request'
const wecom = window.lwConfig.services.wecom
const service = wecom + '/fission'
const serviceWeChat = window.lwConfig.services.weChat + '/fission'

/**
 * 生成带二维码的海报
 * @param {*} data
 {
  taskFissionId integer int64任务id
  tenantId integer int32
  租户ID userId string 员工ID
 }
 * @returns
 */
export function getPoster(data) {
  return request({ url: serviceWeChat + '/poster', method: 'post', data })
}

/**
 * 根据任务id获取任务进度
 * @param {*} data
 {
  taskFissionId integer int64任务id
  tenantId integer int32
  租户ID userId string 员工ID
 }
 * @returns
 */
export function getProgress(data) {
  return request({ url: serviceWeChat + '/progress', method: 'post', data })
}

export function setFissionComplete(fissionId, recordId, params) {
  return request(service + `/complete/${fissionId}/records/${recordId}`, params, 'post')
}
